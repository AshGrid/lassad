import multer, { diskStorage } from 'multer';
import { extname as _extname } from 'path';

const storage = multer.memoryStorage(); // Store file in memory as Buffer
export const upload = multer({ storage });

const storagePdf = diskStorage({
    destination: './PdfUploads/',
    filename: (req, file, cb) => {
        cb(null, file.fieldname + '-' + Date.now() + _extname(file.originalname));
    }
});

const uploadPdf = multer({
    storage: storagePdf,
    limits: { fileSize: 10 * 1024 * 1024 }, // Limit to 10MB
    fileFilter: (req, file, cb) => {
        checkFileType(file, cb);
    }
});

function checkFileType(file, cb) {
    const filetypes = /pdf/;
    const extname = filetypes.test(_extname(file.originalname).toLowerCase());
    const mimetype = filetypes.test(file.mimetype);

    if (mimetype && extname) {
        return cb(null, true);
    } else {
        cb(new Error('Error: PDFs Only!')); // Clarify error message to specify PDFs
    }
}

// Export uploadPdf properly
export { uploadPdf };
