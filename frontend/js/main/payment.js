// ============================================================
// STATE (Bây giờ sẽ được đổ từ API)
// ============================================================
let dbCombos = [];       // Lấy từ bảng products/product_type
let selectedSeats = [];  // Lấy từ sessionStorage (ghế người dùng vừa chọn)
let addedCombos = [];    // Giỏ hàng bắp nước
let invoiceId = null;    // UUID nhận về từ Backend sau khi tạo hóa đơn

let appliedDiscount = null;
let appliedCoin = 0;
let selectedMethod = 'qr';
let countdownTimer = null;
let comboOffset = 0;
let selectedCombo = null;
let comboQty = 1;

const fmt = n => n.toLocaleString('vi-VN') + 'đ';
const TYPE_LABELS = {
    normal:'Ghế thường', vip:'Ghế VIP', sweetbox:'Sweetbox',
    couple:'Ghế Couple', premium:'Ghế Cao cấp',
};

const API_BASE = "http://localhost:8080/api";

// ============================================================
// FETCH DATA FROM DATABASE
// ============================================================
function getAuthUser() {
    const userStr = localStorage.getItem('user');
    if (!userStr || userStr === "undefined") return null;
    try {
        return JSON.parse(userStr);
    } catch (e) {
        return null;
    }
}

/**
 * Lấy thông tin suất chiếu và phim từ Backend để hiển thị trên trang thanh toán.
 */
async function initBookingInfoFromDB() {
    const showtimeId = sessionStorage.getItem('selectedShowtimeId');
    const userStr = localStorage.getItem('user');

    // 1. Kiểm tra ID suất chiếu (Bắt buộc)
    if (!showtimeId) {
        console.error("❌ Thiếu selectedShowtimeId trong sessionStorage.");
        const titleEl = document.getElementById('pay-title');
        if (titleEl) titleEl.textContent = "Không tìm thấy thông tin suất chiếu";
        return;
    }

    // 2. Parse User và Token an toàn
    let user = null;
    try {
        user = (userStr && userStr !== "undefined") ? JSON.parse(userStr) : null;
    } catch (e) {
        console.error("❌ Lỗi dữ liệu người dùng:", e);
    }

    // 3. Xây dựng Headers thông minh
    const headers = { 'Content-Type': 'application/json' };

    // CHỈ thêm Authorization nếu token thực sự tồn tại và hợp lệ
    const token = user?.token;
    if (token && token !== "null" && token !== "undefined" && token.length > 10) {
        headers['Authorization'] = `Bearer ${token}`;
    }

    try {
        // 4. Thực hiện Fetch
        let response = await fetch(`${API_BASE}/showtimes/${showtimeId}`, {
            method: 'GET',
            headers: headers
        });

        // 5. Xử lý fallback cho lỗi 403 (Phòng trường hợp Token lỗi khiến Security chặn)
        if (response.status === 403) {
            console.warn("🔄 Token không hợp lệ hoặc bị chặn. Đang thử lấy dữ liệu công khai...");
            response = await fetch(`${API_BASE}/showtimes/${showtimeId}`);
        }

        if (!response.ok) {
            throw new Error(`Server trả về lỗi: ${response.status}`);
        }

        const data = await response.json();
        console.log("✅ Dữ liệu suất chiếu hợp lệ:", data);

        // Gọi hàm cập nhật giao diện (Đảm bảo hàm này đã được định nghĩa)
        if (typeof updateMovieUI === 'function') {
            updateMovieUI(data);
        }

    } catch (error) {
        console.error("❌ Lỗi initBookingInfoFromDB:", error.message);
        const titleEl = document.getElementById('pay-title');
        if (titleEl) titleEl.textContent = "Lỗi kết nối máy chủ";
    }
}
// Gọi hàm khi trang load xong
document.addEventListener('DOMContentLoaded', initBookingInfoFromDB);

// ============================================================
// FETCH DATA
// ============================================================

