import express from "express";
import {
  checkRegistration,
  registerForWebinar,
} from "../controllers/registrationController.js";

const router = express.Router();

router.get("/:webinarId", checkRegistration);
router.post("/register", registerForWebinar);

export default router;
