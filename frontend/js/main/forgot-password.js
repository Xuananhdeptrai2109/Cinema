// ============================================================
// forgot-password.js — CineMax Forgot Password Page
// ============================================================

// ── MOCK DATA ──────────────────────────────────────────
const VALID_EMAIL = "test@gmail.com";
const MOCK_OTP = "123456";

// ── STATE ──────────────────────────────────────────────
let currentStep = 1;
let countdownTimer = null;

// ── HELPERS ────────────────────────────────────────────
const $ = (id) => document.getElementById(id);

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

// ── STEP 1: EMAIL ──────────────────────────────────────
$("btn-send-otp").addEventListener("click", async () => {
    const email = $("email").value.trim();
    clearError("err-email");
    $("email").classList.remove("invalid", "valid");

    if (!email) {
        showError("err-email", "Email không được để trống.");
        shake($("email").closest(".input-wrap") || $("email"));
        return;
    }
    const emailReg = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailReg.test(email)) {
        showError("err-email", "Địa chỉ email không hợp lệ.");
        $("email").classList.add("invalid");
        shake($("email").closest(".input-wrap"));
        return;
    }

    await fakeLoad($("btn-send-otp"));

    if (email.toLowerCase() !== VALID_EMAIL) {
        showError("err-email", "Email không tồn tại trong hệ thống.");
        $("email").classList.add("invalid");
        shake($("email").closest(".input-wrap"));
        return;
    }

    $("email").classList.add("valid");
    $("email-display").textContent = email;
    goToStep(2);
    startCountdown();
    otpDigits[0].focus();
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
            $("btn-resend").addEventListener("click", () => {
                otpDigits.forEach((d) => {
                    d.value = "";
                    d.classList.remove("filled");
                });
                clearError("err-otp");
                otpDigits[0].focus();
                startCountdown();
            });
        }
    }, 1000);
}

// ── VERIFY OTP ─────────────────────────────────────────
$("btn-verify-otp").addEventListener("click", async () => {
    const otp = getOTP();
    clearError("err-otp");

    if (otp.length < 6) {
        showError("err-otp", "Vui lòng nhập đủ 6 chữ số OTP.");
        shake($("otp-wrap"));
        return;
    }

    await fakeLoad($("btn-verify-otp"), 1200);

    if (otp !== MOCK_OTP) {
        showError("err-otp", "OTP không đúng. Vui lòng thử lại.");
        otpDigits.forEach((d) => {
            d.classList.add("invalid-flash");
            d.value = "";
            d.classList.remove("filled");
        });
        setTimeout(
            () => otpDigits.forEach((d) => d.classList.remove("invalid-flash")),
            600,
        );
        shake($("otp-wrap"));
        otpDigits[0].focus();
        return;
    }

    clearInterval(countdownTimer);
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
    if (!ok1) {
        shake($("new-pw").closest(".input-wrap"));
        $("new-pw").focus();
        return;
    }
    if (!ok2) {
        shake($("confirm-pw").closest(".input-wrap"));
        $("confirm-pw").focus();
        return;
    }

    await fakeLoad($("btn-change-pw"), 1500);
    showSuccess();
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

// ── INIT ───────────────────────────────────────────────
goToStep(1);
