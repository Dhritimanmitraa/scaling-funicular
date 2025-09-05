const { validationResult } = require('express-validator');
const { db } = require('../config/database');
const aiService = require('../services/ai.service');
const User = require('../models/user.model');

class ContentController {
  // Generate or get video content for a chapter
  static async getVideoContent(req, res) {
    try {
      const { chapterId } = req.params;
      const user = req.user;

      // Get chapter details
      const chapter = await db('chapters')
        .join('subjects', 'chapters.subject_id', 'subjects.id')
        .join('classes', 'subjects.class_id', 'classes.id')
        .join('boards', 'classes.board_id', 'boards.id')
        .where('chapters.id', chapterId)
        .select(
          'chapters.id',
          'chapters.name as chapter_name',
          'subjects.name as subject_name',
          'classes.class_number',
          'boards.name as board_name'
        )
        .first();

      if (!chapter) {
        return res.status(404).json({
          success: false,
          message: 'Chapter not found'
        });
      }

      // Check if video content already exists
      let videoContent = await db('content')
        .where({ 
          chapter_id: chapterId, 
          content_type: 'video' 
        })
        .first();

      // If no video exists, generate one
      if (!videoContent) {
        try {
          // Generate video script
          const script = await aiService.generateVideoScript(
            chapter.chapter_name,
            chapter.subject_name,
            chapter.class_number,
            chapter.board_name
          );

          // Generate video (use placeholder for development)
          const videoData = process.env.NODE_ENV === 'production' 
            ? await aiService.generateVideo(script, chapter.chapter_name, chapter.subject_name)
            : await aiService.generatePlaceholderVideo(chapter.chapter_name, chapter.subject_name);

          // Save video content to database
          const [newContent] = await db('content')
            .insert({
              chapter_id: chapterId,
              content_type: 'video',
              content_data: videoData
            })
            .returning('*');

          videoContent = newContent;
        } catch (aiError) {
          console.error('AI generation error:', aiError);
          return res.status(500).json({
            success: false,
            message: 'Failed to generate video content',
            error: aiError.message
          });
        }
      }

      res.json({
        success: true,
        data: {
          content: {
            id: videoContent.id,
            type: videoContent.content_type,
            data: videoContent.content_data,
            createdAt: videoContent.created_at
          },
          chapter: {
            id: chapter.id,
            name: chapter.chapter_name,
            subjectName: chapter.subject_name,
            classNumber: chapter.class_number,
            boardName: chapter.board_name
          }
        }
      });
    } catch (error) {
      console.error('Get video content error:', error);
      res.status(500).json({
        success: false,
        message: 'Failed to get video content'
      });
    }
  }

  // Generate or get quiz content for a chapter
  static async getQuizContent(req, res) {
    try {
      const { chapterId } = req.params;
      const user = req.user;

      // Get chapter details
      const chapter = await db('chapters')
        .join('subjects', 'chapters.subject_id', 'subjects.id')
        .join('classes', 'subjects.class_id', 'classes.id')
        .join('boards', 'classes.board_id', 'boards.id')
        .where('chapters.id', chapterId)
        .select(
          'chapters.id',
          'chapters.name as chapter_name',
          'subjects.name as subject_name',
          'classes.class_number',
          'boards.name as board_name'
        )
        .first();

      if (!chapter) {
        return res.status(404).json({
          success: false,
          message: 'Chapter not found'
        });
      }

      // Check if quiz content already exists
      let quizContent = await db('content')
        .where({ 
          chapter_id: chapterId, 
          content_type: 'quiz' 
        })
        .first();

      // If no quiz exists, generate one
      if (!quizContent) {
        try {
          // Generate quiz using AI
          const quizData = await aiService.generateQuiz(
            chapter.chapter_name,
            chapter.subject_name,
            chapter.class_number,
            chapter.board_name
          );

          // Save quiz content to database
          const [newContent] = await db('content')
            .insert({
              chapter_id: chapterId,
              content_type: 'quiz',
              content_data: quizData
            })
            .returning('*');

          quizContent = newContent;
        } catch (aiError) {
          console.error('AI generation error:', aiError);
          return res.status(500).json({
            success: false,
            message: 'Failed to generate quiz content',
            error: aiError.message
          });
        }
      }

      res.json({
        success: true,
        data: {
          content: {
            id: quizContent.id,
            type: quizContent.content_type,
            data: quizContent.content_data,
            createdAt: quizContent.created_at
          },
          chapter: {
            id: chapter.id,
            name: chapter.chapter_name,
            subjectName: chapter.subject_name,
            classNumber: chapter.class_number,
            boardName: chapter.board_name
          }
        }
      });
    } catch (error) {
      console.error('Get quiz content error:', error);
      res.status(500).json({
        success: false,
        message: 'Failed to get quiz content'
      });
    }
  }

