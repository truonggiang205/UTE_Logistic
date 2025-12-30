<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="sitemesh" uri="http://www.opensymphony.com/sitemesh/decorator" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <meta name="description" content="Hệ thống quản lý Logistics">
                <meta name="author" content="">

                <%-- Tiêu đề động: Lấy từ trang con, nếu không có thì dùng mặc định --%>
                    <title>
                        <sitemesh:write property='title'>Logistics Manager</sitemesh:write>
                    </title>

                    <%-- 1. Nhúng CSS chung (Bootstrap, FontAwesome...) --%>
                        <jsp:include page="/commons/manager/head_css.jsp" />

                        <%-- 2. Nhúng các thẻ <head> riêng của trang con (Ví dụ: CSS riêng cho DataTables) --%>
                            <sitemesh:write property='head' />
            </head>

            <body id="page-top">

                <div id="wrapper">

                    <%-- 3. SIDEBAR: Chứa Menu chức năng --%>
                        <jsp:include page="/commons/manager/sidebar.jsp" />
                        <%-- End of Sidebar --%>

                            <div id="content-wrapper" class="d-flex flex-column">

                                <div id="content">

                                    <%-- 4. TOPBAR: Thanh ngang phía trên (User profile, thông báo...) --%>
                                        <jsp:include page="/commons/manager/topbar.jsp" />
                                        <%-- End of Topbar --%>

                                            <div class="container-fluid">
                                                <%-- 5. NỘI DUNG CHÍNH: Nội dung của từng trang con sẽ được đổ vào đây
                                                    --%>
                                                    <sitemesh:write property='body' />
                                            </div>
                                </div>
                                <%-- 6. FOOTER --%>
                                    <jsp:include page="/commons/manager/footer.jsp" />
                                    <%-- End of Footer --%>

                            </div>
                </div>
                <a class="scroll-to-top rounded" href="#page-top">
                    <i class="fas fa-angle-up"></i>
                </a>

                <div class="modal fade" id="logoutModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
                    aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalLabel">Xác nhận đăng xuất?</h5>
                                <button class="close" type="button" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">×</span>
                                </button>
                            </div>
                            <div class="modal-body">Chọn "Đăng xuất" bên dưới nếu bạn đã sẵn sàng kết thúc phiên làm
                                việc.</div>
                            <div class="modal-footer">
                                <button class="btn btn-secondary" type="button" data-dismiss="modal">Hủy</button>
                                <a class="btn btn-primary" href="<c:url value='/logout'/>">Đăng xuất</a>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- 7. Nhúng JS chung (jQuery, Bootstrap JS, Core plugin...) --%>
                    <jsp:include page="/commons/manager/scripts_js.jsp" />

            </body>

            </html>