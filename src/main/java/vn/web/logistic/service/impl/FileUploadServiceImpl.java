package vn.web.logistic.service.impl;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import vn.web.logistic.service.FileUploadService;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@Slf4j
@Service
public class FileUploadServiceImpl implements FileUploadService {

    @Value("${app.upload.dir:uploads}")
    private String uploadDir;

    @Override
    public String uploadImage(MultipartFile file, String subFolder) {
        if (file == null || file.isEmpty()) {
            throw new RuntimeException("File không hợp lệ hoặc rỗng");
        }

        // Kiểm tra định dạng file
        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            throw new RuntimeException("Chỉ chấp nhận file ảnh (JPG, PNG, GIF)");
        }

        // Kiểm tra kích thước (max 5MB)
        if (file.getSize() > 5 * 1024 * 1024) {
            throw new RuntimeException("Kích thước ảnh không được vượt quá 5MB");
        }

        try {
            // Tạo tên file unique
            String originalFilename = StringUtils.cleanPath(file.getOriginalFilename());
            String fileExtension = getFileExtension(originalFilename);
            String newFileName = UUID.randomUUID().toString() + fileExtension;

            // Tạo thư mục nếu chưa tồn tại
            Path uploadPath = Paths.get(uploadDir, subFolder);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            // Lưu file
            Path filePath = uploadPath.resolve(newFileName);
            Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

            // Trả về đường dẫn tương đối
            String relativePath = subFolder + "/" + newFileName;
            log.info("Đã upload ảnh: {}", relativePath);
            return relativePath;

        } catch (IOException e) {
            log.error("Lỗi upload file: {}", e.getMessage());
            throw new RuntimeException("Lỗi khi lưu file: " + e.getMessage());
        }
    }

    @Override
    public boolean deleteImage(String filePath) {
        if (filePath == null || filePath.isEmpty()) {
            return false;
        }

        try {
            Path path = Paths.get(uploadDir, filePath);
            if (Files.exists(path)) {
                Files.delete(path);
                log.info("Đã xóa file: {}", filePath);
                return true;
            }
            return false;
        } catch (IOException e) {
            log.error("Lỗi xóa file: {}", e.getMessage());
            return false;
        }
    }

    private String getFileExtension(String filename) {
        if (filename == null || filename.lastIndexOf(".") == -1) {
            return ".jpg"; // default
        }
        return filename.substring(filename.lastIndexOf("."));
    }
}
