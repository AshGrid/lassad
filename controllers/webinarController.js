import Webinar from "../models/webinar.js";

export const createWebinar = async (req, res) => {
  try {
    const webinar = new Webinar(req.body);
    await webinar.save();
    res.status(201).json({ message: "Webinar added successfully" });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

export const getWebinars = async (req, res) => {
  try {
    const webinars = await Webinar.find();
    res.json(webinars);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const getWebinarById = async (req, res) => {
  try {
    const webinar = await Webinar.findById(req.params.id);
    if (!webinar) return res.status(404).json({ error: "Webinar not found" });
    res.json(webinar);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const updateWebinarById = async (req, res) => {
  try {
    const webinar = await Webinar.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });
    if (!webinar) return res.status(404).json({ error: "Webinar not found" });
    res.json(webinar);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

export const deleteWebinarById = async (req, res) => {
  try {
    const webinar = await Webinar.findByIdAndDelete(req.params.id);
    if (!webinar) return res.status(404).json({ error: "Webinar not found" });
    res.json({ message: "Webinar deleted successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
