<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

  <%
  org.sitemesh.content.Content __smContent = (org.sitemesh.content.Content) request
    .getAttribute(org.sitemesh.webapp.WebAppContext.CONTENT_KEY);
  org.sitemesh.content.ContentProperty __smProps = (__smContent != null) ? __smContent.getExtractedProperties()
    : null;
  org.sitemesh.content.ContentProperty __smTitle = (__smProps != null && __smProps.hasChild("title"))
    ? __smProps.getChild("title")
    : null;
  org.sitemesh.content.ContentProperty __smHead = (__smProps != null && __smProps.hasChild("head"))
    ? __smProps.getChild("head")
    : null;
  org.sitemesh.content.ContentProperty __smBody = (__smProps != null && __smProps.hasChild("body"))
    ? __smProps.getChild("body")
    : null;

  String __smHeadHtml = null;
  if (__smHead != null && __smHead.hasValue()) {
    StringBuilder sb = new StringBuilder();
    __smHead.writeValueTo(sb);
    __smHeadHtml = sb.toString()
      .replaceAll("(?is)\\s*<!DOCTYPE[^>]*>", "")
      .replaceAll("(?is)</?html\\b[^>]*>", "")
      .replaceAll("(?is)</?head\\b[^>]*>", "")
      .replaceAll("(?is)<title\\b[^>]*>.*?</title>", "");
  }

  String __smBodyHtml = null;
  if (__smBody != null && __smBody.hasValue()) {
    StringBuilder sb = new StringBuilder();
    __smBody.writeValueTo(sb);
    __smBodyHtml = sb.toString()
      .replaceAll("(?is)\\s*<!DOCTYPE[^>]*>", "")
      .replaceAll("(?is)</?html\\b[^>]*>", "")
      .replaceAll("(?is)</?body\\b[^>]*>", "")
      .replaceAll("(?is)</?head\\b[^>]*>", "");
  }
  %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
      <meta charset="UTF-8">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
      <title>
        <%
          if (__smTitle != null && __smTitle.hasValue()) {
            __smTitle.writeValueTo(out);
          } else {
            out.write("Trang quản trị");
          }
        %>
      </title>

      <%-- Nhúng CSS chung (File này đã có ${pageContext.request.contextPath}) --%>
        <jsp:include page="/commons/admin/head_css.jsp" />

        <%-- Giữ lại các thẻ meta/script riêng từ trang con --%>
          <%
            if (__smHeadHtml != null && !__smHeadHtml.isBlank()) {
              out.write(__smHeadHtml);
            }
          %>
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
                    <%
                      if (__smBodyHtml != null && !__smBodyHtml.isBlank()) {
                        out.write(__smBodyHtml);
                      }
                    %>
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