<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %>

<!-- Bootstrap core JavaScript-->
<script src="${pageContext.request.contextPath}/vendor/jquery/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

<!-- Core plugin JavaScript-->
<script src="${pageContext.request.contextPath}/vendor/jquery-easing/jquery.easing.min.js"></script>

<!-- Custom scripts for all pages-->
<script src="${pageContext.request.contextPath}/js/sb-admin-2.min.js"></script>

<!-- Chart.js -->
<script src="${pageContext.request.contextPath}/vendor/chart.js/Chart.min.js"></script>

<!-- Custom Shipper Scripts -->
<script>
  // Auto-refresh notifications every 30 seconds
  function refreshNotifications() {
    $.ajax({
      url: "${pageContext.request.contextPath}/api/shipper/notifications/count",
      method: "GET",
      success: function (data) {
        if (data.count > 0) {
          $("#notificationCount").text(data.count > 9 ? "9+" : data.count);
          $("#notificationCount").show();
        } else {
          $("#notificationCount").hide();
        }
      },
      error: function () {
        console.log("Could not fetch notifications");
      },
    });
  }

  // Call immediately and then every 30 seconds
  $(document).ready(function () {
    // refreshNotifications();
    // setInterval(refreshNotifications, 30000);
  });
</script>
