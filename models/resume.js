import mongoose from 'mongoose';

const CommentSchema = new mongoose.Schema({
  user: { type: String, required: true }, // User identifier (can be username or user ID)
  comment: { type: String, required: true },
  createdAt: { type: Date, default: Date.now },
});

// Modify the schema to include 'isPaid' field
const ResumeSchema = new mongoose.Schema(
  {
    title: { type: String, required: true },
    reference: { type: String, required: true },
    level: { type: String, required: true },
    price: { type: Number, required: true },
    description: { type: String, default: 'No description available.' },
    owner: { type: String, required: true },
    ratings: { type: [Number], default: [] },
    comments: [CommentSchema],
    isPaid: { type: Boolean, default: false }, // New field to track payment status
  },
  { timestamps: true }
);

export default mongoose.model('Resume', ResumeSchema);
