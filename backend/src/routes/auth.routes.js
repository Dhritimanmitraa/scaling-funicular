const express = require('express');
const { body } = require('express-validator');
const AuthController = require('../controllers/auth.controller');
const { authenticateToken } = require('../middleware/auth.middleware');

const router = express.Router();

// Validation rules
const registerValidation = [
  body('email')
    .isEmail()
    .normalizeEmail()
    .withMessage('Please provide a valid email'),
  body('password')
    .isLength({ min: 8 })
    .withMessage('Password must be at least 8 characters long')
    .matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/)
    .withMessage('Password must contain at least one uppercase letter, one lowercase letter, and one number'),
  body('selectedBoardId')
    .optional()
    .isString()
    .withMessage('Invalid board ID format'),
  body('selectedClassId')
    .optional()
    .isString()
    .withMessage('Invalid class ID format')
];

const loginValidation = [
  body('email')
    .isEmail()
    .normalizeEmail()
    .withMessage('Please provide a valid email'),
  body('password')
    .notEmpty()
    .withMessage('Password is required')
];

const updateProfileValidation = [
  body('selectedBoardId')
    .optional()
    .isString()
    .withMessage('Invalid board ID format'),
  body('selectedClassId')
    .optional()
    .isString()
    .withMessage('Invalid class ID format')
];

// Public routes
router.post('/register', registerValidation, AuthController.register);
router.post('/login', loginValidation, AuthController.login);

// Protected routes
router.get('/profile', authenticateToken, AuthController.getProfile);
router.put('/profile', authenticateToken, updateProfileValidation, AuthController.updateProfile);
router.get('/progress', authenticateToken, AuthController.getUserProgress);

module.exports = router;
