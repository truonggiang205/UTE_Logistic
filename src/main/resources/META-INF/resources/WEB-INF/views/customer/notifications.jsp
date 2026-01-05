<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c" uri="jakarta.tags.core" %>

<title>Thông báo</title>

<div class="container-fluid">
  <div class="d-sm-flex align-items-center justify-content-between mb-4">
    <h1 class="h3 mb-0 text-gray-800">
      <i class="fas fa-bell mr-2"></i>Thông báo
    </h1>
    <a
      class="btn btn-sm btn-info shadow-sm"
      href="${pageContext.request.contextPath}/customer/dashboard">
      <i class="fas fa-arrow-left fa-sm text-white-50"></i> Quay lại
    </a>
  </div>

  <div class="row">
    <div class="col-lg-12">
      <div class="card shadow mb-4">
        <div
          class="card-header py-3 d-flex align-items-center justify-content-between">
          <h6 class="m-0 font-weight-bold text-info">
            <i class="fas fa-list mr-2"></i>Danh sách thông báo
          </h6>
          <button
            class="btn btn-sm btn-outline-info"
            onclick="loadNotifications()">
            <i class="fas fa-sync-alt"></i> Làm mới
          </button>
        </div>
        <div class="card-body">
          <div id="notifyLoading" class="text-center text-muted py-4">
            <i class="fas fa-spinner fa-spin fa-2x"></i>
            <div class="mt-2">Đang tải...</div>
          </div>

          <div
            id="notifyEmpty"
            class="text-center text-muted py-5"
            style="display: none">
            <i class="fas fa-bell-slash fa-3x mb-3 text-secondary"></i>
            <div>Chưa có thông báo nào dành cho bạn.</div>
          </div>

          <div class="list-group" id="notifyList" style="display: none"></div>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  var API =
    "${pageContext.request.contextPath}/api/customer/notifications/recent";

  function escapeHtml(s) {
    return (s || "").replace(/[&<>"']/g, function (c) {
      return {
        "&": "&amp;",
        "<": "&lt;",
        ">": "&gt;",
        '"': "&quot;",
        "'": "&#39;",
      }[c];
    });
  }

  function fmtTime(iso) {
    if (!iso) return "";
    try {
      var d = new Date(iso);
      return d.toLocaleString("vi-VN");
    } catch (e) {
      return iso;
    }
  }

  function loadNotifications() {
    var loading = document.getElementById("notifyLoading");
    var empty = document.getElementById("notifyEmpty");
    var list = document.getElementById("notifyList");

    loading.style.display = "block";
    empty.style.display = "none";
    list.style.display = "none";

    fetch(API)
      .then(function (r) {
        return r.ok ? r.json() : [];
      })
      .then(function (items) {
        items = items || [];
        loading.style.display = "none";

        if (!items.length) {
          empty.style.display = "block";
          return;
        }

        list.style.display = "block";
        list.innerHTML = items
          .map(function (n) {
            return (
              '<div class="list-group-item list-group-item-action">' +
              '<div class="d-flex w-100 justify-content-between">' +
              '<h6 class="mb-1 text-gray-900"><i class="fas fa-bell text-info mr-2"></i>' +
              escapeHtml(n.title) +
              "</h6>" +
              '<small class="text-muted">' +
              escapeHtml(fmtTime(n.createdAt)) +
              "</small>" +
              "</div>" +
              '<p class="mb-1 text-gray-700">' +
              escapeHtml(n.body).replace(/\n/g, "<br>") +
              "</p>" +
              "</div>"
            );
          })
          .join("");
      })
      .catch(function () {
        loading.style.display = "none";
        empty.style.display = "block";
      });
  }

  document.addEventListener("DOMContentLoaded", loadNotifications);
</script>
