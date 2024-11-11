import Exam from '../models/examModel.js';
import User from '../models/userModel.js';

// Create a new exam
export const createExam = async (req, res) => {
  const { courseId, instructorId } = req.body; // Extract instructorId from the request body

  try {
    // Verify that the instructor exists and has the correct role
    const instructor = await User.findById(instructorId);
    if (!instructor || instructor.role !== 'Instructor') {
      return res.status(400).json({ message: 'Invalid instructor ID or user is not an instructor' });
    }

    const examData = { courseId, instructorId };

    // Check if a file is uploaded
    if (req.file) {
      examData.examFile = req.file.buffer;
      examData.examFileType = req.file.mimetype;
    }

    const exam = await Exam.create(examData);
    res.status(201).json({ exam });
  } catch (error) {
    res.status(500).json({ message: 'Error creating exam', error });
  }
};

export const addResponse = async (req, res) => {
    const { examId, userId } = req.params;
    const { responseBody } = req.body;
  
    try {
      const exam = await Exam.findById(examId);
      if (!exam) return res.status(404).json({ message: 'Exam not found' });
  
      // Add response to the exam
      exam.responses.push({ userId, responseBody });
      await exam.save();
  
      res.status(201).json({ exam });
    } catch (error) {
      res.status(500).json({ message: 'Error adding response', error });
    }
  };

export const getExam = async (req, res) => {
    const { examId } = req.params;
  
    try {
      const exam = await Exam.findById(examId).populate('instructorId', 'username email');
      if (!exam) return res.status(404).json({ message: 'Exam not found' });
  
      res.status(200).json(exam);
    } catch (error) {
      res.status(500).json({ message: 'Error retrieving exam', error });
    }
  };

// Get exam by courseId
export const getExamByCourseId = async (req, res) => {
  const { courseId } = req.params;

  try {
    const exam = await Exam.findOne({ courseId });

    if (!exam) {
      return res.status(404).json({ message: 'Exam not found for this course' });
    }

    // Convert exam file to base64 if it exists and is in Buffer form
    const examData = exam.toObject();
    if (exam.examFile && Buffer.isBuffer(exam.examFile)) {
      examData.examFile = `data:${exam.examFileType};base64,${exam.examFile.toString('base64')}`;
    }

    res.status(200).json(examData);
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving exam', error });
  }
};
