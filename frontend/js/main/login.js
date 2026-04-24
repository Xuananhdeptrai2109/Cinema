// ============================================================
// login.js — CineMax Login Page
// Features: validate, toggle password, remember me,
//           loading button, success redirect
// ============================================================

// ============================================================
// ELEMENTS
// ============================================================
const form          = document.getElementById('login-form');
const btnSubmit     = document.getElementById('btn-submit');
const successOverlay = document.getElementById('success-overlay');
const successBarFill = document.getElementById('success-bar-fill');

const fields = {
    gmail:    document.getElementById('email'),
    password: document.getElementById('password'),
};

const errors = {
    gmail:    document.getElementById('err-email'),
    password: document.getElementById('err-password'),
};

// ============================================================
// HELPERS
// ============================================================
function showError(name, msg) {
    errors[name].textContent = msg;
    errors[name].classList.add('show');
    fields[name].classList.remove('valid');
    fields[name].classList.add('invalid');
}

function clearError(name) {
    errors[name].textContent = '';
    errors[name].classList.remove('show');
    fields[name].classList.remove('invalid');
}

function markValid(name) {
    clearError(name);
    fields[name].classList.add('valid');
}

function shake(el) {
    el.classList.remove('shake');
    void el.offsetWidth;
    el.classList.add('shake');
}

// ============================================================
// VALIDATORS
// ============================================================
function validateGmail() {
    const val = fields.gmail.value.trim();
    if (!val) {
        showError('gmail', 'Email không được để trống.');
        return false;
    }
    // Regex kiểm tra định dạng email cơ bản
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
    if (!val) { showError('password', 'Mật khẩu không được để trống.'); return false; }
    if (val.length < 6) { showError('password', 'Mật khẩu phải có ít nhất 6 ký tự.'); return false; }
    markValid('password');
    return true;
}

// ============================================================
// REAL-TIME VALIDATION
// ============================================================
fields.gmail.addEventListener('blur', validateGmail);
fields.gmail.addEventListener('input', () => {
    if (fields.gmail.classList.contains('invalid')) validateGmail();
});

fields.password.addEventListener('blur', validatePassword);
fields.password.addEventListener('input', () => {
    if (fields.password.classList.contains('invalid')) validatePassword();
});

// ============================================================
// TOGGLE PASSWORD
// ============================================================
document.querySelectorAll('.toggle-pw').forEach(btn => {
    btn.addEventListener('click', () => {
        const input = document.getElementById(btn.dataset.target);
        const icon  = btn.querySelector('i');
        const isHidden = input.type === 'password';
        input.type = isHidden ? 'text' : 'password';
        icon.classList.toggle('fa-eye',       !isHidden);
        icon.classList.toggle('fa-eye-slash',  isHidden);
    });
});

// ============================================================
// REMEMBER LOGIN (localStorage)
// ============================================================
const rememberCheck = document.getElementById('remember');
const savedUser = localStorage.getItem('cinemax_remember_user');

if (savedUser) {
    fields.gmail.value = savedUser;
    rememberCheck.checked   = true;
    fields.gmail.classList.add('valid');
}

// ============================================================
// ENTER KEY — move to next field
// ============================================================
fields.gmail.addEventListener('keydown', e => {
    if (e.key === 'Enter') { e.preventDefault(); fields.password.focus(); }
});
fields.password.addEventListener('keydown', e => {
    if (e.key === 'Enter') { e.preventDefault(); btnSubmit.click(); }
});

// ============================================================
// FORM SUBMIT
// ============================================================
form.addEventListener('submit', async e => {
    e.preventDefault();

    const okG = validateGmail();
    const okP = validatePassword();

    if (!okG || !okP) {
        const target = !okG ? fields.gmail : fields.password;
        shake(target.closest('.input-wrap') || target);
        target.focus();
        return;
    }

    // Ghi nhớ tài khoản (Sử dụng email làm định danh)
    if (rememberCheck.checked) {
        localStorage.setItem('cinemax_remember_user', fields.gmail.value.trim());
    } else {
        localStorage.removeItem('cinemax_remember_user');
    }

    btnSubmit.classList.add('loading');
    btnSubmit.disabled = true;

    const loginData = {
        email: fields.gmail.value.trim(),
        password: fields.password.value
    };

    try {
        const response = await fetch('http://localhost:8080/api/auth/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(loginData)
        });

        let result = {};
        const contentType = response.headers.get("content-type");
        if (contentType && contentType.includes("application/json")) {
            result = await response.json();
        }

        if (response.ok) {
            localStorage.setItem('token', result.token);
            const displayName = result.username || fields.gmail.value.split('@')[0];
            localStorage.setItem('username', displayName);
            localStorage.setItem('user', JSON.stringify({
                userId: result.userId,
                username: result.username
            }));
            btnSubmit.classList.remove('loading');
            showSuccess();
        } else {
            btnSubmit.classList.remove('loading');
            btnSubmit.disabled = false;

            if (response.status === 403) {
                alert("Lỗi 403: Spring Security chặn truy cập!");
            } else {
                const errorMsg = result.message || "Tài khoản hoặc mật khẩu không chính xác.";
                // Hiển thị lỗi email nếu không tìm thấy người dùng
                showError(errorMsg.includes("mật khẩu") ? 'password' : 'gmail', errorMsg);
                shake(fields.password.closest('.input-wrap'));
            }
        }
    } catch (error) {
        console.error("Lỗi kết nối:", error);
        btnSubmit.classList.remove('loading');
        btnSubmit.disabled = false;
        alert("Không thể kết nối đến máy chủ!");
    }
});

// ============================================================
// SUCCESS + REDIRECT
// ============================================================
function showSuccess() {
    successOverlay.classList.add('show');
    requestAnimationFrame(() => {
        successBarFill.style.width = '100%';
    });
    setTimeout(() => {
        // Chuyển hướng về trang chủ sau khi đăng nhập thành công
        window.location.href = 'home.html';
    }, 2800);
}

// ============================================================
// INJECT SHAKE KEYFRAME
// ============================================================
const style = document.createElement('style');
style.textContent = `
  @keyframes shake {
    0%,100%{transform:translateX(0)}
    20%,60%{transform:translateX(-6px)}
    40%,80%{transform:translateX(6px)}
  }
  .shake { animation: shake .35s ease; }
`;
document.head.appendChild(style);

console.log('%c🎬 CineMax Login ready', 'color:#E50914;font-size:13px;font-weight:bold');