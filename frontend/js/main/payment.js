// ============================================================
// payment.js — CineMax Payment Page
// Features: seat summary, combo slider, discount/coin, payment
//           method, QR modal, countdown, success redirect
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

// Hàm khởi tạo thông tin từ Database
async function initBookingInfoFromDB() {
    const showtimeId = sessionStorage.getItem('selectedShowtimeId');

    if (!showtimeId || showtimeId === "undefined") {
        console.error("❌ Không tìm thấy mã suất chiếu hợp lệ!");
        return;
    }

    try {
        const response = await fetch(`${API_BASE}/showtimes/${showtimeId}`);

        // KIỂM TRA PHẢN HỒI: Nếu lỗi 403, 404, 500 thì ném lỗi ngay, không JSON parse
        if (!response.ok) {
            throw new Error(`Lỗi hệ thống (${response.status}): Có thể do Spring Security chặn 403.`);
        }

        const data = await response.json();
        console.log("✅ Dữ liệu suất chiếu từ DB:", data);

        // Đổ dữ liệu vào HTML - Sử dụng toán tử ?. để tránh crash nếu data bị thiếu trường
        if (document.getElementById('pay-poster'))
            document.getElementById('pay-poster').src = data.movie?.posterUrl || '';

        if (document.getElementById('pay-title'))
            document.getElementById('pay-title').textContent = data.movie?.movieName || 'N/A';

        // Cập nhật các thông tin rạp, ngày, giờ
        document.getElementById('pay-cinema').textContent = data.cinemaName || 'CineMax';
        document.getElementById('pay-date').textContent   = data.showDate || '--/--/----';
        document.getElementById('pay-time').textContent   = data.startTime || '--:--';
        document.getElementById('pay-room').textContent   = data.roomName || 'Room A';

        const age = data.movie?.ageRating || '13';
        document.getElementById('pay-age').textContent    = age + "+";

        // Đổ các tag (Thể loại, định dạng)
        const tagsEl = document.getElementById('pay-tags');
        if (tagsEl) {
            tagsEl.innerHTML = `
                <span class="mic-tag">${data.movie?.genre || 'Phim'}</span>
                <span class="mic-tag age">T${age}</span>
                <span class="mic-tag type">${data.roomType || '2D'}</span>
            `;
        }

    } catch (error) {
        console.error("❌ Lỗi chi tiết tại initBookingInfoFromDB:", error.message);
        // Có thể hiển thị thông báo nhẹ cho user trên giao diện
    }
}

// Gọi hàm khi trang load xong
document.addEventListener('DOMContentLoaded', initBookingInfoFromDB);

