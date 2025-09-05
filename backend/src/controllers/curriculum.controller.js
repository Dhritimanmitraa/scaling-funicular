const { validationResult } = require('express-validator');
const { db } = require('../config/database');

class CurriculumController {
  // Get all boards
  static async getBoards(req, res) {
    try {
      let rows;
      try {
        rows = await db('boards')
          .select('id', 'name')
          .where('is_active', true)
          .orderBy('name');
        
        console.log('Found boards in database:', rows.length);
      } catch (dbError) {
        console.error('Database error, using fallback data:', dbError.message);
        // Fallback: return default boards
        rows = [
          { id: 'board-cbse', name: 'CBSE' },
          { id: 'board-icse', name: 'ICSE' },
          { id: 'board-state', name: 'State Board' }
        ];
      }

      // If no boards found, use fallback
      if (!rows || rows.length === 0) {
        console.log('No boards found, using fallback data');
        rows = [
          { id: 'board-cbse', name: 'CBSE' },
          { id: 'board-icse', name: 'ICSE' },
          { id: 'board-state', name: 'State Board' }
        ];
      }

      console.log('Returning boards:', rows.length);
      res.json(rows);
    } catch (error) {
      console.error('Get boards error:', error);
      res.status(500).json({
        success: false,
        message: 'Failed to fetch boards'
      });
    }
  }

  // Get classes for a specific board
  static async getClasses(req, res) {
    try {
      const boardId = req.params.boardId || req.query.board_id;
      
      if (!boardId) {
        return res.status(400).json({
          success: false,
          message: 'Board ID is required'
        });
      }

      console.log('Fetching classes for board:', boardId);

      // Try to get classes from database
      let classes;
      try {
        classes = await db('classes')
          .where('board_id', boardId)
          .select('id', 'class_number')
          .orderBy('class_number');
        
        console.log('Found classes in database:', classes.length);
      } catch (dbError) {
        console.error('Database error, using fallback data:', dbError.message);
        // Fallback: return classes 5-12 for any board
        classes = Array.from({ length: 8 }, (_, i) => ({
          id: `${boardId}-class-${i + 5}`,
          class_number: i + 5
        }));
      }

      // If no classes found, use fallback
      if (!classes || classes.length === 0) {
        console.log('No classes found, using fallback data');
        classes = Array.from({ length: 8 }, (_, i) => ({
          id: `${boardId}-class-${i + 5}`,
          class_number: i + 5
        }));
      }

      // Transform to match frontend expectations
      const formattedClasses = classes.map(cls => ({
        id: cls.id,
        classNumber: cls.class_number,
        name: `Class ${cls.class_number}`
      }));

      console.log('Returning classes:', formattedClasses.length);
      res.json(formattedClasses);
    } catch (error) {
      console.error('Get classes error:', error);
      res.status(500).json({
        success: false,
        message: 'Failed to fetch classes'
      });
    }
  }

  // Get subjects for a specific class
  static async getSubjects(req, res) {
    try {
      const { classId } = req.params;

      // Validate class exists
      const classInfo = await db('classes')
        .join('boards', 'classes.board_id', 'boards.id')
        .where('classes.id', classId)
        .select('classes.id', 'classes.class_number', 'boards.name as board_name')
        .first();

      if (!classInfo) {
        return res.status(404).json({
          success: false,
          message: 'Class not found'
        });
      }

      const subjects = await db('subjects')
        .select('id', 'name')
        .where({ class_id: classId })
        .orderBy('name');

      res.json({
        success: true,
        data: { 
          class: { 
            id: classInfo.id, 
            classNumber: classInfo.class_number,
            boardName: classInfo.board_name 
          },
          subjects 
        }
      });
    } catch (error) {
      console.error('Get subjects error:', error);
      res.status(500).json({
        success: false,
        message: 'Failed to fetch subjects'
      });
    }
  }

