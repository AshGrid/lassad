// subjectRoutes.js
import express from 'express';
import { createSubject, getSubjects, updateSubject, deleteSubject } from '../controllers/subjectController.js';

const router = express.Router();

// Routes for subjects
router.post('/', createSubject);       // Create a new subject
router.get('/', getSubjects);           // Get all subjects
router.put('/:id', updateSubject);      // Update a subject by ID
router.delete('/:id', deleteSubject);   // Delete a subject by ID

export default router;
