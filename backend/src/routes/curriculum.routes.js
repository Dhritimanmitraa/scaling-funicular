const express = require('express');
const CurriculumController = require('../controllers/curriculum.controller');
const { authenticateToken, requireCurriculumSelection } = require('../middleware/auth.middleware');

const router = express.Router();

// Public routes
router.get('/boards', CurriculumController.getBoards);
router.get('/boards/:boardId/classes', CurriculumController.getClasses);
// Support query style: /curriculum/classes?board_id=...
router.get('/classes', CurriculumController.getClasses);
router.get('/classes/:classId/subjects', CurriculumController.getSubjects);
router.get('/subjects/:subjectId/chapters', CurriculumController.getChapters);
router.get('/chapters/:chapterId', CurriculumController.getChapterDetails);

// Protected routes
router.get('/user-curriculum', authenticateToken, CurriculumController.getUserCurriculum);

module.exports = router;
