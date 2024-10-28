import express from 'express';
import {
    createChapter,
    getChapters,
    getChapterById,
    updateChapter,
    deleteChapter, getChaptersBySubjectId
} from '../controllers/chapterController.js';

const router = express.Router();

router.post('/', createChapter); // Create a new chapter
router.get('/', getChapters); // Get all chapters
router.get('/:id', getChapterById); // Get a chapter by ID
router.get('/chaptersBySubject/:id', getChaptersBySubjectId); // Get a chapter by ID
router.put('/:id', updateChapter); // Update a chapter by ID
router.delete('/:id', deleteChapter); // Delete a chapter by ID


export default router;
