import express from "express";
import {
  createWebinar,
  getWebinars,
  getWebinarById,
  updateWebinarById,
  deleteWebinarById,
} from "../controllers/webinarController.js";

const router = express.Router();

router.post("/webinar", createWebinar);
router.get("/webinar", getWebinars);
router.get("/webinar/:id", getWebinarById);
router.put("/webinar/:id", updateWebinarById);
router.delete("/webinar/:id", deleteWebinarById);

export default router;
