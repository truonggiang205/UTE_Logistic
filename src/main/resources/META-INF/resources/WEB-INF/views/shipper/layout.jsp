<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
  <%@ include file="/commons/shipper/head_css.jsp" %>

  <body id="page-top">
    <div id="wrapper">
      <%@ include file="/commons/shipper/sidebar.jsp" %>

      <div id="content-wrapper" class="d-flex flex-column">
        <div id="content">
          <%@ include file="/commons/shipper/topbar.jsp" %>

          <!-- Main Content -->
          <jsp:include page="${contentPage}" />
        </div>

        <%@ include file="/commons/shipper/footer.jsp" %>
      </div>
    </div>

    <a class="scroll-to-top rounded" href="#page-top">
      <i class="fas fa-angle-up"></i>
    </a>

    <%@ include file="/commons/shipper/scripts_js.jsp" %>
  </body>
</html>
