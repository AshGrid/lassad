import mongoose from 'mongoose';

const userSchema = new mongoose.Schema({
  username: {
    type: String,
    required: true,
    unique: true,
    trim: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
    trim: true,
  },
  password: {
    type: String,
    required: true,
  },
  institution: {
    type: String,
    required: true,
  },
  role: {
    type: String,
    enum: ['Student', 'Instructor'],
    required: true,
    default: 'Student',
  },
  profilePicture: {
    type: Buffer,
    required: false,
    default: '', // Can be a URL or file path
  },
  subjects: {
    type: [String], // List of subject names or IDs (for students)
    required: function() { return this.role === 'Student'; },
  },
  affiliatedSubject: {
    type: String, // Name or ID of the affiliated subject (for instructors)
    required: function() { return this.role === 'Instructor'; },
  },
}, { 
  timestamps: true // Automatically creates createdAt and updatedAt fields
});

// Compile model from schema
const User = mongoose.model('User', userSchema);

export default User;
