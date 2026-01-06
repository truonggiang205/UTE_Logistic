<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c" uri="jakarta.tags.core"%>

<head>
  <title>Xác minh OTP - NGHV Logistics</title>
  <link rel="stylesheet" href="<c:url value='/css/auth.css'/>" />
  <link
    rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
  <style>
    /* OTP Input Boxes Animation */
    .otp-container {
      display: flex;
      justify-content: center;
      gap: 12px;
      margin: 30px 0;
    }

    .otp-input {
      width: 55px;
      height: 65px;
      border: 2px solid #e0e0e0;
      border-radius: 12px;
      font-size: 28px;
      font-weight: 700;
      text-align: center;
      background: #f9f9f9;
      color: #333;
      transition: all 0.3s ease;
      outline: none;
    }

    .otp-input:focus {
      border-color: #00b14f;
      background: #fff;
      box-shadow: 0 0 0 4px rgba(0, 177, 79, 0.15);
      transform: scale(1.05);
    }

    .otp-input.filled {
      border-color: #00b14f;
      background: #e8f5e9;
    }

    .otp-input.error {
      border-color: #c62828;
      background: #ffebee;
      animation: shake 0.5s ease;
    }

    @keyframes shake {
      0%,
      100% {
        transform: translateX(0);
      }
      25% {
        transform: translateX(-5px);
      }
      75% {
        transform: translateX(5px);
      }
    }

    /* Email Badge */
    .email-badge {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
      padding: 12px 20px;
      border-radius: 50px;
      margin-bottom: 10px;
    }

    .email-badge i {
      color: #00b14f;
      font-size: 18px;
    }

    .email-badge span {
      color: #2e7d32;
      font-weight: 600;
    }

    /* Timer Circle */
    .timer-circle {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      width: 80px;
      height: 80px;
      border-radius: 50%;
      background: linear-gradient(135deg, #e8f5e9 0%, #fff 100%);
      border: 3px solid #00b14f;
      margin: 0 auto 20px;
      position: relative;
    }

    .timer-circle .time {
      font-size: 22px;
      font-weight: 700;
      color: #00b14f;
    }

    .timer-circle .label {
      font-size: 10px;
      color: #666;
      text-transform: uppercase;
    }

    .timer-expired {
      border-color: #ff9800;
    }

    .timer-expired .time {
      color: #ff9800;
    }

    /* Resend Button */
    .resend-btn {
      background: transparent;
      border: 2px solid #00b14f;
      color: #00b14f;
      padding: 10px 25px;
      border-radius: 25px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      display: inline-flex;
      align-items: center;
      gap: 8px;
    }

    .resend-btn:hover {
      background: #00b14f;
      color: white;
      transform: translateY(-2px);
    }

    .resend-btn:disabled {
      opacity: 0.5;
      cursor: not-allowed;
    }

    /* Success Animation */
    .success-icon {
      display: none;
      font-size: 60px;
      color: #00b14f;
      animation: popIn 0.5s ease;
    }

    @keyframes popIn {
      0% {
        transform: scale(0);
        opacity: 0;
      }
      50% {
        transform: scale(1.2);
      }
      100% {
        transform: scale(1);
        opacity: 1;
      }
    }

    /* Info Cards with Icons */
    .info-step {
      display: flex;
      align-items: center;
      gap: 15px;
      padding: 15px;
      background: rgba(255, 255, 255, 0.1);
      border-radius: 10px;
      margin-bottom: 12px;
    }

    .info-step .step-num {
      width: 30px;
      height: 30px;
      background: white;
      color: #00b14f;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: 700;
      font-size: 14px;
    }

    .info-step p {
      margin: 0;
      font-size: 14px;
    }
  </style>
</head>

<body>
  <div class="auth-ghtk-container">
    <div class="auth-banner">
      <h1><i class="fa-solid fa-shield-check"></i> XÁC MINH OTP</h1>
      <div style="margin-top: 40px">
        <div class="info-step">
          <span class="step-num">1</span>
          <p>Mã OTP 6 số đã được gửi đến email của bạn</p>
        </div>
        <div class="info-step">
          <span class="step-num">2</span>
          <p>Nhập chính xác mã OTP trong vòng 5 phút</p>
        </div>
        <div class="info-step">
          <span class="step-num">3</span>
          <p>Không chia sẻ mã OTP với bất kỳ ai</p>
        </div>
      </div>
    </div>

    <div class="auth-form-container">
      <div class="auth-form-box" style="text-align: center">
        <i
          class="fa-solid fa-envelope-circle-check"
          style="font-size: 50px; color: #00b14f; margin-bottom: 15px"></i>
        <h2 style="margin-bottom: 5px">Nhập mã xác thực</h2>

        <div class="email-badge">
          <i class="fa-solid fa-envelope"></i>
          <span>${email}</span>
        </div>

        <c:if test="${not empty error}">
          <div
            class="alert alert-danger"
            style="
              background: #ffebee;
              color: #c62828;
              padding: 12px 15px;
              border-radius: 8px;
              margin: 15px 0;
              border-left: 4px solid #c62828;
              text-align: left;
            ">
            <i class="fa-solid fa-circle-exclamation"></i> ${error}
          </div>
        </c:if>

        <!-- Timer Circle -->
        <div class="timer-circle" id="timerCircle">
          <span class="time" id="timerDisplay">5:00</span>
          <span class="label">còn lại</span>
        </div>

        <form
          action="<c:url value='/auth/verify-reset-otp'/>"
          method="POST"
          id="otpForm">
          <!-- 6 OTP Input Boxes -->
          <div class="otp-container">
            <input
              type="text"
              class="otp-input"
              maxlength="1"
              data-index="0"
              autofocus />
            <input type="text" class="otp-input" maxlength="1" data-index="1" />
            <input type="text" class="otp-input" maxlength="1" data-index="2" />
            <input type="text" class="otp-input" maxlength="1" data-index="3" />
            <input type="text" class="otp-input" maxlength="1" data-index="4" />
            <input type="text" class="otp-input" maxlength="1" data-index="5" />
          </div>

          <!-- Hidden input to collect full OTP -->
          <input type="hidden" name="otp" id="otpHidden" />

          <button type="submit" class="btn-ghtk-auth" style="margin-top: 10px">
            <i class="fa-solid fa-check-circle"></i> Xác minh OTP
          </button>
        </form>

        <!-- Resend Section -->
        <div style="margin-top: 25px" id="resendSection">
          <p style="color: #666; font-size: 14px; margin-bottom: 10px">
            Chưa nhận được mã?
          </p>
          <button
            class="resend-btn"
            id="resendBtn"
            disabled
            onclick="resendOtp()">
            <i class="fa-solid fa-rotate-right"></i>
            <span id="resendText"
              >Gửi lại sau <span id="resendTimer">60</span>s</span
            >
          </button>
        </div>

        <div style="margin-top: 25px">
          <a
            href="<c:url value='/auth/forgot-password'/>"
            style="color: #666; text-decoration: none">
            <i class="fa-solid fa-arrow-left"></i> Quay lại
          </a>
        </div>
      </div>
    </div>
  </div>

  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script>
    // OTP Input handling
    const inputs = document.querySelectorAll(".otp-input");
    const form = document.getElementById("otpForm");
    const otpHidden = document.getElementById("otpHidden");

    inputs.forEach((input, index) => {
      input.addEventListener("input", (e) => {
        const value = e.target.value;

        // Only allow numbers
        if (!/^\d*$/.test(value)) {
          e.target.value = "";
          return;
        }

        if (value) {
          input.classList.add("filled");
          // Move to next input
          if (index < inputs.length - 1) {
            inputs[index + 1].focus();
          }
        } else {
          input.classList.remove("filled");
        }

        // Collect OTP
        collectOtp();
      });

      input.addEventListener("keydown", (e) => {
        // Handle backspace
        if (e.key === "Backspace" && !input.value && index > 0) {
          inputs[index - 1].focus();
          inputs[index - 1].value = "";
          inputs[index - 1].classList.remove("filled");
        }
      });

      // Handle paste
      input.addEventListener("paste", (e) => {
        e.preventDefault();
        const pastedData = e.clipboardData
          .getData("text")
          .replace(/\D/g, "")
          .slice(0, 6);
        pastedData.split("").forEach((char, i) => {
          if (inputs[i]) {
            inputs[i].value = char;
            inputs[i].classList.add("filled");
          }
        });
        if (inputs[pastedData.length - 1]) {
          inputs[pastedData.length - 1].focus();
        }
        collectOtp();
      });
    });

    function collectOtp() {
      let otp = "";
      inputs.forEach((input) => (otp += input.value));
      otpHidden.value = otp;
    }

    // Form validation
    form.addEventListener("submit", (e) => {
      collectOtp();
      if (otpHidden.value.length !== 6) {
        e.preventDefault();
        inputs.forEach((input) => {
          if (!input.value) input.classList.add("error");
        });
        setTimeout(() => {
          inputs.forEach((input) => input.classList.remove("error"));
        }, 500);
      }
    });

    // Main countdown timer (5 minutes)
    let mainTimeLeft = 300;
    const timerDisplay = document.getElementById("timerDisplay");
    const timerCircle = document.getElementById("timerCircle");

    const mainCountdown = setInterval(() => {
      mainTimeLeft--;
      const minutes = Math.floor(mainTimeLeft / 60);
      const seconds = mainTimeLeft % 60;
      timerDisplay.textContent =
        minutes + ":" + (seconds < 10 ? "0" : "") + seconds;

      if (mainTimeLeft <= 60) {
        timerCircle.classList.add("timer-expired");
      }

      if (mainTimeLeft <= 0) {
        clearInterval(mainCountdown);
        timerDisplay.textContent = "Hết hạn";
      }
    }, 1000);

    // Resend countdown (60 seconds)
    let resendTimeLeft = 60;
    const resendBtn = document.getElementById("resendBtn");
    const resendTimer = document.getElementById("resendTimer");
    const resendText = document.getElementById("resendText");

    const resendCountdown = setInterval(() => {
      resendTimeLeft--;
      resendTimer.textContent = resendTimeLeft;

      if (resendTimeLeft <= 0) {
        clearInterval(resendCountdown);
        resendBtn.disabled = false;
        resendText.innerHTML = "Gửi lại mã OTP";
      }
    }, 1000);

    function resendOtp() {
      resendBtn.disabled = true;
      resendText.innerHTML =
        '<i class="fa-solid fa-spinner fa-spin"></i> Đang gửi...';

      $.ajax({
        url: '<c:url value="/auth/resend-reset-otp"/>',
        type: "POST",
        success: function (response) {
          resendText.innerHTML = '<i class="fa-solid fa-check"></i> Đã gửi!';
          // Reset resend timer
          setTimeout(() => {
            resendTimeLeft = 60;
            resendText.innerHTML =
              'Gửi lại sau <span id="resendTimer">60</span>s';
          }, 2000);
        },
        error: function (xhr) {
          resendBtn.disabled = false;
          resendText.innerHTML = "Gửi lại mã OTP";
          alert("❌ " + (xhr.responseText || "Lỗi gửi lại OTP"));
        },
      });
    }
  </script>
</body>
