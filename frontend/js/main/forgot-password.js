// ============================================================
// forgot-password.js — CineMax Forgot Password Page
// ============================================================
// URL Backend
const API_AUTH = "http://localhost:8080/api/auth";

// ── HELPERS ────────────────────────────────────────────
const $ = (id) => document.getElementById(id);
// ============================================================
// STATE — Lưu trữ trạng thái hiện tại
// ============================================================
let currentStep = 1;
let countdownTimer = null;

function showError(id, msg) {
    const el = $(id);
    el.textContent = msg;
    el.classList.add("show");
}
function clearError(id) {
    const el = $(id);
    el.textContent = "";
    el.classList.remove("show");
}
function shake(el) {
    el.classList.remove("shake");
    void el.offsetWidth;
    el.classList.add("shake");
}
async function fakeLoad(btn, ms = 1400) {
    btn.classList.add("loading");
    btn.disabled = true;
    await new Promise((r) => setTimeout(r, ms));
    btn.classList.remove("loading");
    btn.disabled = false;
}

// ── STEP INDICATOR ─────────────────────────────────────
function updateIndicator(step) {
    for (let i = 1; i <= 3; i++) {
        const dot = $(`dot-${i}`);
        dot.classList.remove("active", "done");
        if (i < step) dot.classList.add("done");
        if (i === step) dot.classList.add("active");
    }
    for (let i = 1; i <= 2; i++) {
        const line = $(`line-${i}`);
        line.classList.toggle("done", i < step);
    }
}

function goToStep(n) {
    // hide all panels
    document
        .querySelectorAll(".step-panel")
        .forEach((p) => p.classList.remove("active"));
    $("success-panel").classList.remove("show");
    $("step-indicator").style.display = "flex";

    const panel = $(`step-${n}`);
    if (panel) panel.classList.add("active");
    currentStep = n;
    updateIndicator(n);
}

// ── STEP 1: EMAIL (Hoàn chỉnh) ──────────────────────────────────────
$("btn-send-otp").addEventListener("click", async (e) => {
    // 1. Ngăn chặn hành vi mặc định và xóa lỗi cũ
    e.preventDefault();
    const emailInput = $("email");
    const emailValue = emailInput.value.trim();
    clearError("err-email");

    // 2. Kiểm tra định dạng Email tại Front-end
    if (!emailValue || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emailValue)) {
        showError("err-email", "Vui lòng nhập địa chỉ email hợp lệ.");
        shake(emailInput.closest(".input-wrap") || emailInput);
        return;
    }

    // 3. Trạng thái Loading
    btnSubmitLoading($("btn-send-otp"), true);

    try {
        const response = await fetch(`${API_AUTH}/forgot-password`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email: emailValue })
        });

        // 4. Đọc dữ liệu JSON an toàn (Tránh lỗi parse JSON khi server trả về body trống)
        let result = {};
        const contentType = response.headers.get("content-type");
        if (contentType && contentType.includes("application/json")) {
            result = await response.json();
        }

        if (response.ok) {
            // ---- ĐƯỜNG HÀNH TRÌNH THÀNH CÔNG ----
            console.log("Gửi OTP thành công:", result.message);

            // Cập nhật email hiển thị ở Step 2
            $("email-display").textContent = emailValue;

            // Tắt trạng thái loading trước khi chuyển cảnh
            btnSubmitLoading($("btn-send-otp"), false);

            // Chuyển sang Step 2 ngay lập tức
            goToStep(2);

            // Các hiệu ứng phụ sau khi giao diện đã thay đổi
            setTimeout(() => {
                startCountdown(); // Bắt đầu đếm ngược 60s
                if (otpDigits && otpDigits[0]) {
                    otpDigits[0].focus(); // Tự động focus ô nhập OTP đầu tiên
                }
            }, 100);

        } else {
            // ---- LỖI TỪ BACKEND (Ví dụ: 404 Email không tồn tại) ----
            const errorMsg = result.message || "Email không tồn tại trong hệ thống.";
            showError("err-email", errorMsg);
            shake(emailInput.closest(".input-wrap"));
            btnSubmitLoading($("btn-send-otp"), false);
        }

    } catch (error) {
        // ---- LỖI KẾT NỐI THỰC SỰ (Server sập, sai IP/Port) ----
        console.error("Lỗi Fetch:", error);
        // Chỉ hiện thông báo này khi thực sự không gọi được API
        alert("Không thể kết nối đến máy chủ. Hãy kiểm tra Backend (Port 8080)!");
        btnSubmitLoading($("btn-send-otp"), false);
    }
});

