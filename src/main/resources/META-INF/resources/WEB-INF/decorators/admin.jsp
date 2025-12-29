<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title><sitemesh:write property='title'>Admin</sitemesh:write></title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet" />

    <sitemesh:write property="head" />
  </head>
  <body>
    <jsp:include page="/commons/admin/header.jsp" />

    <div class="container-fluid">
      <div class="row g-0">
        <aside class="col-12 col-md-3 col-lg-2 min-vh-100">
          <jsp:include page="/commons/admin/sidebar.jsp" />
        </aside>

        <main class="col-12 col-md-9 col-lg-10">
          <div class="p-4">
            <sitemesh:write property="body" />
          </div>
        </main>
      </div>
    </div>

    <jsp:include page="/commons/admin/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
