<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<title>Thông báo</title>

<div class="container-fluid">
  <div class="d-sm-flex align-items-center justify-content-between mb-4">
    <h1 class="h3 mb-0 text-gray-800">Thông báo</h1>
    <a class="btn btn-sm btn-success shadow-sm" href="${pageContext.request.contextPath}/shipper/dashboard">
      <i class="fas fa-arrow-left fa-sm text-white-50"></i> Quay lại Dashboard
    </a>
  </div>

  <div class="row">
    <div class="col-lg-12">
      <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex align-items-center justify-content-between">
          <h6 class="m-0 font-weight-bold text-success">Danh sách thông báo</h6>
        </div>
        <div class="card-body">
          <div id="notifyEmpty" class="text-center text-muted py-5">
            <i class="fas fa-bell-slash fa-2x mb-3"></i>
            <div>Chưa có thông báo nào.</div>
          </div>

          <div class="list-group" id="notifyList" style="display:none;"></div>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  (function () {
    var API = '${pageContext.request.contextPath}/api/shipper/notifications/recent';

    function escapeHtml(s) {
      return (s || '').replace(/[&<>"']/g, function (c) {
        return ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c];
      });
    }

    function fmtTime(iso) {
      if (!iso) return '';
      try {
        var d = new Date(iso);
        return d.toLocaleString('vi-VN');
      } catch (e) {
        return iso;
      }
    }

    fetch(API)
      .then(function (r) { return r.ok ? r.json() : []; })
      .then(function (items) {
        items = items || [];
        var empty = document.getElementById('notifyEmpty');
        var list = document.getElementById('notifyList');

        if (!items.length) {
          empty.style.display = 'block';
          list.style.display = 'none';
          return;
        }

        empty.style.display = 'none';
        list.style.display = 'block';
        list.innerHTML = items.map(function (n) {
          return (
            '<div class="list-group-item list-group-item-action">'
            +   '<div class="d-flex w-100 justify-content-between">'
            +     '<h6 class="mb-1 text-gray-900">' + escapeHtml(n.title) + '</h6>'
            +     '<small class="text-muted">' + escapeHtml(fmtTime(n.createdAt)) + '</small>'
            +   '</div>'
            +   '<p class="mb-1 text-gray-800">' + escapeHtml(n.body) + '</p>'
            + '</div>'
          );
        }).join('');
      })
      .catch(function () {
        // giữ UX đơn giản: im lặng và hiển thị rỗng
      });
  })();
</script>
