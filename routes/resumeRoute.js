import express from 'express';
import multer from 'multer';
import { upload } from '../middlewares/UploadResume.js';
import {
  addResume,
  getAllResumes,
  getResumeById,
  updateResume,
  deleteResume,
  addRating,
  addComment,
  getCommentsByResumeId,
  getResumeStars,
  markCourseAsPaid, // New method to mark course as paid
  getPaidResumes, // New method to get paid courses
  getUnpaidResumes, // New method to get unpaid courses
} from '../controllers/resumeController.js';

const router = express.Router();

// Define routes
router.post('/', upload, addResume);
router.get('/paid', getPaidResumes); // Get paid courses (should come before '/:id')
router.get('/unpaid', getUnpaidResumes); // Get unpaid courses (should come before '/:id')
router.get('/', getAllResumes);
router.get('/:id', getResumeById);
router.put('/:id', updateResume);
router.delete('/:id', deleteResume);
router.post('/:id/rate', addRating);
router.get('/getResumeStars/:id', getResumeStars);
router.post('/:id/comment', addComment);
router.get('/:id/comments', getCommentsByResumeId);
router.put('/:id/markPaid', markCourseAsPaid);

export default router;
