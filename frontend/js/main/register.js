// ============================================================
// ELEMENTS
// ============================================================
const form         = document.getElementById('register-form');
const btnSubmit    = document.getElementById('btn-submit');
const successOverlay = document.getElementById('success-overlay');
const successBarFill = document.getElementById('success-bar-fill');

const fields = {
    username: document.getElementById('username'),
    gmail:    document.getElementById('gmail'),
    password: document.getElementById('password'),
    confirm:  document.getElementById('confirm'),
    terms:    document.getElementById('terms'),
};

const errors = {
    username: document.getElementById('err-username'),
    gmail:    document.getElementById('err-gmail'),
    password: document.getElementById('err-password'),
    confirm:  document.getElementById('err-confirm'),
    terms:    document.getElementById('err-terms'),
};

const strengthFill  = document.getElementById('strength-fill');
const strengthLabel = document.getElementById('strength-label');
const strengthWrap  = document.getElementById('strength-wrap');

// ============================================================
// HELPERS
// ============================================================

/**
 * Show error message under a field
 */
function showError(fieldName, message) {
    const el  = errors[fieldName];
    const inp = fields[fieldName];
    el.textContent = message;
    el.classList.add('show');
    if (inp && inp.tagName === 'INPUT' && inp.type !== 'checkbox') {
        inp.classList.remove('valid');
        inp.classList.add('invalid');
    }
}

/**
 * Clear error message
 */
function clearError(fieldName) {
    const el  = errors[fieldName];
    const inp = fields[fieldName];
    el.textContent = '';
    el.classList.remove('show');
    if (inp && inp.tagName === 'INPUT' && inp.type !== 'checkbox') {
        inp.classList.remove('invalid');
    }
}

/**
 * Mark field as valid
 */
function markValid(fieldName) {
    clearError(fieldName);
    const inp = fields[fieldName];
    if (inp && inp.tagName === 'INPUT' && inp.type !== 'checkbox') {
        inp.classList.add('valid');
    }
}

/**
 * Shake animation on an element
 */
function shake(el) {
    el.classList.remove('shake');
    void el.offsetWidth; // reflow
    el.classList.add('shake');
}

// ============================================================
// VALIDATORS
// ============================================================

function validateUsername() {
    const val = fields.username.value.trim();
    if (!val) {
        showError('username', 'Username không được để trống.');
        return false;
    }
    if (val.length < 3) {
        showError('username', 'Username phải có ít nhất 3 ký tự.');
        return false;
    }
    if (!/^[a-zA-Z0-9_]+$/.test(val)) {
        showError('username', 'Username chỉ được chứa chữ, số và dấu _.');
        return false;
    }
    markValid('username');
    return true;
}

function validateGmail() {
    const val = fields.gmail.value.trim();
    if (!val) {
        showError('gmail', 'Email không được để trống.');
        return false;
    }
    const emailReg = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailReg.test(val)) {
        showError('gmail', 'Địa chỉ email không hợp lệ.');
        return false;
    }
    markValid('gmail');
    return true;
}

function validatePassword() {
    const val = fields.password.value;
    if (!val) {
        showError('password', 'Mật khẩu không được để trống.');
        strengthWrap.classList.remove('show');
        return false;
    }
    if (val.length < 6) {
        showError('password', 'Mật khẩu phải có ít nhất 6 ký tự.');
        return false;
    }
    markValid('password');
    return true;
}

function validateConfirm() {
    const pw  = fields.password.value;
    const cfm = fields.confirm.value;
    if (!cfm) {
        showError('confirm', 'Vui lòng nhập lại mật khẩu.');
        return false;
    }
    if (cfm !== pw) {
        showError('confirm', 'Mật khẩu không khớp.');
        return false;
    }
    markValid('confirm');
    return true;
}

function validateTerms() {
    if (!fields.terms.checked) {
        showError('terms', 'Bạn phải đồng ý với điều khoản sử dụng.');
        return false;
    }
    clearError('terms');
    return true;
}

// ============================================================
// PASSWORD STRENGTH METER
// ============================================================
function calcStrength(pw) {
    let score = 0;
    if (pw.length >= 6)  score++;
    if (pw.length >= 10) score++;
    if (/[A-Z]/.test(pw)) score++;
    if (/[0-9]/.test(pw)) score++;
    if (/[^A-Za-z0-9]/.test(pw)) score++;
    return score; // 0–5
}

function updateStrength(pw) {
    if (!pw) {
        strengthWrap.classList.remove('show');
        return;
    }
    strengthWrap.classList.add('show');

    const score = calcStrength(pw);
    let pct, color, label;

    if (score <= 1) {
        pct = 25;  color = 'var(--sw)'; label = 'Yếu';
    } else if (score <= 2) {
        pct = 50;  color = 'var(--sm)'; label = 'Trung bình';
    } else if (score <= 3) {
        pct = 75;  color = '#88c200';   label = 'Khá mạnh';
    } else {
        pct = 100; color = 'var(--ss)'; label = 'Mạnh';
    }

    strengthFill.style.width      = pct + '%';
    strengthFill.style.background = color;
    strengthLabel.textContent     = label;
    strengthLabel.style.color     = color;
}

