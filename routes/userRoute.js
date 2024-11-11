import express from 'express';
import { signUp, login, modifyAccount } from '../controllers/userController.js';
import { verifyToken } from '../middlewares/jwt.js';
import { upload } from '../middlewares/multerStorage.js';

const router = express.Router();

// Signup route
router.post('/signup', signUp);

// Login route
router.post('/login', login);

// Modify Account route
router.put('/:userId', verifyToken, upload.single('profilePicture'), modifyAccount);

export default router;
