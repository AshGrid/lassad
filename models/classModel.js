import mongoose from 'mongoose';
import User from "./userModel.js";
import Subject from "./subjectModel.js";

const classSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        unique: true,
        trim: true,
    },
    students: [
        {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'User',
            validate: {
                validator: async function(value) {
                    const user = await User.findById(value);
                    return user && user.role === 'Student';
                },
                message: "Only users with the role 'Student' can be added as students.",
            },
        }
    ],
    subjects: [
        {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'Subject', // Reference to the Class model
            required: false,
        }
    ]
}, {
    timestamps: true // Automatically creates createdAt and updatedAt fields
});

// Compile model from schema
const Class = mongoose.model('Class', classSchema);

export default Class;