  // Get chapters for a specific subject
  static async getChapters(req, res) {
    try {
      const { subjectId } = req.params;

      // Validate subject exists
      const subjectInfo = await db('subjects')
        .join('classes', 'subjects.class_id', 'classes.id')
        .join('boards', 'classes.board_id', 'boards.id')
        .where('subjects.id', subjectId)
        .select(
          'subjects.id', 
          'subjects.name as subject_name',
          'classes.class_number',
          'boards.name as board_name'
        )
        .first();

      if (!subjectInfo) {
        return res.status(404).json({
          success: false,
          message: 'Subject not found'
        });
      }

      const chapters = await db('chapters')
        .select('id', 'name', 'chapter_number')
        .where({ subject_id: subjectId })
        .orderBy('chapter_number');

      res.json({
        success: true,
        data: { 
          subject: { 
            id: subjectInfo.id, 
            name: subjectInfo.subject_name,
            classNumber: subjectInfo.class_number,
            boardName: subjectInfo.board_name 
          },
          chapters 
        }
      });
    } catch (error) {
      console.error('Get chapters error:', error);
      res.status(500).json({
        success: false,
        message: 'Failed to fetch chapters'
      });
    }
  }

  // Get chapter details
  static async getChapterDetails(req, res) {
    try {
      const { chapterId } = req.params;

      // Get chapter with subject, class, and board info
      const chapterInfo = await db('chapters')
        .join('subjects', 'chapters.subject_id', 'subjects.id')
        .join('classes', 'subjects.class_id', 'classes.id')
        .join('boards', 'classes.board_id', 'boards.id')
        .where('chapters.id', chapterId)
        .select(
          'chapters.id',
          'chapters.name as chapter_name',
          'chapters.chapter_number',
          'subjects.name as subject_name',
          'classes.class_number',
          'boards.name as board_name'
        )
        .first();

      if (!chapterInfo) {
        return res.status(404).json({
          success: false,
          message: 'Chapter not found'
        });
      }

      // Get existing content for this chapter
      const content = await db('content')
        .select('id', 'content_type', 'content_data', 'created_at')
        .where({ chapter_id: chapterId })
        .orderBy('created_at');

      // Separate video and quiz content
      const videoContent = content.find(c => c.content_type === 'video');
      const quizContent = content.find(c => c.content_type === 'quiz');

      res.json({
        success: true,
        data: { 
          chapter: {
            id: chapterInfo.id,
            name: chapterInfo.chapter_name,
            chapterNumber: chapterInfo.chapter_number,
            subjectName: chapterInfo.subject_name,
            classNumber: chapterInfo.class_number,
            boardName: chapterInfo.board_name
          },
          content: {
            video: videoContent ? {
              id: videoContent.id,
              data: videoContent.content_data,
              createdAt: videoContent.created_at
            } : null,
            quiz: quizContent ? {
              id: quizContent.id,
              data: quizContent.content_data,
              createdAt: quizContent.created_at
            } : null
          }
        }
      });
    } catch (error) {
      console.error('Get chapter details error:', error);
      res.status(500).json({
        success: false,
        message: 'Failed to fetch chapter details'
      });
    }
  }

  // Get user's curriculum (subjects for their selected class)
  static async getUserCurriculum(req, res) {
    try {
      const user = req.user;

      if (!user.selectedClassId) {
        return res.status(400).json({
          success: false,
          message: 'User has not selected a class yet'
        });
      }

      // Get subjects for user's selected class
      const subjects = await db('subjects')
        .join('classes', 'subjects.class_id', 'classes.id')
        .join('boards', 'classes.board_id', 'boards.id')
        .where('subjects.class_id', user.selectedClassId)
        .select(
          'subjects.id',
          'subjects.name',
          'classes.class_number',
          'boards.name as board_name'
        )
        .orderBy('subjects.name');

      res.json({
        success: true,
        data: { 
          curriculum: {
            boardName: subjects[0]?.board_name || 'Unknown',
            classNumber: subjects[0]?.class_number || 'Unknown',
            subjects
          }
        }
      });
    } catch (error) {
      console.error('Get user curriculum error:', error);
      res.status(500).json({
        success: false,
        message: 'Failed to fetch user curriculum'
      });
    }
  }
}

module.exports = CurriculumController;