// ============================================================
// TOGGLE PASSWORD VISIBILITY
// ============================================================
document.querySelectorAll('.toggle-pw').forEach(btn => {
    btn.addEventListener('click', () => {
        const targetId = btn.dataset.target;
        const input    = document.getElementById(targetId);
        const icon     = btn.querySelector('i');
        const isHidden = input.type === 'password';

        input.type = isHidden ? 'text' : 'password';
        icon.classList.toggle('fa-eye',      !isHidden);
        icon.classList.toggle('fa-eye-slash', isHidden);
    });
});

// ============================================================
// REAL-TIME VALIDATION (on blur + input)
// ============================================================
fields.username.addEventListener('blur',  validateUsername);
fields.username.addEventListener('input', () => {
    if (fields.username.classList.contains('invalid')) validateUsername();
});

fields.gmail.addEventListener('blur',  validateGmail);
fields.gmail.addEventListener('input', () => {
    if (fields.gmail.classList.contains('invalid')) validateGmail();
});

fields.password.addEventListener('input', () => {
    updateStrength(fields.password.value);
    if (fields.password.classList.contains('invalid')) validatePassword();
    // re-check confirm if already touched
    if (fields.confirm.value) validateConfirm();
});
fields.password.addEventListener('blur', validatePassword);

fields.confirm.addEventListener('blur',  validateConfirm);
fields.confirm.addEventListener('input', () => {
    if (fields.confirm.classList.contains('invalid') || fields.confirm.value) {
        validateConfirm();
    }
});

fields.terms.addEventListener('change', validateTerms);

// ============================================================
// FORM SUBMIT
// ============================================================
form.addEventListener('submit', async (e) => {
    e.preventDefault();

    // Run all validators
    const ok = [
        validateUsername(),
        validateGmail(),
        validatePassword(),
        validateConfirm(),
        validateTerms(),
    ];

    // Find first invalid field and shake + focus it
    const fieldOrder = ['username', 'gmail', 'password', 'confirm'];
    for (const name of fieldOrder) {
        if (fields[name].classList.contains('invalid')) {
            shake(fields[name].closest('.input-wrap') || fields[name]);
            fields[name].focus();
            break;
        }
    }

    if (ok.includes(false)) return;

    // ---- Loading state ----
    btnSubmit.classList.add('loading');
    btnSubmit.disabled = true;
    const registerData = {
        username: fields.username.value.trim(),
        email:    fields.gmail.value.trim(),
        password: fields.password.value
    };

    try {
        const response = await fetch('http://localhost:8080/api/auth/register', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(registerData)
        });

        const result = await response.json();

        if (response.ok) {
            localStorage.setItem('username', registerData.username);
            localStorage.setItem('token', result.token);

            btnSubmit.classList.remove('loading');
            showSuccess();
        } else {
            btnSubmit.classList.remove('loading');
            btnSubmit.disabled = false;

            // Nếu Backend báo lỗi về Email, hiển thị ngay dưới ô Gmail
            if (result.message && result.message.includes("Email")) {
                showError('gmail', result.message);
                shake(fields.gmail.closest('.input-wrap'));
            } else if (result.message && result.message.includes("Tên đăng nhập")) {
                showError('username', result.message);
                shake(fields.username.closest('.input-wrap'));
            } else {
                alert("Lỗi đăng ký: " + (result.message || "Vui lòng thử lại sau."));
            }
        }
    } catch (error) {
        console.error("Lỗi kết nối:", error);
        btnSubmit.classList.remove('loading');
        btnSubmit.disabled = false;
        alert("Không thể kết nối đến máy chủ. Hãy đảm bảo Backend Spring Boot đang chạy tại port 8080!");
    }
});

// ============================================================
// SUCCESS SCREEN + REDIRECT
// ============================================================
function showSuccess() {
    successOverlay.classList.add('show');

    // Animate progress bar then redirect
    requestAnimationFrame(() => {
        successBarFill.style.width = '100%';
    });

    setTimeout(() => {
        window.location.href = 'home.html';
    }, 2800);
}

// ============================================================
// ENTER KEY: move to next input
// ============================================================
const inputList = [fields.username, fields.gmail, fields.password, fields.confirm];
inputList.forEach((inp, i) => {
    inp.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') {
            e.preventDefault();
            const next = inputList[i + 1];
            if (next) next.focus();
            else btnSubmit.click();
        }
    });
});

console.log('%c🎬 CineMax Register ready', 'color:#E50914;font-size:13px;font-weight:bold');