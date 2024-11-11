import mongoose from 'mongoose';

const responseSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  responseBody: {
    type: String,
    required: true,
  },
});

const examSchema = new mongoose.Schema(
  {
    courseId: {
      type: String,
      required: true,
      trim: true,
    },
    instructorId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    examFile: {
      type: Buffer,
      required: false,
    },
    examFileType: {
      type: String,
      required: false,
    },
    responses: [responseSchema],
  },
  {
    timestamps: true, // Automatically adds createdAt and updatedAt fields
  }
);

const Exam = mongoose.model('Exam', examSchema);

export default Exam;
