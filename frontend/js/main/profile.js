// ============================================================
// profile.js — CineMax Profile Page Scripts
// ============================================================
// Cập nhật URL API của bạn
const API_USER_PROFILE = "http://localhost:8080/api/users/profile";
const mockData = {
    user: {},
    coinHistory: [],
    vouchers: [],
    voucherHistory: [],
    tickets: []
};
async function fetchUserProfile() {
    const token = localStorage.getItem('token');
    if (!token) {
        console.warn("Không tìm thấy Token. Chuyển hướng về trang chủ...");
        window.location.href = 'home.html';
        return;
    }
    try {
        const response = await fetch(API_USER_PROFILE, {
            method: 'GET',
            headers: {
                // Đảm bảo không có khoảng trắng thừa trong chuỗi 'Bearer '
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            }
        });
        if (response.ok) {
            const userData = await response.json();
            console.log("Dữ liệu nhận từ API:", userData); // Kiểm tra dữ liệu thực tế

            // Cập nhật mockData một cách an toàn
            mockData.user = {
                ...mockData.user,
                ...userData // Tự động ghi đè các trường khớp tên (fullName, imgUrl, phoneNumber, address...)
            };

            // Đồng bộ tên vào localStorage nếu nó bị thay đổi ở Backend
            if (userData.fullName) {
                localStorage.setItem('username', userData.fullName);
            }
            fillDataToUI();
        } else if (response.status === 403) {
            console.error("Lỗi 403: Không có quyền truy cập. Đang yêu cầu đăng nhập lại...");
            // Thường lỗi này do Token hết hạn hoặc Secret Key trên Server thay đổi
            showToast("Phiên đăng nhập hết hạn, vui lòng đăng nhập lại", "error");
            // localStorage.removeItem('token'); // Có thể xóa token cũ để user đăng nhập lại
        } else {
            console.error(`Lỗi API: ${response.status}`);
        }
    } catch (error) {
        console.error("Lỗi kết nối API Profile:", error);
        // Hiển thị thông báo lỗi lên giao diện thay vì chỉ console
        const profileName = document.getElementById('displayName');
        if (profileName) profileName.textContent = "Lỗi tải dữ liệu";
    }
}
// Cập nhật hàm fillDataToUI để sử dụng đúng trường imgUrl từ Database
function fillDataToUI() {
    const u = mockData.user;
    if (!u) return;

    // 1. Lấy trực tiếp dữ liệu từ cột username (không cần xử lý cắt chuỗi @)
    const username = u.userName || 'username';

    // 2. Ảnh đại diện (Sử dụng username làm seed cho ảnh mặc định nếu không có imgUrl)
    const avatarUrl = u.imgUrl || `https://api.dicebear.com/7.x/avataaars/svg?seed=${username}`;
    const pImg = document.getElementById('profileAvatar');
    const sImg = document.getElementById('sidebarAvatar');
    if (pImg) pImg.src = avatarUrl;
    if (sImg) sImg.src = avatarUrl;

    // 3. Hiển thị Email (Cả phần xem và ô input readonly)
    const emailView = document.getElementById('viewEmail');
    if (emailView) emailView.textContent = u.email || '---';

    const emailInput = document.getElementById('inputEmail');
    if (emailInput) {
        emailInput.value = u.email || '';
    }

    // 4. Thông tin cơ bản (View Mode)
    const viewElements = {
        // Ưu tiên hiện fullName, nếu trống thì hiện 'Chưa cập nhật'
        'viewName': (u.fullName && u.fullName.trim() !== "") ? u.fullName : 'Chưa cập nhật',
        'viewPhone': u.phoneNumber || 'Chưa cập nhật',
        'viewAddress': u.address || 'Chưa cập nhật'
    };

    for (const [id, value] of Object.entries(viewElements)) {
        const el = document.getElementById(id);
        if (el) el.textContent = value;
    }

    // Xử lý hiển thị Ngày sinh (YYYY-MM-DD -> DD/MM/YYYY)
    const dobEl = document.getElementById('viewDob');
    if (dobEl && u.dateOfBirth) {
        const dateParts = u.dateOfBirth.split('-');
        if (dateParts.length === 3) {
            const [y, m, d] = dateParts;
            dobEl.textContent = `${d}/${m}/${y}`;
        }
    }

    // 5. Thông tin hiển thị định danh (Header/Sidebar/Profile Card)
    const nameElements = {
        // Tên lớn: Ưu tiên fullName, nếu không có mới dùng username thực tế
        'displayName': u.fullName || username || 'Người dùng',
        'sidebarName': u.fullName || username || 'Người dùng',

        // Hiển thị biệt danh có dấu @ lấy trực tiếp từ DB (Ví dụ: @hihihi)
        'display-username': `@${username}`,
        'displayUsername': `@${username}`
    };

    for (const [id, value] of Object.entries(nameElements)) {
        const el = document.getElementById(id);
        if (el) el.textContent = value;
    }

    // 6. Số dư Coin
    const coinVal = u.coin || 0;
    const coinBadge = document.querySelector('.sidebar-coin-badge');
    if (coinBadge) {
        coinBadge.innerHTML = `🪙 <span id="sidebarCoin">${coinVal.toLocaleString()}</span>`;
    }
    const coinBalance = document.getElementById('coinBalance');
    if (coinBalance) {
        coinBalance.textContent = coinVal.toLocaleString();
    }
}
/* ──────────────────────────────────────
   HEADER — STICKY SCROLL (từ home.js)
────────────────────────────────────── */
function initStickyHeader() {
    const header = document.getElementById('header');
    if (!header) return;
    // Bật ngay nếu trang đã scroll
    if (window.scrollY > 60) header.classList.add('scrolled');
    window.addEventListener('scroll', () => {
        header.classList.toggle('scrolled', window.scrollY > 60);
    }, { passive: true });
}