// 1. Lấy danh sách Combo từ DB
async function fetchCombos() {
    try {
        const response = await fetch(`${API_BASE}/products/combos`);

        // Kiểm tra nếu không phải 200 OK thì dừng lại, không parse JSON
        if (!response.ok) {
            throw new Error(`Server trả về lỗi ${response.status}`);
        }

        dbCombos = await response.json();
        if (dbCombos && dbCombos.length > 0) {
            buildCombos();
        }
    } catch (error) {
        console.error("Lỗi lấy dữ liệu combo:", error.message);
        const track = document.getElementById('combo-track');
        if (track) track.innerHTML = `<p class="error-msg">Không thể tải bắp nước (Lỗi hệ thống)</p>`;
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

async function createInvoice() {
    // Bước 1: Tạo hóa đơn rỗng thông qua Procedure sp_invoice_create
    const response = await fetch(`${API_BASE}/invoices`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ userId: getCurrentUserId() })
    });
    const data = await response.json();
    invoiceId = data.invoiceId; // Đây là UUID từ DB

    // Bước 2: Lưu các ghế đã chọn vào bảng booking_seat
    await syncSeats(invoiceId);

    // Bước 3: Lưu combo vào bảng booking_products
    await syncCombos(invoiceId);
}
async function syncCombos(id) {
    for (let item of addedCombos) {
        await fetch(`${API_BASE}/invoices/${id}/items`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' }, // THÊM DÒNG NÀY
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
document.getElementById('qr-confirm').addEventListener('click', async () => {
    try {
        // Gọi Procedure sp_payment_success ở Backend
        const response = await fetch(`${API_BASE}/payments/confirm`, {
            method: 'POST',
            body: JSON.stringify({
                invoiceId: invoiceId,
                method: selectedMethod,
                transactionId: "TXN" + Date.now()
            })
        });

        if (response.ok) {
            showSuccess();
        }
    } catch (error) {
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

function buildCombos() {
    const track = document.getElementById('combo-track');
    if (!track) return;

    if (!dbCombos || dbCombos.length === 0) {
        track.innerHTML = '<p style="padding: 20px;">Không có sản phẩm nào.</p>';
        return;
    }

    track.innerHTML = dbCombos.map(c => `
    <div class="combo-card" data-id="${c.id}">
      <div class="combo-img-wrap" style="height: 120px; overflow: hidden; border-radius: 8px;">
        <img src="${c.imageUrl}" alt="${c.name}" 
             style="width: 100%; height: 100%; object-fit: cover;"
             onerror="this.src='https://images.unsplash.com/photo-1585647347483-22b66260dfff?w=200&q=80'">
      </div> 
      <div class="combo-body">
        <div class="combo-name" style="font-weight:600; margin-top:10px;">${c.name}</div>
        <div class="combo-price" style="color:var(--gold)">${fmt(c.price)}</div>
      </div>
    </div>`).join('');

    // Thiết lập sự kiện click
    track.querySelectorAll('.combo-card').forEach(card => {
        card.onclick = () => {
            track.querySelectorAll('.combo-card').forEach(c => c.classList.remove('selected'));
            card.classList.add('selected');
            const id = parseInt(card.dataset.id);
            selectedCombo = dbCombos.find(item => item.id === id);
            comboQty = 1;
            showComboDetail();
        };
    });
    updateComboNav();
}

function updateComboNav() {
    const track   = document.getElementById('combo-track');
    const cardW   = track.querySelector('.combo-card')?.offsetWidth || 0;
    const gap     = 14;
    const shift   = comboOffset * (cardW + gap);
    track.style.transform = `translateX(-${shift}px)`;

    document.getElementById('combo-prev').disabled = comboOffset === 0;
    // ĐỔI COMBOS THÀNH dbCombos
    document.getElementById('combo-next').disabled = comboOffset >= dbCombos.length - VISIBLE;
}
document.getElementById('combo-next').addEventListener('click', () => {
    if (comboOffset < dbCombos.length - VISIBLE) { // ĐỔI TẠI ĐÂY
        comboOffset++;
        updateComboNav();
    }
});

function showComboDetail() {
    if (!selectedCombo) return;
    const det = document.getElementById('combo-detail');
    det.style.display = 'flex';
    // Đổ ảnh sản phẩm từ Database
    const imgEl = document.getElementById('cd-img');
    if (imgEl) {
        imgEl.src = selectedCombo.imageUrl || '../assets/images/default-combo.png';
        imgEl.style.fontSize = 'initial'; // Reset font-size của emoji cũ
    }
    document.getElementById('cd-name').textContent  = selectedCombo.name;
    document.getElementById('cd-desc').textContent  = selectedCombo.typeName || 'Sản phẩm chất lượng';
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
document.getElementById('btn-pay').addEventListener('click', async () => {
    const warn = document.getElementById('pay-warn');
    if (!termsCheck.checked) {
        warn.innerHTML = '<i class="fas fa-exclamation-circle"></i> Bạn chưa đồng ý điều khoản.';
        return;
    }
    // Tạo hóa đơn thật trong DB trước khi hiện QR
    try {
        await createInvoice();
        openQRModal();
    } catch (err) {
        alert("Lỗi khởi tạo hóa đơn!");
    }
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

// Giả định lấy UserId từ token hoặc session
function getCurrentUserId() {
    const user = JSON.parse(localStorage.getItem('user'));
    return user ? user.userId : 1; // Trả về 1 nếu chưa login để test
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
    for (let seat of selectedSeats) {
        await fetch(`${API_BASE}/invoices/${id}/seats`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ showtimeSeatId: seat.dbId }) // Giả định ghế có dbId
        });
    }
}

// ============================================================
// INIT
// ============================================================
document.addEventListener('DOMContentLoaded', async () => {
    // 1. Hiện thông tin nhanh từ session
    initBookingInfo();
    renderOrder();
    try {
        // 2. Tải dữ liệu thật từ DB
        await initBookingInfoFromDB();
        await fetchCombos(); // Hàm này sẽ tự gọi buildCombos() bên trong
    } catch (err) {
        console.error("Lỗi khởi tạo dữ liệu:", err);
    }
});