async function fetchProducts() {
    try {
        const response = await fetch(`${API_BASE}/products/all`, {
            method: 'GET',
            headers: { 'Content-Type': 'application/json' }
        });

        if (!response.ok) throw new Error(`Lỗi hệ thống (${response.status})`);

        dbCombos = await response.json();
        console.log("✅ Dữ liệu sản phẩm nhận về:", dbCombos);

        if (dbCombos && dbCombos.length > 0) {
            buildCombos();
        }
    } catch (error) {
        console.error("❌ Lỗi hiển thị sản phẩm:", error.message);
    }
}
// 2. Kiểm tra mã giảm giá từ DB (Bảng discount)
async function applyDiscountFromDB() {
    const code = document.getElementById('discount-input').value.trim();
    try {
        const response = await fetch(`${API_BASE}/discounts/check?code=${code}`);
        if (!response.ok) throw new Error("Mã không hợp lệ");

        const discountData = await response.json();
        // Cập nhật appliedDiscount với dữ liệu thực từ DB
        appliedDiscount = {
            id: discountData.discountId,
            label: discountData.discountCode,
            amount: calculateAmount(discountData)
        };
        renderOrder();
    } catch (err) {
        showMsg(document.getElementById('discount-msg'), "❌ Mã không tồn tại", "error");
    }
}
// ============================================================
// SYNCHRONIZE WITH BACKEND (Tạo hóa đơn thực)
// ============================================================

