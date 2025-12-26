<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Trang Chủ - Video Website</title>
</head>
<body>
    <div class="container">
        <!-- Categories Section -->
        <section class="mb-5">
            <h2 class="mb-4">
                <i class="bi bi-folder me-2"></i>Danh mục
            </h2>
            <div class="row">
                <c:forEach items="${categories}" var="category">
                    <div class="col-md-3 mb-3">
                        <div class="card h-100">
                            <img src="${pageContext.request.contextPath}/uploads/category/${category.images}" class="card-img-top" alt="${category.categoryName}" style="height: 150px; object-fit: cover;">
                            <div class="card-body">
                                <h5 class="card-title">${category.categoryName}</h5>
                                <a href="/category/${category.categoryId}" class="btn btn-primary btn-sm">
                                    <i class="bi bi-eye me-1"></i>Xem
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>

        <!-- Videos Section -->
        <section class="mb-5">
            <h2 class="mb-4">
                <i class="bi bi-play-circle me-2"></i>Video mới nhất
            </h2>
            <div class="row">
                <c:forEach items="${videos}" var="video">
                    <div class="col-md-4 mb-4">
                        <div class="card h-100">
                            <img src="${pageContext.request.contextPath}/uploads/videos/${video.poster}" class="card-img-top" alt="${video.title}" style="height: 200px; object-fit: cover;">
                            <div class="card-body">
                                <h5 class="card-title">${video.title}</h5>
                                <p class="card-text text-muted small">${video.description}</p>
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="badge bg-secondary">
                                        <i class="bi bi-eye me-1"></i>${video.views} views
                                    </span>
                                    <a href="/videos/${video.videoId}" class="btn btn-primary btn-sm">
                                        <i class="bi bi-play-fill me-1"></i>Xem
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>
    </div>
</body>
</html>
