import path from 'path';
import fs from 'fs';
import multer from 'multer';
import Resume from '../models/resume.js';
import { upload } from '../middlewares/UploadResume.js';




export const addResume = (req, res) => {
  const { title, reference, level, price, owner, isPaid } = req.body; // Get isPaid from request body
  
  const newResume = new Resume({
    title,
    reference,
    level,
    price,
    owner,
    description: req.file ? req.file.path : req.body.description,
    ratings: [],
    comments: [],
    isPaid, // Set isPaid based on the request
  });

  newResume.save()
    .then((resume) => res.status(201).json(resume))
    .catch((error) => res.status(500).json({ error: error.message }));
};





// Get all resumes
export const getAllResumes = async (req, res) => {
  try {
    const resumes = await Resume.find(); // Fetch all resumes
    res.status(200).json(resumes);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

export const getPaidResumes = async (req, res) => {
  try {
    const paidResumes = await Resume.find({ isPaid: true });
    res.status(200).json(paidResumes);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Get all unpaid resumes (Store Courses)
export const getUnpaidResumes = async (req, res) => {
  try {
    const unpaidResumes = await Resume.find({ isPaid: false });
    res.status(200).json(unpaidResumes);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
// Controller method to update the payment status
export const markCourseAsPaid = async (req, res) => {
  const courseId = req.params.id; // Get the course ID from the URL parameter

  try {
    const course = await Resume.findById(courseId);
    if (!course) {
      return res.status(404).json({ message: 'Course not found' });
    }

    course.isPaid = true; // Mark as paid
    await course.save();
    res.status(200).json({ message: 'Course marked as paid successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};


// Get a resume by ID
export const getResumeById = async (req, res) => {
  try {
    const resume = await Resume.findById(req.params.id);
    if (!resume) {
      return res.status(404).json({ message: 'Resume not found' });
    }
    res.status(200).json(resume);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Update a resume
export const updateResume = async (req, res) => {
  try {
    const updatedResume = await Resume.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!updatedResume) {
      return res.status(404).json({ message: 'Resume not found' });
    }
    res.status(200).json(updatedResume);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Delete a resume
export const deleteResume = async (req, res) => {
  try {
    const deletedResume = await Resume.findByIdAndDelete(req.params.id);
    if (!deletedResume) {
      return res.status(404).json({ message: 'Resume not found' });
    }
    res.status(200).json({ message: 'Resume deleted successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Add a rating to a resume
export const addRating = async (req, res) => {
  const { rating } = req.body; // Expecting a rating from the request body

  if (typeof rating !== 'number' || rating < 1 || rating > 5) {
    return res.status(400).json({ message: 'Rating must be a number between 1 and 5.' });
  }

  try {
    const resume = await Resume.findById(req.params.id);
    if (!resume) {
      return res.status(404).json({ message: 'Resume not found' });
    }

    resume.ratings.push(rating);
    await resume.save();
    res.status(200).json(resume);
  } catch (err) {
    res.status(500).json({ error: err.message });
  } 
};


// In resume controller file
export const getResumeStars = async (req, res) => {
  const { id } = req.params; // Get resume ID from request parameters

  try {
    const resume = await Resume.findById(id, 'ratings'); // Find resume by ID and fetch only the 'ratings' field
    if (resume) {
      res.status(200).json(resume.ratings); // Return only the ratings array
    } else {
      res.status(404).json({ message: 'Resume not found' });
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};



// Add a comment to a resume
export const addComment = async (req, res) => {
  const { user, comment } = req.body; // Expecting user and comment from the request body

  if (!user || !comment) {
    return res.status(400).json({ message: 'User and comment are required.' });
  }

  try {
    const resume = await Resume.findById(req.params.id);
    if (!resume) {
      return res.status(404).json({ message: 'Resume not found' });
    }

    resume.comments.push({ user, comment });
    await resume.save();
    res.status(200).json(resume);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};


export const getCommentsByResumeId = async (req, res) => {
  try {
    const resume = await Resume.findById(req.params.id);
    if (!resume) {
      return res.status(404).json({ message: 'Resume not found' });
    }
    res.status(200).json(resume.comments); // Return the comments array
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

