import express from "express";
import mongoose from "mongoose";
import dotenv from "dotenv";
import morgan from "morgan";
import cors from "cors";

import resumeRoute from "./routes/resumeRoute.js";
import userRoutes from "./routes/userRoute.js";
import webinarRoutes from "./routes/webinarRoutes.js";
import registrationRoutes from "./routes/registrationRoutes.js";
import examRoutes from './routes/examRoute.js'

import chapterRoutes from './routes/chapterRoute.js';
import subjectRoutes from './routes/subjectRoute.js';
import classRoutes from "./routes/classRoute.js";

// Create an Express application
const app = express();
const PORT = process.env.PORT || 3000;

dotenv.config();
const MONGODB_KEY =
  "mongodb+srv://salahbounouh:5WjFtHiaB1zDj6VP@cluster0.cdwcx.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";

// Middleware

app.use(
  cors({
    origin: "*",
    methods: ["GET", "POST", "PUT", "DELETE"],
    allowedHeaders: ["Content-Type", "Authorization"],
    credentials: true,
  })
);

mongoose.set("debug", true);
mongoose.Promise = global.Promise;

app.use(morgan("dev"));
app.use(express.json());
app.use(express.static("public"));


app.use('/api/chapters', chapterRoutes);
app.use('/api/subjects', subjectRoutes);
app.use('/api/classes',classRoutes);

app.use("/api/user", userRoutes);
app.use("/api/resume", resumeRoute);
app.use('/api', examRoutes);
app.use("/api", webinarRoutes);
app.use("/api", registrationRoutes);

mongoose
  .connect(MONGODB_KEY)
  .then(() => console.log("Connected to MongoDB"))
  .catch((err) => console.error("Could not connect to MongoDB", err));

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

