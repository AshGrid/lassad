import multer from "multer";


const storage = multer.diskStorage({
    destination: (req, file, cb) => {
      cb(null, 'uploads/');
    },
    filename: (req, file, cb) => {
      cb(null, `${Date.now()}-${file.originalname}`);
    },
  });
  
  // Set up multer with the above storage configuration
  export const  upload = multer({
    storage: storage,
    limits: { fileSize: 50 * 1024 * 1024 }, // Set max file size if needed (5 MB here)
  }).single('description'); // Accept any file type for 'description'
  