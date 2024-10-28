import express from 'express';
import mongoose from 'mongoose';
import dotenv from 'dotenv';
import morgan from 'morgan';
import cors from 'cors';

import userRoutes from './routes/userRoute.js';
import chapterRoutes from './routes/chapterRoute.js';
import subjectRoutes from './routes/subjectRoute.js';
import classRoutes from "./routes/classRoute.js";
// Create an Express application
const app = express();
const PORT = process.env.PORT || 9090;

dotenv.config();

// Middleware
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true
}));


mongoose.set('debug',true);
mongoose.Promise = global.Promise;

app.use(morgan('dev'));
app.use(express.json());
app.use(express.static('public'));

app.use('/api', userRoutes);
app.use('/api/chapters', chapterRoutes);
app.use('/api/subjects', subjectRoutes);
app.use('/api/classes',classRoutes);

// Connect to MongoDB
mongoose.connect(process.env.MONGODB_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
  serverSelectionTimeoutMS: 5000, // Optional: Adjust the timeout as needed
})
    .then(() => console.log('MongoDB connected'))
    .catch(err => console.error('MongoDB connection error:', err));

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
// moodleapp-85930