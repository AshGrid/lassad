// classRoutes.js
import express from 'express';
import {
    createClass,
    getClasses,
    updateClass,
    deleteClass,
    addStudentToClass,
    removeStudentFromClass, addSubjectToClass
} from '../controllers/classController.js';

const router = express.Router();

// Routes for classes
router.post('/', createClass);                             // Create a new class
router.get('/', getClasses);                               // Get all classes
router.put('/:id', updateClass);                          // Update a class by ID
router.delete('/:id', deleteClass);                       // Delete a class by ID
router.post('/add-student', addStudentToClass);          // Add a student to a class
router.post('/add-subject', addSubjectToClass);          // Add a student to a class
router.post('/remove-student', removeStudentFromClass);  // Remove a student from a class

export default router;
