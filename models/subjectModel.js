import mongoose from 'mongoose';

const subjectSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        unique: true,
        trim: true,
    },
    chapters: [
        {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'Chapter', // Reference to the Chapter model
            required: false,
        }
    ],

}, {
    timestamps: true // Automatically creates createdAt and updatedAt fields
});

// Compile model from schema
const Subject = mongoose.model('Subject', subjectSchema);

export default Subject;
