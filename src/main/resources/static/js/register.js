let otpTimer; // Biến toàn cục để quản lý bộ đếm ngược

// HÀM 1: Gửi yêu cầu OTP khi nhấn nút "Đăng ký"
function handleRegisterRequest() {
    const password = $('#password').val();
    const confirmPassword = $('#confirmPassword').val();

    // Kiểm tra mật khẩu khớp nhau
    if (password !== confirmPassword) {
        alert("Mật khẩu nhập lại không khớp!");
        return;
    }

    // Kiểm tra đã đồng ý điều khoản chưa
    if (!$('#policy').is(':checked')) {
        alert("Vui lòng đồng ý với điều khoản và chính sách!");
        return;
    }

    // Thu thập dữ liệu từ các ô input
    const formData = {
        businessName: $("input[name='businessName']").val(),
        phone: $("input[name='phone']").val(),
        password: password,
        province: $("input[name='province']").val(),
        district: $("input[name='district']").val(),
        ward: $("input[name='ward']").val(),
        addressDetail: $("input[name='addressDetail']").val()
    };

    // Gọi AJAX gửi OTP
    $.ajax({
        url: '/auth/request-otp',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(formData),
        success: function() {
            $('#displayPhone').text(formData.phone);
            $('#otpModal').fadeIn(); // Hiện Modal
            startOtpCountdown(60);   // Bắt đầu đếm ngược 60s
        },
        error: function(xhr) {
            alert(xhr.responseText || "Lỗi khi gửi yêu cầu OTP!");
        }
    });
}

// HÀM 2: Bộ đếm ngược thời gian OTP
function startOtpCountdown(duration) {
    let timer = duration;
    const timerDisplay = $('#timer');
    const timerContainer = $('.timer-text');
    const verifyBtn = $('.btn-verify-otp');
    
    // Reset trạng thái nút xác thực
    verifyBtn.prop('disabled', false).css('opacity', '1').css('cursor', 'pointer');
    timerContainer.html('Yêu cầu gửi lại sau <span id="timer">' + duration + 's</span>');

    clearInterval(otpTimer); // Xóa bộ đếm cũ nếu có

    otpTimer = setInterval(function () {
        $('#timer').text(timer + "s");

        if (--timer < 0) {
            clearInterval(otpTimer);
            // Hiển thị nút gửi lại mã khi hết thời gian
            timerContainer.html('Mã OTP đã hết hạn. <a href="javascript:void(0)" onclick="handleRegisterRequest()" style="color: #00B14F; font-weight: bold; text-decoration: underline;">Gửi lại mã</a>');
            
            // Vô hiệu hóa nút xác thực
            verifyBtn.prop('disabled', true).css('opacity', '0.5').css('cursor', 'not-allowed');
        }
    }, 1000);
}

// HÀM 3: Xác thực OTP và lưu vào database
function confirmOtpVerify() {
    const otp = $('#otpCode').val();
    const phone = $('#displayPhone').text();

    if (!otp || otp.length < 6) {
        alert("Vui lòng nhập đầy đủ mã OTP 6 số!");
        return;
    }

    $.ajax({
        url: '/auth/verify-otp',
        type: 'POST',
        data: { phone: phone, otp: otp },
        success: function() {
            clearInterval(otpTimer); // Dừng đếm ngược
            alert("Đăng ký thành công! Bạn sẽ được chuyển đến trang đăng nhập.");
            window.location.href = "/auth/login";
        },
        error: function(xhr) {
            alert(xhr.responseText || "Mã OTP không chính xác!");
        }
    });
}

// HÀM 4: Đóng Modal
function closeOtpModal() {
    clearInterval(otpTimer);
    $('#otpModal').fadeOut(300);
    $('#otpCode').val(''); // Xóa trắng ô nhập OTP
}