  // Mark video as completed
  static async markVideoCompleted(req, res) {
    try {
      const { contentId } = req.params;
      const user = req.user;

      // Verify content exists and is a video
      const content = await db('content')
        .where({ id: contentId, content_type: 'video' })
        .first();

      if (!content) {
        return res.status(404).json({
          success: false,
          message: 'Video content not found'
        });
      }

      // Check if already completed
      const existingProgress = await db('user_progress')
        .where({ user_id: user.id, content_id: contentId })
        .first();

      if (existingProgress) {
        return res.json({
          success: true,
          message: 'Video already marked as completed',
          data: { alreadyCompleted: true }
        });
      }

      // Mark as completed
      await db('user_progress').insert({
        user_id: user.id,
        content_id: contentId,
        status: 'completed'
      });

      // Award points (50 points for video completion)
      const pointsAwarded = 50;
      await user.updateProfile({
        points: user.points + pointsAwarded
      });

      res.json({
        success: true,
        message: 'Video marked as completed',
        data: {
          pointsAwarded,
          totalPoints: user.points + pointsAwarded
        }
      });
    } catch (error) {
      console.error('Mark video completed error:', error);
      res.status(500).json({
        success: false,
        message: 'Failed to mark video as completed'
      });
    }
  }

  // Submit quiz answers
  static async submitQuizAnswers(req, res) {
    try {
      const { contentId } = req.params;
      const { answers } = req.body; // Array of selected answers
      const user = req.user;

      // Validate input
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({
          success: false,
          message: 'Validation failed',
          errors: errors.array()
        });
      }

      // Get quiz content
      const quizContent = await db('content')
        .where({ id: contentId, content_type: 'quiz' })
        .first();

      if (!quizContent) {
        return res.status(404).json({
          success: false,
          message: 'Quiz content not found'
        });
      }

      const quizData = quizContent.content_data;
      const questions = quizData.questions;

      // Validate answers array length
      if (!Array.isArray(answers) || answers.length !== questions.length) {
        return res.status(400).json({
          success: false,
          message: 'Invalid answers format'
        });
      }

      // Calculate score
      let correctAnswers = 0;
      const results = questions.map((question, index) => {
        const userAnswer = answers[index];
        const correctAnswer = question.answer;
        const isCorrect = userAnswer === correctAnswer;
        
        if (isCorrect) correctAnswers++;
        
        return {
          questionIndex: index,
          question: question.q,
          userAnswer,
          correctAnswer,
          isCorrect
        };
      });

      const score = correctAnswers;
      const totalQuestions = questions.length;
      const percentage = Math.round((score / totalQuestions) * 100);

      // Save quiz attempt
      await db('quiz_attempts').insert({
        user_id: user.id,
        quiz_content_id: contentId,
        score,
        total_questions: totalQuestions
      });

      // Award points (10 points per correct answer)
      const pointsAwarded = score * 10;
      await user.updateProfile({
        points: user.points + pointsAwarded
      });

      res.json({
        success: true,
        message: 'Quiz submitted successfully',
        data: {
          score,
          totalQuestions,
          percentage,
          pointsAwarded,
          totalPoints: user.points + pointsAwarded,
          results
        }
      });
    } catch (error) {
      console.error('Submit quiz answers error:', error);
      res.status(500).json({
        success: false,
        message: 'Failed to submit quiz answers'
      });
    }
  }

  // Get content statistics
  static async getContentStats(req, res) {
    try {
      const user = req.user;

      // Get user's progress statistics
      const progressStats = await db('user_progress')
        .join('content', 'user_progress.content_id', 'content.id')
        .join('chapters', 'content.chapter_id', 'chapters.id')
        .join('subjects', 'chapters.subject_id', 'subjects.id')
        .where('user_progress.user_id', user.id)
        .select(
          'content.content_type',
          'subjects.name as subject_name',
          'chapters.name as chapter_name'
        );

      // Get quiz attempt statistics
      const quizStats = await db('quiz_attempts')
        .join('content', 'quiz_attempts.quiz_content_id', 'content.id')
        .join('chapters', 'content.chapter_id', 'chapters.id')
        .join('subjects', 'chapters.subject_id', 'subjects.id')
        .where('quiz_attempts.user_id', user.id)
        .select(
          'quiz_attempts.score',
          'quiz_attempts.total_questions',
          'subjects.name as subject_name',
          'chapters.name as chapter_name',
          'quiz_attempts.attempted_at'
        )
        .orderBy('quiz_attempts.attempted_at', 'desc');

      // Calculate statistics
      const videosWatched = progressStats.filter(p => p.content_type === 'video').length;
      const quizzesAttempted = quizStats.length;
      const averageQuizScore = quizStats.length > 0 
        ? Math.round(quizStats.reduce((sum, attempt) => sum + (attempt.score / attempt.total_questions * 100), 0) / quizStats.length)
        : 0;

      res.json({
        success: true,
        data: {
          videosWatched,
          quizzesAttempted,
          averageQuizScore,
          totalPoints: user.points,
          currentStreak: user.currentStreak,
          recentActivity: quizStats.slice(0, 5) // Last 5 quiz attempts
        }
      });
    } catch (error) {
      console.error('Get content stats error:', error);
      res.status(500).json({
        success: false,
        message: 'Failed to get content statistics'
      });
    }
  }
}

module.exports = ContentController;