/* ──────────────────────────────────────
   HEADER — HAMBURGER MOBILE (từ home.js)
────────────────────────────────────── */
function initMobileMenu() {
    const hamburger = document.getElementById('hamburger');
    const mobileNav = document.getElementById('mobile-nav');
    if (!hamburger || !mobileNav) return;

    hamburger.addEventListener('click', () => {
        hamburger.classList.toggle('open');
        mobileNav.classList.toggle('open');
    });
}

/* ──────────────────────────────────────
   HEADER — AUTH ZONE (từ home.js)
   Đọc username từ localStorage
────────────────────────────────────── */
function initAuthZone() {
    const guestZone      = document.getElementById('guest-zone');
    const userZone       = document.getElementById('user-zone');
    const displayUsername = document.getElementById('display-username');
    const btnLogout      = document.getElementById('btn-logout');

    const storedUsername = localStorage.getItem('username');

    if (storedUsername) {
        if (guestZone) guestZone.style.display = 'none';
        if (userZone)  { userZone.style.display = 'flex'; displayUsername.textContent = storedUsername; }
        // Sync sidebar name
        document.getElementById('sidebarName').textContent = storedUsername;
        document.getElementById('displayName').textContent  = storedUsername;
    } else {
        if (guestZone) guestZone.style.display = 'flex';
        if (userZone)  userZone.style.display  = 'none';
    }

    if (btnLogout) {
        btnLogout.addEventListener('click', (e) => {
            e.preventDefault();
            localStorage.removeItem('username');
            localStorage.removeItem('token');
            window.location.reload();
        });
    }
}

/* ──────────────────────────────────────
   SIDEBAR MOBILE (profile riêng)
────────────────────────────────────── */
function initSidebarMobile() {
    // Tạo backdrop nếu chưa có
    let backdrop = document.querySelector('.sidebar-backdrop');
    if (!backdrop) {
        backdrop = document.createElement('div');
        backdrop.className = 'sidebar-backdrop';
        document.body.appendChild(backdrop);
    }

    const sidebar = document.getElementById('sidebar');

    // Toggle sidebar bằng hamburger ở 700px trở xuống
    // (hamburger đã dùng cho mobile-nav nav; tạo nút riêng qua menu icon sidebar)
    backdrop.addEventListener('click', closeSidebarMobile);

    function closeSidebarMobile() {
        sidebar.classList.remove('open');
        backdrop.classList.remove('show');
    }

    // Đóng sidebar khi click menu item
    document.querySelectorAll('.sidebar-menu-item').forEach(item => {
        item.addEventListener('click', () => {
            if (window.innerWidth <= 700) closeSidebarMobile();
        });
    });

    // Mở sidebar bằng cách click logo sidebar trên mobile
    const sidebarProfile = document.querySelector('.sidebar-profile');
    document.querySelector('.logo').addEventListener('click', (e) => {
        if (window.innerWidth <= 700) {
            e.preventDefault();
            sidebar.classList.toggle('open');
            backdrop.classList.toggle('show');
        }
    });
}

