import multer from 'multer';

const storage = multer.memoryStorage(); // Store file in memory as Buffer
export const upload = multer({ storage });