import mongoose from "mongoose";

const webinarSchema = new mongoose.Schema({
  title: { type: String, required: true },
  description: { type: String, required: true },
  date: { type: Date, required: true },
  duration: { type: Number, required: true },
  maxParticipants: { type: Number, required: true },
  meetLink: { type: String, required: true },
});

const Webinar = mongoose.model("Webinar", webinarSchema);

export default Webinar;
