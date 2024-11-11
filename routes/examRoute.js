// routes/examRoutes.js
import express from 'express';
import { createExam, addResponse, getExam, getExamByCourseId } from '../controllers/examController.js';
import { upload } from '../middlewares/multerStorage.js';

const router = express.Router();

// Route to create a new exam
router.post('/exam', upload.single('examFile'), createExam);

// Route to add a response to an exam
router.post('/exam/response/:examId/:userId', addResponse);

// Route to get an exam by examId
router.get('/exam/:examId', getExam);

// Route to get an exam by courseId
router.get('/exam/course/:courseId', getExamByCourseId);

export default router;
