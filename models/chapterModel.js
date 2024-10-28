import mongoose from 'mongoose';

const chapterSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        unique: true,
        trim: true,
    },
    pdfFile: {
        type: String,
        required: true,
        unique: true, // Ensures no duplicate file paths
        trim: true,
    },
    subject: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Subject', // Reference to the Subject model
        required: true, // Ensure each chapter is linked to a subject
    }
}, {
    timestamps: true // Automatically creates createdAt and updatedAt fields
});

// Compile model from schema
const Chapter = mongoose.model('Chapter', chapterSchema);

export default Chapter;
