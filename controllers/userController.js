import User from '../models/userModel.js';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';

dotenv.config();

// Signup function
export const signUp = async (req, res) => {
    console.log(req.body); 
  const { email, username, password, role, institution } = req.body;

  try {
    const existingUser = await User.findOne({ $or: [{ email }, { username }] });
    if (existingUser) return res.status(400).json({ message: 'User already exists' });

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create new user
    const user = await User.create({ email, username, password: hashedPassword, role, institution });
    const token = jwt.sign(
        { id: user._id, role: user.role },
        process.env.JWT_SECRET,  // Access JWT_SECRET through process.env
        { expiresIn: '1h' }
    );    

    res.status(201).json({ user, token});
  } catch (error) {
    res.status(500).json({ message: 'Error creating user', error });
  }
};

// Login function
export const login = async (req, res) => {
  const { emailOrUsername, password } = req.body;

  try {
    // Find user by email or username
    const user = await User.findOne({   
        $or: [{ email: emailOrUsername }, { username: emailOrUsername }]
    });
    console.log(user);

    if (!user) return res.status(404).json({ message: 'User not found' });

    // Check password
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) return res.status(400).json({ message: 'Invalid password' });

    // Generate JWT
    const token = jwt.sign(
        { id: user._id, role: user.role },
        process.env.JWT_SECRET,  // Access JWT_SECRET through process.env
        { expiresIn: '1h' }
    );    

    console.log("profilePicture type after fetch:", typeof user.profilePicture);

   // Convert profilePicture Buffer to base64 if it exists and is a Buffer
   const userResponse = user.toObject(); // Convert Mongoose document to plain object
   if (user.profilePicture && Buffer.isBuffer(user.profilePicture)) {
     userResponse.profilePicture = `data:image/jpeg;base64,${user.profilePicture.toString('base64')}`;
   } else {
     userResponse.profilePicture = ''; // Set to empty if not present or invalid
   }

   res.status(200).json({ user: userResponse, token });
  } catch (error) {
    res.status(500).json({ message: 'Error logging in', error });
  }
};

// Modify Account function
export const modifyAccount = async (req, res) => {
    const { userId } = req.params;
    const updates = req.body;
  
    // Check if a file was uploaded
    if (req.file) {
      updates.profilePicture = req.file.buffer; // Store file Buffer directly
    }
  
    try {
      // Check if password update is requested and hash if needed
      if (updates.password) {
        updates.password = await bcrypt.hash(updates.password, 10);
      }
  
      const user = await User.findByIdAndUpdate(userId, updates, { new: true });
      if (!user) return res.status(404).json({ message: 'User not found' });
  
      res.status(200).json({ user });
    } catch (error) {
      res.status(500).json({ message: 'Error updating user account', error });
    }
};

// GET user progile picture
export const getUserProfile = async (req, res) => {
    const { userId } = req.params;
  
    try {
      const user = await User.findById(userId);
      if (!user) return res.status(404).json({ message: 'User not found' });
  
      // Convert profilePicture Buffer to base64 if it exists
      const userProfile = user.toObject(); // Convert to regular object
      if (user.profilePicture) {
        userProfile.profilePicture = `data:image/jpeg;base64,${user.profilePicture.toString('base64')}`;
      }
  
      res.status(200).json(userProfile);
    } catch (error) {
      res.status(500).json({ message: 'Error retrieving user profile', error });
    }
};
  