// ── STEP 2: OTP DIGITS ─────────────────────────────────
const otpDigits = Array.from(document.querySelectorAll(".otp-digit"));

otpDigits.forEach((inp, idx) => {
    inp.addEventListener("input", () => {
        inp.value = inp.value.replace(/\D/, "").slice(-1);
        if (inp.value) {
            inp.classList.add("filled");
            if (idx < otpDigits.length - 1) otpDigits[idx + 1].focus();
        } else {
            inp.classList.remove("filled");
        }
        clearError("err-otp");
    });
    inp.addEventListener("keydown", (e) => {
        if (e.key === "Backspace" && !inp.value && idx > 0) {
            otpDigits[idx - 1].focus();
            otpDigits[idx - 1].value = "";
            otpDigits[idx - 1].classList.remove("filled");
        }
        if (e.key === "ArrowLeft" && idx > 0) otpDigits[idx - 1].focus();
        if (e.key === "ArrowRight" && idx < otpDigits.length - 1)
            otpDigits[idx + 1].focus();
    });
    inp.addEventListener("paste", (e) => {
        e.preventDefault();
        const pasted = (e.clipboardData || window.clipboardData)
            .getData("text")
            .replace(/\D/g, "");
        pasted
            .split("")
            .slice(0, otpDigits.length - idx)
            .forEach((ch, i) => {
                otpDigits[idx + i].value = ch;
                otpDigits[idx + i].classList.add("filled");
            });
        const last = Math.min(idx + pasted.length, otpDigits.length - 1);
        otpDigits[last].focus();
    });
});

function getOTP() {
    return otpDigits.map((d) => d.value).join("");
}

// ── COUNTDOWN ──────────────────────────────────────────
function startCountdown() {
    let secs = 60;
    $("countdown").textContent = secs;
    $("countdown").parentElement.querySelector(".btn-resend") &&
    $("btn-resend").classList.remove("show");
    const row = $("resend-row");
    row.innerHTML = `Gửi lại OTP sau: <span class="countdown" id="countdown">60</span>s
        <button class="btn-resend" id="btn-resend">Gửi lại OTP</button>`;

    clearInterval(countdownTimer);
    countdownTimer = setInterval(() => {
        secs--;
        const cd = $("countdown");
        if (cd) cd.textContent = secs;
        if (secs <= 0) {
            clearInterval(countdownTimer);
            const row = $("resend-row");
            row.innerHTML = `<button class="btn-resend show" id="btn-resend">
                <i class="fas fa-redo"></i> Gửi lại OTP
            </button>`;
            // Phải gán lại sự kiện sau khi ghi đè innerHTML
            $("btn-resend").onclick = () => {
                $("btn-send-otp").click(); // Tận dụng lại logic gửi OTP ở Step 1
            };
        }
    }, 1000);
}

// ── VERIFY OTP ─────────────────────────────────────────
$("btn-verify-otp").addEventListener("click", () => {
    const otp = getOTP();
    if (otp.length < 6) {
        showError("err-otp", "Vui lòng nhập đủ 6 chữ số OTP.");
        shake($("otp-wrap"));
        return;
    }
    // Ở bước này, ta chỉ đơn giản chuyển qua bước nhập mật khẩu mới.
    // Việc xác thực mã OTP thực sự sẽ diễn ra ở bước cuối cùng cùng với Reset Password.
    goToStep(3);
    $("new-pw").focus();
});

// ── BACK TO STEP 1 ─────────────────────────────────────
$("back-to-1").addEventListener("click", (e) => {
    e.preventDefault();
    clearInterval(countdownTimer);
    otpDigits.forEach((d) => {
        d.value = "";
        d.classList.remove("filled");
    });
    clearError("err-otp");
    goToStep(1);
});

