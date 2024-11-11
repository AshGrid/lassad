import Registration from "../models/registration.js";
import Webinar from "../models/webinar.js";

export const checkRegistration = async (req, res) => {
  const { userId } = req.query;
  const webinarId = req.params.webinarId;

  try {
    const registration = await Registration.findOne({ userId, webinarId });
    res.json({ isRegistered: registration ? true : false });
  } catch (error) {
    res.status(500).json({ error: "Internal server error" });
  }
};

export const registerForWebinar = async (req, res) => {
  const { userId, webinarId } = req.body;

  try {
    const webinar = await Webinar.findById(webinarId);
    if (!webinar) {
      return res.status(404).json({ error: "Webinar not found" });
    }

    const registration = new Registration({ userId, webinarId });
    await registration.save();

    res.status(201).json({ message: "Registration successful", registration });
  } catch (error) {
    res.status(500).json({ error: "Internal server error" });
  }
};