// payment.js
async function createInvoice() {
    // 1. Lấy đúng Token từ đối tượng user
    const userStr = localStorage.getItem('user');
    const user = userStr ? JSON.parse(userStr) : null;
    const token = user ? user.token : null;

    if (!token) {
        alert("Phiên đăng nhập hết hạn, vui lòng đăng nhập lại!");
        return;
    }

    // 2. Chuẩn bị dữ liệu theo đúng BookingRequest
    const invoiceData = {
        userId: user.userId,
        showtimeSeatIds: selectedSeats.map(s => s.dbId),
        products: addedCombos.map(c => ({
            productId: c.id,
            quantity: c.qty
        }))
    };

    try {
        const response = await fetch(`${API_BASE}/invoices/create`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${token}` // Gửi token chính xác
            },
            body: JSON.stringify(invoiceData)
        });

        // 3. Kiểm tra phản hồi trước khi parse JSON để tránh lỗi "Unexpected end"
        if (!response.ok) {
            if (response.status === 403) {
                throw new Error("Bạn không có quyền thực hiện giao dịch này (403).");
            }
            throw new Error(`Lỗi hệ thống: ${response.status}`);
        }

        const result = await response.json();
        invoiceId = result.invoiceId; // Lưu UUID hóa đơn để dùng tiếp
        console.log("✅ Hóa đơn đã tạo:", invoiceId);

    } catch (err) {
        console.error("❌ Lỗi createInvoice:", err.message);
        alert(err.message);
        throw err; // Ngăn không cho mở Modal QR nếu lỗi
    }
}

async function syncCombos(id) {
    const user = JSON.parse(localStorage.getItem('user'));
    for (let item of addedCombos) {
        await fetch(`${API_BASE}/invoices/${id}/items`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${user.token}` // Thêm Token
            },
            body: JSON.stringify({
                productId: item.id,
                quantity: item.qty
            })
        });
    }
}
// ============================================================
// PAYMENT CONFIRMATION
// ============================================================
// payment.js
document.getElementById('qr-confirm').addEventListener('click', async () => {
    try {
        // Khớp URL với BookingController: /api/invoices/confirm-payment
        const response = await fetch(`${API_BASE}/invoices/confirm-payment`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${JSON.parse(localStorage.getItem('user')).token}`
            },
            body: JSON.stringify({
                invoiceId: invoiceId, // UUID nhận được từ createInvoice
                transactionId: "TXN" + Date.now(),
                method: selectedMethod
            })
        });

        if (response.ok) {
            showSuccess();
        } else {
            alert("Xác nhận thanh toán thất bại!");
        }
    } catch (error) {
        console.error("❌ Lỗi confirmPayment:", error);
        alert("Thanh toán thất bại, vui lòng thử lại!");
    }
});

// ============================================================
// INIT BOOKING INFO
// ============================================================
function initBookingInfo() {
    // 1. Lấy dữ liệu ghế từ session
    const rawSeats = sessionStorage.getItem('selectedSeats');
    if (rawSeats) {
        selectedSeats = JSON.parse(rawSeats);
    }

    // 2. Lấy thông tin phim từ session (Đã lưu từ trang seat.js)
    const movieData = JSON.parse(sessionStorage.getItem('selectedMovie'));

    if (movieData) {
        // Gán dữ liệu vào HTML (Sử dụng ID trong payment.html)
        document.getElementById('pay-poster').src   = movieData.poster;
        document.getElementById('pay-title').textContent  = movieData.title;
        document.getElementById('pay-date').textContent   = movieData.date;
        document.getElementById('pay-time').textContent   = movieData.time;
        document.getElementById('pay-cinema').textContent = movieData.cinema;
        document.getElementById('pay-room').textContent   = movieData.room;
        document.getElementById('pay-age').textContent    = movieData.age;

        const tagsEl = document.getElementById('pay-tags');
        if (tagsEl && movieData.tags) {
            tagsEl.innerHTML = movieData.tags.map(t => `<span class="mic-tag">${t}</span>`).join('');
        }
    }
}
// Lưu trạng thái combo hiện tại vào sessionStorage
function saveCombosToSession() {
    sessionStorage.setItem('addedCombos', JSON.stringify(addedCombos));
}

// Khôi phục combo từ sessionStorage khi load trang
function loadCombosFromSession() {
    const saved = sessionStorage.getItem('addedCombos');
    if (saved) {
        addedCombos = JSON.parse(saved);
    }
}
// ============================================================
// ORDER SUMMARY
// ============================================================
function renderOrder() {
    // Seats
    const seatsEl = document.getElementById('order-seats');
    seatsEl.innerHTML = selectedSeats.map(s => `
    <div class="order-row">
      <span class="or-name">Ghế ${s.id} (${TYPE_LABELS[s.type] || s.type})</span>
      <span class="or-price">${fmt(s.price)}</span>
    </div>`).join('');

    // Combos
    const comboSec = document.getElementById('order-combo-section');
    const combosEl = document.getElementById('order-combos');
    if (addedCombos.length) {
        comboSec.style.display = 'block';
        combosEl.innerHTML = addedCombos.map(c => `
      <div class="order-row">
        <span class="or-name">${c.name} × ${c.qty}</span>
        <span class="or-price">${fmt(c.price * c.qty)}</span>
        <span class="or-remove" data-id="${c.id}" title="Xóa"><i class="fas fa-times"></i></span>
      </div>`).join('');
        combosEl.querySelectorAll('.or-remove').forEach(btn => {
            btn.addEventListener('click', () => {
                addedCombos = addedCombos.filter(c => c.id != btn.dataset.id);
                saveCombosToSession();
                renderOrder();
            });
        });
    } else {
        comboSec.style.display = 'none';
    }

    // Discounts
    const discSec = document.getElementById('order-discount-section');
    const discEl  = document.getElementById('order-discounts');
    const discRows = [];
    if (appliedDiscount) {
        discRows.push(`<div class="order-row">
      <span class="or-name" style="color:#22c55e"><i class="fas fa-tag"></i> ${appliedDiscount.label}</span>
      <span class="or-price" style="color:#22c55e">-${fmt(appliedDiscount.amount)}</span>
      <span class="or-remove" id="remove-discount"><i class="fas fa-times"></i></span>
    </div>`);
    }
    if (appliedCoin > 0) {
        discRows.push(`<div class="order-row">
      <span class="or-name" style="color:var(--gold)"><i class="fas fa-coins"></i> Coin đã dùng</span>
      <span class="or-price" style="color:var(--gold)">-${fmt(appliedCoin)}</span>
      <span class="or-remove" id="remove-coin"><i class="fas fa-times"></i></span>
    </div>`);
    }
    if (discRows.length) {
        discSec.style.display = 'block';
        discEl.innerHTML = discRows.join('');
        discEl.querySelector('#remove-discount')?.addEventListener('click', () => {
            appliedDiscount = null;
            document.getElementById('discount-msg').textContent = '';
            document.getElementById('discount-input').value = '';
            renderOrder();
        });
        discEl.querySelector('#remove-coin')?.addEventListener('click', () => {
            appliedCoin = 0;
            document.getElementById('coin-msg').textContent = '';
            document.getElementById('coin-input').value = '';
            renderOrder();
        });
    } else {
        discSec.style.display = 'none';
    }

    // Total
    const seatTotal  = selectedSeats.reduce((s, x) => s + x.price, 0);
    const comboTotal = addedCombos.reduce((s, c) => s + c.price * c.qty, 0);
    const discTotal  = (appliedDiscount?.amount || 0) + appliedCoin;
    const total = Math.max(0, seatTotal + comboTotal - discTotal);
    document.getElementById('order-total').textContent = fmt(total);
}

function getTotal() {
    const seatTotal  = selectedSeats.reduce((s, x) => s + x.price, 0);
    const comboTotal = addedCombos.reduce((s, c) => s + c.price * c.qty, 0);
    const discTotal  = (appliedDiscount?.amount || 0) + appliedCoin;
    return Math.max(0, seatTotal + comboTotal - discTotal);
}

// ============================================================
// COMBO SLIDER
// ============================================================
const VISIBLE = 4;

// ============================================================
// UI RENDERING
// ============================================================

function buildCombos() {
    const track = document.getElementById('combo-track');
    if (!track) return;

    // Kiểm tra nếu chưa có dữ liệu từ API
    if (!dbCombos || dbCombos.length === 0) {
        track.innerHTML = '<p class="no-data">Đang tải danh sách bắp nước...</p>';
        return;
    }

    // 1. Render danh sách sản phẩm sử dụng cấu trúc mới
    track.innerHTML = dbCombos.map(c => `
        <div class="combo-card" data-id="${c.id}">
            <div class="combo-img">
                <img src="${c.imageUrl}" alt="${c.name}" 
                     onerror="this.src='https://images.unsplash.com/photo-1585647347483-22b66260dfff?w=200&q=80'">
            </div>
            <div class="combo-body">
                <div class="combo-name">${c.name}</div>
<!--                <div class="combo-type" style="font-size: 0.8rem; color: #888;">${c.typeName || ''}</div>-->
                <div class="combo-price">${fmt(c.price)}</div>
            </div>
        </div>`).join('');

    // 2. Thiết lập sự kiện click theo cách viết mới (addEventListener)
    track.querySelectorAll('.combo-card').forEach(card => {
        card.addEventListener('click', () => {
            // Xóa class selected cũ
            track.querySelectorAll('.combo-card').forEach(c => c.classList.remove('selected'));
            // Thêm class selected cho thẻ vừa chọn
            card.classList.add('selected');

            // Tìm sản phẩm đã chọn từ mảng dữ liệu DB
            const id = card.dataset.id;
            selectedCombo = dbCombos.find(item => item.id == id);

            comboQty = 1;
            showComboDetail(); // Hiển thị bảng chi tiết bên dưới
        });
    });

    // 3. Cập nhật trạng thái nút điều hướng (nếu có dùng slider)
    if (typeof updateComboNav === "function") {
        updateComboNav();
    }
}

function updateComboNav() {
    const track = document.getElementById('combo-track');
    const cardW = track.querySelector('.combo-card')?.offsetWidth || 0;
    const shift = comboOffset * (cardW + 14);
    track.style.transform = `translateX(-${shift}px)`;

    document.getElementById('combo-prev').disabled = comboOffset === 0;
    document.getElementById('combo-next').disabled = comboOffset >= dbCombos.length - 4;
}

document.getElementById('combo-next').addEventListener('click', () => {
    if (comboOffset < dbCombos.length - 4) {
        comboOffset++;
        updateComboNav();
    }
});
document.getElementById('combo-prev').addEventListener('click', () => {
    if (comboOffset > 0) {
        comboOffset--;
        updateComboNav();
    }
});


function showComboDetail() {
    if (!selectedCombo) return;
    const det = document.getElementById('combo-detail');
    det.style.display = 'flex';

    const imgEl = document.getElementById('cd-img');
    if (imgEl) {
        imgEl.src = selectedCombo.imageUrl || '../assets/images/default-combo.png';
    }

    document.getElementById('cd-name').textContent  = selectedCombo.name;
    document.getElementById('cd-desc').textContent  = selectedCombo.description || selectedCombo.typeName || 'Sản phẩm chất lượng';
    document.getElementById('cd-price').textContent = fmt(selectedCombo.price) + ' / phần';
    document.getElementById('cd-qty').textContent   = comboQty;
}

document.getElementById('cd-minus').addEventListener('click', () => {
    if (comboQty > 1) { comboQty--; document.getElementById('cd-qty').textContent = comboQty; }
});
document.getElementById('cd-plus').addEventListener('click', () => {
    comboQty++; document.getElementById('cd-qty').textContent = comboQty;
});
document.getElementById('cd-add').addEventListener('click', () => {
    if (!selectedCombo) return;
    const existing = addedCombos.find(c => c.id === selectedCombo.id);
    if (existing) {
        existing.qty += comboQty;
    } else {
        addedCombos.push({ ...selectedCombo, qty: comboQty });
    }
    saveCombosToSession();
    renderOrder();
    // Flash button
    const btn = document.getElementById('cd-add');
    btn.style.background = '#16a34a';
    btn.innerHTML = '<i class="fas fa-check"></i> Đã thêm!';
    setTimeout(() => {
        btn.style.background = '';
        btn.innerHTML = '<i class="fas fa-plus-circle"></i> Thêm vào đơn';
    }, 1500);
});

// ============================================================
// DISCOUNT CODE
// ============================================================
document.getElementById('toggle-discount').addEventListener('click', () => {
    const body  = document.getElementById('body-discount');
    const arrow = document.getElementById('arrow-discount');
    const open  = body.style.display !== 'none';
    body.style.display = open ? 'none' : 'block';
    arrow.classList.toggle('open', !open);
});
document.getElementById('discount-apply').addEventListener('click', applyDiscountFromDB);
document.getElementById('discount-input').addEventListener('keydown', e => { if (e.key === 'Enter') applyDiscount(); });

document.querySelectorAll('.code-hint').forEach(hint => {
    hint.addEventListener('click', () => {
        document.getElementById('discount-input').value = hint.dataset.code;
    });
});

function applyDiscount() {
    const code = document.getElementById('discount-input').value.trim().toUpperCase();
    const msg  = document.getElementById('discount-msg');
    const inp  = document.getElementById('discount-input');

    if (!code) { showMsg(msg, 'Vui lòng nhập mã giảm giá.', 'error'); return; }
    const def = DISCOUNT_CODES[code];
    if (!def) {
        showMsg(msg, '❌ Mã không tồn tại hoặc đã hết hạn.', 'error');
        inp.classList.add('error');
        return;
    }
    inp.classList.remove('error');

    const seatTotal = selectedSeats.reduce((s, x) => s + x.price, 0);
    const comboTotal = addedCombos.reduce((s, c) => s + c.price * c.qty, 0);
    const base = seatTotal + comboTotal;
    const amount = def.type === 'percent' ? Math.round(base * def.value / 100) : def.value;

    appliedDiscount = { label: def.label, amount };
    showMsg(msg, `✅ Áp dụng thành công! Giảm ${fmt(amount)}`, 'success');
    renderOrder();
}

// ============================================================
// COIN
// ============================================================
document.getElementById('toggle-coin').addEventListener('click', () => {
    const body  = document.getElementById('body-coin');
    const arrow = document.getElementById('arrow-coin');
    const open  = body.style.display !== 'none';
    body.style.display = open ? 'none' : 'block';
    arrow.classList.toggle('open', !open);
});

document.getElementById('coin-apply').addEventListener('click', applyCoin);

let USER_COINS = 500;
function applyCoin() {
    const inp  = document.getElementById('coin-input');
    const msg  = document.getElementById('coin-msg');
    const val  = parseInt(inp.value) || 0;

    if (val <= 0) { showMsg(msg, 'Vui lòng nhập số coin hợp lệ.', 'error'); return; }
    if (val > USER_COINS) { // Đảm bảo USER_COINS đã được định nghĩa
        inp.classList.add('error');
        showMsg(msg, `❌ Không đủ coin. Bạn chỉ có ${USER_COINS} coin.`, 'error');
        return;
    }
    inp.classList.remove('error');
    appliedCoin = val * 100; // 1 coin = 100đ
    showMsg(msg, `✅ Đã dùng ${val} coin = ${fmt(appliedCoin)}`, 'success');
    renderOrder();
}

function showMsg(el, text, type) {
    el.textContent = text;
    el.className = `dc-msg ${type}`;
}

// ============================================================
// PAYMENT METHODS
// ============================================================
document.querySelectorAll('.pay-method-btn').forEach(btn => {
    btn.addEventListener('click', () => {
        document.querySelectorAll('.pay-method-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        selectedMethod = btn.dataset.method;
    });
});

// ============================================================
// TERMS CHECKBOX
// ============================================================
const termsCheck = document.getElementById('terms-check');

// ============================================================
// PAY BUTTON
// ============================================================
// payment.js
document.getElementById('btn-pay').addEventListener('click', async () => {
    // 1. Tạo hóa đơn tạm ở Backend trước
    const invoice = await createInvoice();

    // 2. Gọi API lấy link thanh toán VNPay
    const res = await fetch(`${API_BASE}/invoices/${invoice.invoiceId}/payment-url`, {
        headers: { 'Authorization': `Bearer ${token}` }
    });

    const paymentUrl = await res.text();

    // 3. Chuyển hướng người dùng sang trang của VNPay
    window.location.href = paymentUrl;
});

// ============================================================
// QR MODAL
// ============================================================
const METHODS_LABEL = {
    qr: 'QR PAY', momo: 'MOMO', zalopay: 'ZALO PAY', vnpay: 'VN PAY',
};

function openQRModal() {
    const modal = document.getElementById('qr-modal');
    document.getElementById('qr-method-badge').textContent = METHODS_LABEL[selectedMethod] || 'QR PAY';
    document.getElementById('qr-amount-val').textContent   = fmt(getTotal());
    document.getElementById('qr-expire-msg').style.display = 'none';
    document.getElementById('qr-confirm').disabled = false;
    modal.classList.add('open');
    startCountdown();
}

document.getElementById('qr-close').addEventListener('click', closeQRModal);
document.getElementById('qr-modal').addEventListener('click', e => {
    if (e.target === document.getElementById('qr-modal')) closeQRModal();
});

function closeQRModal() {
    document.getElementById('qr-modal').classList.remove('open');
    clearInterval(countdownTimer);
}

document.getElementById('qr-change').addEventListener('click', closeQRModal);

document.getElementById('qr-confirm').addEventListener('click', () => {
    clearInterval(countdownTimer);
    document.getElementById('qr-modal').classList.remove('open');
    showSuccess();
});

// ============================================================
// COUNTDOWN
// ============================================================
function startCountdown() {
    let secs = 5 * 60; // 5 minutes
    const display = document.getElementById('countdown');
    const bar     = document.getElementById('countdown-bar');
    const expire  = document.getElementById('qr-expire-msg');
    const confirm = document.getElementById('qr-confirm');
    const total   = secs;

    clearInterval(countdownTimer);
    display.classList.remove('urgent');
    bar.style.background = 'var(--red)';
    bar.style.width      = '100%';

    countdownTimer = setInterval(() => {
        secs--;
        const m = String(Math.floor(secs / 60)).padStart(2,'0');
        const s = String(secs % 60).padStart(2,'0');
        display.textContent = `${m}:${s}`;
        bar.style.width = `${(secs / total) * 100}%`;

        if (secs <= 60) {
            display.classList.add('urgent');
            bar.style.background = '#ff5252';
        }

        if (secs <= 0) {
            clearInterval(countdownTimer);
            display.textContent = '00:00';
            expire.style.display = 'flex';
            expire.style.alignItems = 'center';
            expire.style.gap = '6px';
            expire.style.justifyContent = 'center';
            confirm.disabled = true;
            confirm.style.opacity = '.4';
        }
    }, 1000);
}

// ============================================================
// SUCCESS
// ============================================================
function showSuccess() {
    const ov   = document.getElementById('success-overlay');
    const fill = document.getElementById('success-fill');
    ov.classList.add('show');
    requestAnimationFrame(() => { fill.style.width = '100%'; });
    setTimeout(() => { window.location.href = 'index.html'; }, 3200);
}

function getCurrentUserId() {
    const userStr = localStorage.getItem('user');
    if (userStr) {
        return JSON.parse(userStr).userId;
    }
    return null;
}

// Tính số tiền giảm dựa trên loại discount trong DB
function calculateAmount(discountData) {
    const seatTotal = selectedSeats.reduce((s, x) => s + x.price, 0);
    const comboTotal = addedCombos.reduce((s, c) => s + c.price * c.qty, 0);
    const base = seatTotal + comboTotal;

    if (discountData.type === 'PERCENT') {
        return Math.round(base * discountData.value / 100);
    }
    return discountData.value; // FLAT amount
}

// Đồng bộ ghế lên DB (Bước 2 trong createInvoice)
async function syncSeats(id) {
    const user = JSON.parse(localStorage.getItem('user'));
    for (let seat of selectedSeats) {
        await fetch(`${API_BASE}/invoices/${id}/seats`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${user.token}`
            },
            // Sử dụng .dbId vì trang seat.js đã map showtimeSeatId sang dbId
            body: JSON.stringify({ showtimeSeatId: seat.dbId })
        });
    }
}
// ============================================================
// INIT
// ============================================================
document.addEventListener('DOMContentLoaded', async () => {
    loadCombosFromSession();
    initBookingInfo(); // Dữ liệu từ session
    renderOrder();     // Vẽ giỏ hàng ban đầu
    await fetchProducts(); // Lấy bắp nước
    await initBookingInfoFromDB(); // Lấy thông tin phim từ DB
});