/* ──────────────────────────────────────
   TOAST
────────────────────────────────────── */
let toastTimer;
function showToast(msg, type = 'success') {
    const t = document.getElementById('toast');
    const m = document.getElementById('toastMsg');
    m.textContent = msg;
    t.className = 'toast' + (type === 'error' ? ' error' : '');
    void t.offsetWidth;
    t.classList.add('show');
    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => t.classList.remove('show'), 3200);
}

/* ──────────────────────────────────────
   TAB SWITCHING
────────────────────────────────────── */
function switchTab(tabId) {
    document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
    document.querySelectorAll('.sidebar-menu-item').forEach(i => i.classList.remove('active'));
    const panel    = document.getElementById(tabId);
    const menuItem = document.querySelector('[data-tab="' + tabId + '"]');
    if (panel)    panel.classList.add('active');
    if (menuItem) menuItem.classList.add('active');
}

function initTabs() {
    document.querySelectorAll('.sidebar-menu-item').forEach(item => {
        item.addEventListener('click', () => switchTab(item.dataset.tab));
    });
}

/* ──────────────────────────────────────
   AVATAR UPLOAD — TỰ ĐỘNG CẬP NHẬT DB
────────────────────────────────────── */
function initAvatarUpload() {
    const avatarInput = document.getElementById('avatar-input');
    if (!avatarInput) return;

    avatarInput.addEventListener('change', function () {
        const file = this.files[0];
        if (!file) return;

        const reader = new FileReader();
        reader.onload = async (e) => {
            const base64Image = e.target.result;
            const token = localStorage.getItem('token');

            // 1. Hiển thị xem trước lên giao diện ngay lập tức
            const pAvatar = document.getElementById('profileAvatar');
            const sAvatar = document.getElementById('sidebarAvatar');
            if (pAvatar) pAvatar.src = base64Image;
            if (sAvatar) sAvatar.src = base64Image;

            // 2. TỰ ĐỘNG GỌI API ĐỂ LƯU VÀO DB
            try {
                // Chúng ta gửi kèm cả thông tin hiện tại để tránh bị null các trường khác
                const updatedData = {
                    fullName: mockData.user.fullName,
                    dateOfBirth: mockData.user.dateOfBirth,
                    phoneNumber: mockData.user.phoneNumber,
                    address: mockData.user.address,
                    imgUrl: base64Image // Đây là dữ liệu ảnh mới
                };

                const response = await fetch(API_USER_PROFILE, {
                    method: 'PUT',
                    headers: {
                        'Authorization': `Bearer ${token}`,
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(updatedData)
                });

                if (response.ok) {
                    mockData.user.imgUrl = base64Image; // Cập nhật biến tạm
                    showToast('Đã cập nhật ảnh đại diện thành công!');
                } else {
                    showToast('Không thể lưu ảnh vào máy chủ', 'error');
                }
            } catch (error) {
                console.error("Lỗi tự động lưu ảnh:", error);
                showToast('Lỗi kết nối khi lưu ảnh', 'error');
            }
        };
        reader.readAsDataURL(file);
    });
}
/* ──────────────────────────────────────
   EDIT PROFILE
────────────────────────────────────── */
window.enableEditMode = function() {
    const u = mockData.user;
    if (!u) {
        console.error("Dữ liệu người dùng chưa được tải!");
        return;
    }

    // 1. Điền dữ liệu hiện tại vào các ô input (Dùng || '' để tránh hiện chữ 'undefined')
    const inputFields = {
        'inputName': u.fullName || u.userName || '',
        'inputDob': u.dateOfBirth || '',
        'inputAddress': u.address || '',
        'inputEmail': u.email || '',
        'inputPhone': u.phoneNumber || ''
    };

    for (const [id, value] of Object.entries(inputFields)) {
        const el = document.getElementById(id);
        if (el) {
            el.value = value;
        } else {
            console.warn(`Không tìm thấy thẻ input có id: ${id}`);
        }
    }

    // 2. Chuyển đổi giao diện (Ẩn View, Hiện Edit)
    const viewArea = document.getElementById('viewMode');
    const editArea = document.getElementById('editMode');

    if (viewArea && editArea) {
        viewArea.style.display = 'none';
        editArea.style.display = 'block';
    } else {
        console.error("Không tìm thấy div viewMode hoặc editMode trong HTML!");
    }
}

function cancelEdit() {
    document.getElementById('viewMode').style.display = 'block';
    document.getElementById('editMode').style.display = 'none';
}

window.cancelEdit = function() {
    const viewArea = document.getElementById('viewMode');
    const editArea = document.getElementById('editMode');
    if (viewArea && editArea) {
        viewArea.style.display = 'block';
        editArea.style.display = 'none';
    }
}

window.saveProfile = async function() {
    const token = localStorage.getItem('token');
    const updatedData = {
        fullName: document.getElementById('inputName').value.trim(),
        dateOfBirth: document.getElementById('inputDob').value,
        phoneNumber: document.getElementById('inputPhone').value.trim(),
        address: document.getElementById('inputAddress').value.trim(),
    };

    if (!updatedData.fullName) {
        showToast('Họ và tên không được để trống!', 'error');
        return;
    }

    try {
        const response = await fetch(API_USER_PROFILE, {
            method: 'PUT',
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(updatedData)
        });

        if (response.ok) {
            // Cập nhật thành công
            mockData.user = { ...mockData.user, ...updatedData };
            localStorage.setItem('username', updatedData.fullName);
            fillDataToUI();
            cancelEdit();
            showToast('Cập nhật hồ sơ thành công!');
        } else {
            // Xử lý lỗi an toàn khi không có JSON trả về
            let errorMessage = "Cập nhật thất bại (Lỗi " + response.status + ")";
            try {
                const errorData = await response.json();
                errorMessage = errorData.message || errorMessage;
            } catch (e) {
                console.warn("Server không trả về JSON lỗi.");
            }

            if (response.status === 403) {
                showToast("Bạn không có quyền thực hiện thao tác này hoặc phiên hết hạn!", "error");
            } else {
                showToast(errorMessage, "error");
            }
        }
    } catch (error) {
        console.error("Lỗi cập nhật Profile:", error);
        showToast('Lỗi kết nối máy chủ!', 'error');
    }
};

/* ──────────────────────────────────────
   RENDER COIN HISTORY
────────────────────────────────────── */
function renderCoinHistory() {
    const tbody = document.getElementById('coinHistoryBody');
    tbody.innerHTML = mockData.coinHistory.map(row => `
    <tr>
      <td>${row.date}</td>
      <td>${row.content}</td>
      <td class="${row.amount > 0 ? 'coin-positive' : 'coin-negative'}">
        ${row.amount > 0 ? '+' : ''}${row.amount.toLocaleString()} Coin
      </td>
    </tr>
  `).join('');
}

/* ──────────────────────────────────────
   RENDER VOUCHERS
────────────────────────────────────── */
function renderVouchers() {
    const grid = document.getElementById('voucherGrid');
    const statusMap = {
        valid:   { label: 'Còn hiệu lực', cls: 'badge-valid'   },
        used:    { label: 'Đã sử dụng',   cls: 'badge-used'    },
        expired: { label: 'Hết hạn',      cls: 'badge-expired' },
    };
    grid.innerHTML = mockData.vouchers.map(v => {
        const s = statusMap[v.status] || statusMap.valid;
        return `
      <div class="voucher-card">
        <div class="voucher-card-top">
          <span class="voucher-code">${v.code}</span>
          <span class="voucher-discount">${v.discount}</span>
        </div>
        <div class="voucher-card-bottom">
          <div class="voucher-expiry"><i class="fas fa-calendar-alt"></i> HSD: ${v.expiry}</div>
          <span class="voucher-status-badge ${s.cls}">${s.label}</span>
        </div>
      </div>
    `;
    }).join('');

    const tbody = document.getElementById('voucherHistoryBody');
    tbody.innerHTML = mockData.voucherHistory.map(v => `
    <tr>
      <td><strong>${v.code}</strong></td>
      <td>${v.usedDate}</td>
      <td style="color:var(--success);font-weight:600">${v.discount}</td>
    </tr>
  `).join('');
}

/* ──────────────────────────────────────
   RENDER TICKET HISTORY
────────────────────────────────────── */
function renderTickets() {
    const list = document.getElementById('ticketList');
    const statusMap = {
        paid:      { label: '<i class="fas fa-check-circle"></i> Đã thanh toán', color: 'var(--success)' },
        upcoming:  { label: '<i class="fas fa-clock"></i> Sắp chiếu',            color: '#60a5fa'        },
        cancelled: { label: '<i class="fas fa-times-circle"></i> Đã hủy',        color: '#f87171'        },
    };
    list.innerHTML = mockData.tickets.map(t => {
        const s = statusMap[t.status] || statusMap.paid;
        return `
      <div class="ticket-card">
        <div class="ticket-poster">${t.poster}</div>
        <div class="ticket-info">
          <div class="ticket-movie">${t.movie}</div>
          <div class="ticket-meta">
            <div class="ticket-meta-item"><i class="fas fa-calendar-alt"></i> <strong>${t.date}</strong></div>
            <div class="ticket-meta-item"><i class="fas fa-clock"></i> <strong>${t.time}</strong></div>
            <div class="ticket-meta-item"><i class="fas fa-chair"></i> <strong>${t.seats}</strong></div>
            <div class="ticket-meta-item"><i class="fas fa-map-marker-alt"></i> <strong>${t.cinema}</strong></div>
            <div class="ticket-meta-item"><i class="fas fa-film"></i> <strong>${t.room}</strong></div>
          </div>
          <span style="color:${s.color}; font-size:.78rem; font-weight:600; display:inline-flex; align-items:center; gap:5px;">${s.label}</span>
        </div>
        <div class="ticket-actions">
          <button class="btn-detail" onclick="showTicketPopup(${t.id})">Xem chi tiết</button>
        </div>
      </div>
    `;
    }).join('');
}

/* ──────────────────────────────────────
   POPUP TICKET DETAIL
────────────────────────────────────── */
function showTicketPopup(ticketId) {
    const t = mockData.tickets.find(t => t.id === ticketId);
    if (!t) return;
    const statusLabel = { paid: 'Đã thanh toán', upcoming: 'Sắp chiếu', cancelled: 'Đã hủy' };
    document.getElementById('popupMovieTitle').textContent = t.movie;
    const rows = [
        { label: 'Ngày chiếu', value: t.date },
        { label: 'Giờ chiếu',  value: t.time },
        { label: 'Ghế',        value: t.seats },
        { label: 'Rạp',        value: t.cinema },
        { label: 'Phòng',      value: t.room },
        { label: 'Giá vé',     value: t.price },
        { label: 'Trạng thái', value: statusLabel[t.status] || t.status },
    ];
    document.getElementById('popupRows').innerHTML = rows.map(r => `
    <div class="popup-row">
      <span class="popup-row-label">${r.label}</span>
      <span class="popup-row-value">${r.value}</span>
    </div>
  `).join('');
    document.getElementById('popupOverlay').classList.add('show');
    document.body.style.overflow = 'hidden';
}

function hidePopup() {
    document.getElementById('popupOverlay').classList.remove('show');
    document.body.style.overflow = '';
}

function closePopup(e) {
    if (e.target === document.getElementById('popupOverlay')) hidePopup();
}

document.addEventListener('keydown', e => { if (e.key === 'Escape') hidePopup(); });

/* ──────────────────────────────────────
   KHỞI TẠO — ĐÃ SỬA LỖI BIẾN STOREDNAME
────────────────────────────────────── */
document.addEventListener('DOMContentLoaded', async () => {
    const storedUsername = localStorage.getItem('username');
    
    if (storedUsername && !storedUsername.includes('@')) {
        const sidebarNameEl = document.getElementById('sidebarName');
        const displayNameEl = document.getElementById('displayName');
        const dUsernameEl = document.getElementById('display-username');

        if (sidebarNameEl) sidebarNameEl.textContent = storedUsername;
        if (displayNameEl) displayNameEl.textContent = storedUsername;
        if (dUsernameEl) dUsernameEl.textContent = storedUsername;
    }

    // Sau đó mới gọi API để lấy dữ liệu thực tế từ Database
    await fetchUserProfile();

    // Khởi tạo các thành phần khác
    initStickyHeader();
    initAuthZone();
    initTabs();
    initAvatarUpload();

    // Render các danh sách lịch sử
    renderCoinHistory();
    renderVouchers();
    renderTickets();
});