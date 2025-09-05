const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { db } = require('../config/database');

class User {
  constructor(data) {
    this.id = data.id;
    this.email = data.email;
    this.passwordHash = data.password_hash;
    this.selectedBoardId = data.selected_board_id;
    this.selectedClassId = data.selected_class_id;
    this.points = data.points || 0;
    this.currentStreak = data.current_streak || 0;
    this.lastActiveDate = data.last_active_date;
    this.createdAt = data.created_at;
    this.updatedAt = data.updated_at;
  }

  // Create a new user
  static async create(userData) {
    const { email, password, selectedBoardId, selectedClassId } = userData;
    
    // Hash password
    const saltRounds = 12;
    const passwordHash = await bcrypt.hash(password, saltRounds);
    
    const [user] = await db('users')
      .insert({
        email,
        password_hash: passwordHash,
        // Explicitly store NULL if not provided to avoid undefined issues
        selected_board_id: selectedBoardId ?? null,
        selected_class_id: selectedClassId ?? null
      })
      .returning('*');
    
    return new User(user);
  }

  // Find user by email
  static async findByEmail(email) {
    const user = await db('users')
      .where({ email })
      .first();
    
    return user ? new User(user) : null;
  }

  // Find user by ID
  static async findById(id) {
    const user = await db('users')
      .where({ id })
      .first();
    
    return user ? new User(user) : null;
  }

  // Verify password
  async verifyPassword(password) {
    return await bcrypt.compare(password, this.passwordHash);
  }

  // Generate JWT token
  generateToken() {
    return jwt.sign(
      { 
        userId: this.id, 
        email: this.email 
      },
      process.env.JWT_SECRET || 'your-secret-key',
      { expiresIn: '7d' }
    );
  }

  // Update user profile
  async updateProfile(updateData) {
    const allowedFields = ['selected_board_id', 'selected_class_id', 'points', 'current_streak', 'last_active_date'];
    const updates = {};
    
    allowedFields.forEach(field => {
      if (updateData[field] !== undefined) {
        updates[field] = updateData[field];
      }
    });

    if (Object.keys(updates).length === 0) {
      return this;
    }

    const [updatedUser] = await db('users')
      .where({ id: this.id })
      .update(updates)
      .returning('*');

    return new User(updatedUser);
  }

  // Get user progress
  async getProgress() {
    const progress = await db('user_progress')
      .join('content', 'user_progress.content_id', 'content.id')
      .join('chapters', 'content.chapter_id', 'chapters.id')
      .join('subjects', 'chapters.subject_id', 'subjects.id')
      .where('user_progress.user_id', this.id)
      .select(
        'user_progress.*',
        'chapters.name as chapter_name',
        'subjects.name as subject_name',
        'content.content_type'
      );

    return progress;
  }

  // Get quiz attempts
  async getQuizAttempts() {
    const attempts = await db('quiz_attempts')
      .join('content', 'quiz_attempts.quiz_content_id', 'content.id')
      .join('chapters', 'content.chapter_id', 'chapters.id')
      .join('subjects', 'chapters.subject_id', 'subjects.id')
      .where('quiz_attempts.user_id', this.id)
      .select(
        'quiz_attempts.*',
        'chapters.name as chapter_name',
        'subjects.name as subject_name'
      )
      .orderBy('quiz_attempts.attempted_at', 'desc');

    return attempts;
  }

  // Convert to JSON (exclude sensitive data)
  toJSON() {
    return {
      id: this.id,
      email: this.email,
      selectedBoardId: this.selectedBoardId,
      selectedClassId: this.selectedClassId,
      points: this.points,
      currentStreak: this.currentStreak,
      lastActiveDate: this.lastActiveDate,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt
    };
  }
}

module.exports = User;
