package vn.web.logistic.service;

import org.springframework.web.multipart.MultipartFile;

public interface FileUploadService {

    /**
     * Upload file ảnh và trả về đường dẫn lưu trữ
     */
    String uploadImage(MultipartFile file, String subFolder);

    /**
     * Xóa file ảnh
     */
    boolean deleteImage(String filePath);
}