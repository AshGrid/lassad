// subjectController.js
import Subject from '../models/subjectModel.js';

// Create a new subject
export const createSubject = async (req, res) => {
    try {
        const { name } = req.body;
        const newSubject = new Subject({ name });
        await newSubject.save();
        res.status(201).json(newSubject);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
};

// Read all subjects
export const getSubjects = async (req, res) => {
    try {
        const subjects = await Subject.find().populate('chapters'); // Only populate chapters
        res.status(200).json(subjects);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Update a subject
export const updateSubject = async (req, res) => {
    try {
        const { id } = req.params;
        const updates = req.body;
        const updatedSubject = await Subject.findByIdAndUpdate(id, updates, { new: true });
        if (!updatedSubject) {
            return res.status(404).json({ message: 'Subject not found' });
        }
        res.status(200).json(updatedSubject);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
};

// Delete a subject
export const deleteSubject = async (req, res) => {
    try {
        const { id } = req.params;
        const deletedSubject = await Subject.findByIdAndDelete(id);
        if (!deletedSubject) {
            return res.status(404).json({ message: 'Subject not found' });
        }
        res.status(204).send();
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};
