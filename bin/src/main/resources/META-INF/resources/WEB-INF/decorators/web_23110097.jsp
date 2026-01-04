<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>
      <sitemesh:write property='title'>Video Website</sitemesh:write>
    </title>

    <!-- Bootstrap CSS -->
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet" />
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css"
      rel="stylesheet" />

    <sitemesh:write property="head" />
  </head>
  <body>
    <!-- HEADER -->
    <jsp:include page="/commons/web/header_23110097.jsp" />
    <!-- END HEADER -->

    <!-- Main Content -->
    <div class="container my-4">
      <sitemesh:write property="body" />
    </div>

    <!-- FOOTER -->
    <jsp:include page="/commons/web/footer_23110097.jsp" />
    <!-- END FOOTER -->

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
