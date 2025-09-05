const express = require('express');
const AuthController = require('../controllers/auth.controller');
const { authenticateToken } = require('../middleware/auth.middleware');

const router = express.Router();

// All profile routes require authentication
router.use(authenticateToken);

// Profile routes (reusing auth controller methods)
router.get('/', AuthController.getProfile);
router.put('/', AuthController.updateProfile);
router.get('/progress', AuthController.getUserProgress);

module.exports = router;
