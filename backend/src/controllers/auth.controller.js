const { validationResult } = require('express-validator');
const User = require('../models/user.model');
const { db } = require('../config/database');

class AuthController {
  // Register new user
  static async register(req, res) {
    try {
      // Check validation errors
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({
          success: false,
          message: 'Validation failed',
          errors: errors.array()
        });
      }

      const { email, password, selectedBoardId, selectedClassId } = req.body;

      // Check if user already exists
      const existingUser = await User.findByEmail(email);
      if (existingUser) {
        return res.status(409).json({
          success: false,
          message: 'User already exists with this email'
        });
      }

      // Validate board and class exist
      if (selectedBoardId && selectedClassId) {
        const boardExists = await db('boards').where({ id: selectedBoardId }).first();
        const classExists = await db('classes').where({ 
          id: selectedClassId, 
          board_id: selectedBoardId 
        }).first();

        if (!boardExists || !classExists) {
          return res.status(400).json({
            success: false,
            message: 'Invalid board or class selection'
          });
        }
      }

      // Create user
      const user = await User.create({
        email,
        password,
        selectedBoardId,
        selectedClassId
      });

      // Generate token
      const token = user.generateToken();

      res.status(201).json({
        success: true,
        message: 'User registered successfully',
        data: {
          user: user.toJSON(),
          token
        }
      });
    } catch (error) {
      console.error('Registration error:', error);
      res.status(500).json({
        success: false,
        message: 'Registration failed'
      });
    }
  }

  // Login user
  static async login(req, res) {
    try {
      // Check validation errors
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({
          success: false,
          message: 'Validation failed',
          errors: errors.array()
        });
      }

      const { email, password } = req.body;

      // Find user
      const user = await User.findByEmail(email);
      if (!user) {
        return res.status(401).json({
          success: false,
          message: 'Invalid email or password'
        });
      }

      // Verify password
      const isValidPassword = await user.verifyPassword(password);
      if (!isValidPassword) {
        return res.status(401).json({
          success: false,
          message: 'Invalid email or password'
        });
      }

      // Update last active date
      await user.updateProfile({
        lastActiveDate: new Date().toISOString().split('T')[0]
      });

      // Generate token
      const token = user.generateToken();

      res.json({
        success: true,
        message: 'Login successful',
        data: {
          user: user.toJSON(),
          token
        }
      });
    } catch (error) {
      console.error('Login error:', error);
      res.status(500).json({
        success: false,
        message: 'Login failed'
      });
    }
  }

  // Get current user profile
  static async getProfile(req, res) {
    try {
      res.json({
        success: true,
        data: {
          user: req.user.toJSON()
        }
      });
    } catch (error) {
      console.error('Get profile error:', error);
      res.status(500).json({
        success: false,
        message: 'Failed to get profile'
      });
    }
  }

  // Update user profile
  static async updateProfile(req, res) {
    try {
      // Check validation errors
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({
          success: false,
          message: 'Validation failed',
          errors: errors.array()
        });
      }

      const { selectedBoardId, selectedClassId } = req.body;

      // Validate board and class if provided
      if (selectedBoardId && selectedClassId) {
        const boardExists = await db('boards').where({ id: selectedBoardId }).first();
        const classExists = await db('classes').where({ 
          id: selectedClassId, 
          board_id: selectedBoardId 
        }).first();

        if (!boardExists || !classExists) {
          return res.status(400).json({
            success: false,
            message: 'Invalid board or class selection'
          });
        }
      }

      // Update user
      const updatedUser = await req.user.updateProfile({
        selectedBoardId,
        selectedClassId
      });

      res.json({
        success: true,
        message: 'Profile updated successfully',
        data: {
          user: updatedUser.toJSON()
        }
      });
    } catch (error) {
      console.error('Update profile error:', error);
      res.status(500).json({
        success: false,
        message: 'Failed to update profile'
      });
    }
  }

  // Get user progress
  static async getUserProgress(req, res) {
    try {
      const progress = await req.user.getProgress();
      const quizAttempts = await req.user.getQuizAttempts();

      res.json({
        success: true,
        data: {
          progress,
          quizAttempts,
          stats: {
            totalVideosWatched: progress.filter(p => p.content_type === 'video').length,
            totalQuizzesAttempted: quizAttempts.length,
            averageQuizScore: quizAttempts.length > 0 
              ? Math.round(quizAttempts.reduce((sum, attempt) => sum + (attempt.score / attempt.total_questions * 100), 0) / quizAttempts.length)
              : 0,
            currentStreak: req.user.currentStreak,
            totalPoints: req.user.points
          }
        }
      });
    } catch (error) {
      console.error('Get user progress error:', error);
      res.status(500).json({
        success: false,
        message: 'Failed to get user progress'
      });
    }
  }
}

module.exports = AuthController;
