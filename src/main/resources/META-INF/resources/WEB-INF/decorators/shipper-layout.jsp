<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <title>
      <sitemesh:write property='title'>Shipper Portal</sitemesh:write>
    </title>

    <%-- Nhúng CSS chung cho Shipper --%>
    <jsp:include page="/commons/shipper/head_css.jsp" />

    <%-- Giữ lại các thẻ meta/script riêng từ trang con --%>
    <sitemesh:write property="head" />
  </head>

  <body id="page-top">
    <div id="wrapper">
      <%-- Sidebar --%>
      <jsp:include page="/commons/shipper/sidebar.jsp" />

      <div id="content-wrapper" class="d-flex flex-column">
        <div id="content">
          <%-- TOPBAR --%>
          <jsp:include page="/commons/shipper/topbar.jsp" />

          <%-- NỘI DUNG CHÍNH --%>
          <sitemesh:write property="body" />
        </div>

        <%-- Footer --%>
        <jsp:include page="/commons/shipper/footer.jsp" />
      </div>
    </div>

    <%-- Scroll to Top Button --%>
    <a class="scroll-to-top rounded" href="#page-top">
      <i class="fas fa-angle-up"></i>
    </a>

    <%-- Nhúng JS chung cho Shipper --%>
    <jsp:include page="/commons/shipper/scripts_js.jsp" />
  </body>
</html>
