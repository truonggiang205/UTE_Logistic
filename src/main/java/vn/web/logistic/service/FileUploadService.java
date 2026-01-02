package vn.web.logistic.service;

import org.springframework.web.multipart.MultipartFile;

public interface FileUploadService {

    /**
     * Upload file ảnh và trả về đường dẫn lưu trữ
     * 
     * @param file      File ảnh cần upload
     * @param subFolder Thư mục con (ví dụ: "parcels")
     * @return Đường dẫn tương đối của file đã lưu
     */
    String uploadImage(MultipartFile file, String subFolder);

    /**
     * Xóa file ảnh
     * 
     * @param filePath Đường dẫn tương đối của file cần xóa
     * @return true nếu xóa thành công
     */
    boolean deleteImage(String filePath);
}
