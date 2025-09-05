const express = require('express');
const { body } = require('express-validator');
const ContentController = require('../controllers/content.controller');
const { authenticateToken, requireCurriculumSelection } = require('../middleware/auth.middleware');

const router = express.Router();

// Validation rules
const submitQuizValidation = [
  body('answers')
    .isArray({ min: 1 })
    .withMessage('Answers must be an array')
    .custom((answers) => {
      if (!answers.every(answer => typeof answer === 'string' && answer.length > 0)) {
        throw new Error('All answers must be non-empty strings');
      }
      return true;
    })
];

// All content routes require authentication and curriculum selection
router.use(authenticateToken);
router.use(requireCurriculumSelection);

// Video content routes
router.get('/video/:chapterId', ContentController.getVideoContent);
router.post('/video/:contentId/complete', ContentController.markVideoCompleted);

// Quiz content routes
router.get('/quiz/:chapterId', ContentController.getQuizContent);
router.post('/quiz/:contentId/submit', submitQuizValidation, ContentController.submitQuizAnswers);

// Statistics
router.get('/stats', ContentController.getContentStats);

module.exports = router;