// ── STRENGTH METER ─────────────────────────────────────
$("new-pw").addEventListener("input", () => {
    const pw = $("new-pw").value;
    const wrap = $("strength-wrap");
    const fill = $("strength-fill");
    const lbl = $("strength-label");

    if (!pw) {
        wrap.classList.remove("show");
        return;
    }
    wrap.classList.add("show");

    let score = 0;
    if (pw.length >= 6) score++;
    if (pw.length >= 10) score++;
    if (/[A-Z]/.test(pw)) score++;
    if (/[0-9]/.test(pw)) score++;
    if (/[^A-Za-z0-9]/.test(pw)) score++;

    let pct = "25%",
        color = "#ff4444",
        text = "Yếu";
    if (score >= 2) {
        pct = "50%";
        color = "#ffaa00";
        text = "Trung bình";
    }
    if (score >= 3) {
        pct = "75%";
        color = "#88c200";
        text = "Khá mạnh";
    }
    if (score >= 4) {
        pct = "100%";
        color = "#22c55e";
        text = "Mạnh";
    }

    fill.style.width = pct;
    fill.style.background = color;
    lbl.textContent = text;
    lbl.style.color = color;

    clearError("err-new-pw");
    if ($("confirm-pw").value) validateConfirm();
});

// ── STEP 3: CHANGE PASSWORD ────────────────────────────
function validateNewPw() {
    const val = $("new-pw").value;
    if (!val) {
        showError("err-new-pw", "Mật khẩu không được để trống.");
        return false;
    }
    if (val.length < 6) {
        showError("err-new-pw", "Mật khẩu phải có ít nhất 6 ký tự.");
        return false;
    }
    clearError("err-new-pw");
    $("new-pw").classList.add("valid");
    return true;
}
function validateConfirm() {
    const pw = $("new-pw").value;
    const cfm = $("confirm-pw").value;
    if (!cfm) {
        showError("err-confirm-pw", "Vui lòng xác nhận mật khẩu.");
        return false;
    }
    if (cfm !== pw) {
        showError("err-confirm-pw", "Mật khẩu không khớp.");
        return false;
    }
    clearError("err-confirm-pw");
    $("confirm-pw").classList.add("valid");
    return true;
}

$("new-pw").addEventListener("blur", validateNewPw);
$("confirm-pw").addEventListener("blur", validateConfirm);
$("confirm-pw").addEventListener("input", () => {
    if ($("confirm-pw").classList.contains("invalid") || $("confirm-pw").value)
        validateConfirm();
});

$("btn-change-pw").addEventListener("click", async () => {
    const ok1 = validateNewPw();
    const ok2 = validateConfirm();
    if (!ok1 || !ok2) return;

    const resetData = {
        email: $("email").value.trim(),
        otp: getOTP(),
        newPassword: $("new-pw").value
    };

    btnSubmitLoading($("btn-change-pw"), true);

    try {
        const response = await fetch(`${API_AUTH}/reset-password`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(resetData)
        });

        const result = await response.json();

        if (response.ok) {
            showSuccess();
        } else {
            // Nếu OTP sai hoặc hết hạn, quay lại bước 2 để người dùng nhập lại
            alert(result.message || "Có lỗi xảy ra.");
            if (result.message.includes("OTP")) goToStep(2);
        }
    } catch (error) {
        alert("Không thể kết nối đến máy chủ.");
    } finally {
        btnSubmitLoading($("btn-change-pw"), false);
    }
});

// ── SUCCESS ────────────────────────────────────────────
function showSuccess() {
    document
        .querySelectorAll(".step-panel")
        .forEach((p) => p.classList.remove("active"));
    $("step-indicator").style.display = "none";
    const s = $("success-panel");
    s.classList.add("show");
    requestAnimationFrame(() => {
        $("success-fill").style.width = "100%";
    });
    setTimeout(() => {
        window.location.href = "login.html";
    }, 2800);
}

// ── TOGGLE PASSWORD ────────────────────────────────────
document.querySelectorAll(".toggle-pw").forEach((btn) => {
    btn.addEventListener("click", () => {
        const inp = document.getElementById(btn.dataset.target);
        const icon = btn.querySelector("i");
        const hide = inp.type === "password";
        inp.type = hide ? "text" : "password";
        icon.classList.toggle("fa-eye", !hide);
        icon.classList.toggle("fa-eye-slash", hide);
    });
});

function btnSubmitLoading(btn, isLoading) {
    if (!btn) return;
    if (isLoading) {
        btn.classList.add("loading");
        btn.disabled = true;
    } else {
        btn.classList.remove("loading");
        btn.disabled = false;
    }
}

// ── INIT ───────────────────────────────────────────────
goToStep(1);
