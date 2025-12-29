<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
      <meta charset="UTF-8">
      <title>
        <sitemesh:write property='title'>Trang quản trị</sitemesh:write>
      </title>

      <%-- Nhúng CSS chung (File này đã có ${pageContext.request.contextPath}) --%>
        <jsp:include page="/commons/admin/head_css.jsp" />

        <%-- Giữ lại các thẻ meta/script riêng từ trang con --%>
          <sitemesh:write property='head' />
    </head>

    <body id="page-top">
      <div id="wrapper">
        <%-- Sidebar --%>
          <jsp:include page="/commons/admin/sidebar.jsp" />

          <div id="content-wrapper" class="d-flex flex-column">
            <div id="content">
              <%-- TOPBAR --%>
                <jsp:include page="/commons/admin/topbar.jsp" />

                <%-- NỘI DUNG CHÍNH --%>
                  <sitemesh:write property='body' />
            </div>

            <%-- Footer --%>
              <jsp:include page="/commons/admin/footer.jsp" />
          </div>
      </div>

      <%-- Scroll to Top Button--%>
        <a class="scroll-to-top rounded" href="#page-top">
          <i class="fas fa-angle-up"></i>
        </a>

        <%-- Logout Modal--%>
          <div class="modal fade" id="logoutModal" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title">Ready to Leave?</h5>
                  <button class="close" type="button" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span>
                  </button>
                </div>
                <div class="modal-body">Select "Logout" below if you are ready to end your current session.</div>
                <div class="modal-footer">
                  <button class="btn btn-secondary" type="button" data-dismiss="modal">Cancel</button>
                  <a class="btn btn-primary" href="<c:url value='/logout'/>">Logout</a>
                </div>
              </div>
            </div>
          </div>

          <%-- Nhúng JS chung (File này đã có ${pageContext.request.contextPath}) --%>
            <jsp:include page="/commons/admin/scripts_js.jsp" />
    </body>

    </html>