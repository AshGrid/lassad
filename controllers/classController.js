// classController.js
import Class from '../models/classModel.js';
import User from '../models/userModel.js';
import Subject from '../models/subjectModel.js';
// Create a new class
export const createClass = async (req, res) => {
    try {
        const { name } = req.body;
        const newClass = new Class({ name });
        await newClass.save();
        res.status(201).json(newClass);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
};

// Read all classes
export const getClasses = async (req, res) => {
    try {
        const classes = await Class.find()
            .populate('students') // Populating student details
            .populate('subjects'); // Populating subject details
        res.status(200).json(classes);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};


// Update a class
export const updateClass = async (req, res) => {
    try {
        const { id } = req.params;
        const updates = req.body;
        const updatedClass = await Class.findByIdAndUpdate(id, updates, { new: true });
        if (!updatedClass) {
            return res.status(404).json({ message: 'Class not found' });
        }
        res.status(200).json(updatedClass);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
};

// Delete a class
export const deleteClass = async (req, res) => {
    try {
        const { id } = req.params;
        const deletedClass = await Class.findByIdAndDelete(id);
        if (!deletedClass) {
            return res.status(404).json({ message: 'Class not found' });
        }
        res.status(204).send();
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Add a student to a class
export const addStudentToClass = async (req, res) => {
    try {
        const { classId, studentId } = req.body;
        const updatedClass = await Class.findByIdAndUpdate(
            classId,
            { $addToSet: { students: studentId } }, // Avoids duplicates
            { new: true }
        ).populate('students');

        if (!updatedClass) {
            return res.status(404).json({ message: 'Class not found' });
        }

        res.status(200).json(updatedClass);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
};

// Remove a student from a class
export const removeStudentFromClass = async (req, res) => {
    try {
        const { classId, studentId } = req.body;
        const updatedClass = await Class.findByIdAndUpdate(
            classId,
            { $pull: { students: studentId } }, // Removes the student
            { new: true }
        ).populate('students');

        if (!updatedClass) {
            return res.status(404).json({ message: 'Class not found' });
        }

        res.status(200).json(updatedClass);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
};

export const addSubjectToClass = async (req, res) => {
    try {
        const { classId, subjectId } = req.body;

        // Check if the subject exists
        const subject = await Subject.findById(subjectId);
        if (!subject) {
            return res.status(404).json({ message: 'Subject not found' });
        }

        // Update the class by adding the subject
        const result = await Class.updateOne(
            { _id: classId },
            { $addToSet: { subjects: subjectId } } // Using $addToSet to avoid duplicates
        );

        if (result.nModified === 0) {
            return res.status(400).json({ message: 'Subject is already added to the class' });
        }

        res.status(200).json({ message: 'Subject added to class successfully' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error', error });
    }
};
