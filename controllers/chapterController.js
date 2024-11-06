import Chapter from '../models/chapterModel.js';
import Subject from '../models/subjectModel.js';
// Create a new chapter
export const createChapter = async (req, res) => {
    try {
        const { name, subject } = req.body;
        let pdfFile = '';

        // Check if the PDF file is uploaded
        if (req.file) {
            pdfFile = req.file.filename; // Store the filename if uploaded
        } else if (req.body.pdfFile) {
            pdfFile = req.body.pdfFile; // Optionally allow pdfFile from body if necessary
        }

        // Create a new chapter
        const chapter = new Chapter({ name, pdfFile, subject });

        // Save the chapter to the database
        await chapter.save();

        // Update the subject to include the new chapter
        const updatedSubject = await Subject.findByIdAndUpdate(
            subject,
            { $push: { chapters: chapter._id } }, // Assuming chapters is an array in the Subject schema
            { new: true } // Return the updated document
        );

        // Check if the subject was found and updated
        if (!updatedSubject) {
            return res.status(404).json({ message: 'Subject not found' });
        }

        // Respond with the created chapter and updated subject info
        res.status(201).json({
            chapter,
            updatedSubject
        });
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
};


// Get all chapters
export const getChapters = async (req, res) => {
    try {
        const chapters = await Chapter.find().populate('subject');
        res.status(200).json(chapters);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Get a chapter by ID
export const getChapterById = async (req, res) => {
    try {
        const chapter = await Chapter.findById(req.params.id).populate('subject');
        if (!chapter) return res.status(404).json({ message: "Chapter not found" });
        res.status(200).json(chapter);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Update a chapter by ID
export const updateChapter = async (req, res) => {
    try {
        const { name, pdfFile, subject } = req.body;
        const chapter = await Chapter.findByIdAndUpdate(
            req.params.id,
            { name, pdfFile, subject },
            { new: true, runValidators: true }
        );
        if (!chapter) return res.status(404).json({ message: "Chapter not found" });
        res.status(200).json(chapter);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
};

// Delete a chapter by ID
export const deleteChapter = async (req, res) => {
    try {
        const chapter = await Chapter.findByIdAndDelete(req.params.id);
        if (!chapter) return res.status(404).json({ message: "Chapter not found" });
        res.status(200).json({ message: "Chapter deleted successfully" });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

export const getChaptersBySubjectId = async (req, res) => {
    try {
        const { subjectId } = req.params; // Get subject ID from the request parameters

        // Find chapters that match the subject ID
        const chapters = await Chapter.find({ subject: subjectId }).populate('subject');

        if (chapters.length === 0) {
            return res.status(404).json({ message: "No chapters found for this subject" });
        }

        res.status(200).json(chapters);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};
