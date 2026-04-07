// ============================================================
// booking.js — CineMax Booking Page
// Features: date picker, city/cinema selection, movie showtimes,
//           room types, seat availability, skeleton loading
// ============================================================
// STATE — Lưu trữ dữ liệu tải từ API
// ============================================================
const state = {
    cities: [],
    cinemas: [],
    moviesWithShowtimes: [], // Thay thế DB.movies
    selectedDate:   null,
    selectedCity:   null,
    selectedCinema: null,
    selectedTime:   null,
};

// ============================================================
// API CALLS
// ============================================================
const API_BASE = "http://localhost:8080/api";

async function fetchCities() {
    try {
        const res = await fetch(`${API_BASE}/cities`);

        // Kiểm tra nếu response không thành công (ví dụ lỗi 403)
        if (!res.ok) {
            console.error(`Lỗi HTTP: ${res.status}`);
            return;
        }

        state.cities = await res.json();
        buildCities();
    } catch (err) {
        console.error("Lỗi tải thành phố:", err);
    }
}

async function fetchCinemas(cityName) {
    try {
        const res = await fetch(`${API_BASE}/cinemas?city=${cityName}`);
        state.cinemas = await res.json();
        renderCinemas(state.cinemas);
    } catch (err) { console.error("Lỗi tải rạp:", err); }
}

async function fetchShowtimes() {
    // 1. Kiểm tra điều kiện trước khi gọi API
    if (!state.selectedCinema || !state.selectedDate) return;

    showShowtimesSkeleton();

    try {
        // 2. Sử dụng cinemasId (khớp với Java Entity) và encode date
        const cinemaId = state.selectedCinema.cinemasId;
        const date = state.selectedDate;
        const url = `${API_BASE}/showtimes?cinemaId=${cinemaId}&date=${date}`;

        const res = await fetch(url);

        // 3. Xử lý lỗi HTTP (đặc biệt là 403 Forbidden hoặc 500)
        if (!res.ok) {
            if (res.status === 403) {
                throw new Error("Lỗi 403: Bạn chưa mở quyền permitAll cho /api/showtimes/** trong SecurityConfig.java");
            }
            throw new Error(`Lỗi server: ${res.status}`);
        }

        // 4. Chỉ parse JSON khi phản hồi thành công
        const data = await res.json();
        state.moviesWithShowtimes = data;

        setTimeout(renderShowtimes, 300);
    } catch (err) {
        console.error("Lỗi tải suất chiếu:", err.message);
        document.getElementById('showtime-list').innerHTML =
            `<p style="color:red; text-align:center; padding:20px;">${err.message}</p>`;
    }
}

// ============================================================
// DATE STRIP
// ============================================================
// ============================================================
// DATE STRIP — 7 ngày dàn đều, prev/next để dịch chuyển
// ============================================================
let dateOffset = 0; // số ngày offset so với hôm nay

function buildDates() {
    const strip    = document.getElementById('date-strip');
    const prevBtn  = document.getElementById('date-prev');
    const nextBtn  = document.getElementById('date-next');
    const days     = ['CN','T2','T3','T4','T5','T6','T7'];
    const today    = new Date(); today.setHours(0,0,0,0);

    function render() {
        strip.innerHTML = '';

        // Prev disabled nếu đang ở ngày hiện tại (offset = 0)
        prevBtn.disabled = dateOffset === 0;

        for (let i = 0; i < 7; i++) {
            const d   = new Date(today);
            d.setDate(today.getDate() + dateOffset + i);
            const dow   = days[d.getDay()];
            const day   = String(d.getDate()).padStart(2,'0');
            const mon   = String(d.getMonth()+1).padStart(2,'0');
            const dateKey = `${d.getFullYear()}-${mon}-${day}`;
            const isToday = dateOffset === 0 && i === 0;
            const isSelected = state.selectedDate === dateKey;

            const btn = document.createElement('button');
            btn.className = 'date-btn' + (isSelected || (!state.selectedDate && isToday) ? ' active' : '');
            btn.dataset.date = dateKey;
            btn.innerHTML = `
        <span class="d-dow">${isToday ? 'Hôm nay' : dow}</span>
        <span class="d-num">${day}</span>
        <span class="d-month">/${mon}</span>`;

            btn.addEventListener('click', () => {
                strip.querySelectorAll('.date-btn').forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
                state.selectedDate = dateKey;
                if (state.selectedCinema) renderShowtimes();
            });

            strip.appendChild(btn);

            // Set default selected date on first render
            if (!state.selectedDate && isToday) state.selectedDate = dateKey;
        }
    }

    prevBtn.addEventListener('click', () => {
        if (dateOffset === 0) return;
        dateOffset = Math.max(0, dateOffset - 7);
        state.selectedDate = null;
        render();
        if (state.selectedCinema) renderShowtimes();
    });

    nextBtn.addEventListener('click', () => {
        dateOffset += 7;
        state.selectedDate = null;
        render();
        if (state.selectedCinema) renderShowtimes();
    });

    render();
}

// ============================================================
// CITY LIST
// ============================================================
function buildCities() {
    const ul = document.getElementById('city-list');
    // state.cities bây giờ là mảng từ API (ví dụ: ["Hà Nội", "Hồ Chí Minh"])
    ul.innerHTML = state.cities.map(c => `
    <li class="city-item" data-city="${c}">
      <i class="fas fa-circle-dot"></i> ${c}
    </li>`).join('');

    ul.querySelectorAll('.city-item').forEach(li => {
        li.addEventListener('click', () => {
            ul.querySelectorAll('.city-item').forEach(l => l.classList.remove('active'));
            li.classList.add('active');
            state.selectedCity = li.dataset.city;
            state.selectedCinema = null;
            fetchCinemas(state.selectedCity); // Gọi API lấy rạp
            hideShowtimes();
        });
    });
}

// ============================================================
// CINEMA LIST
// ============================================================
function renderCinemas(cinemas) {
    const ul = document.getElementById('cinema-list');
    ul.innerHTML = cinemas.map(c => `
    <li class="cinema-item" data-id="${c.cinemasId}"> <div class="cinema-check"><i class="fas fa-check"></i></div>
      <div class="cinema-info">
        <div class="cinema-name">${c.cinemaName}</div> <div class="cinema-addr">
            <i class="fas fa-location-dot" style="color:var(--red);font-size:.65rem"></i> 
            ${c.address}
        </div>
      </div>
    </li>`).join('');

    // Quan trọng: Gán sự kiện click để lấy đúng ID số gửi lên API
    ul.querySelectorAll('.cinema-item').forEach(li => {
        li.addEventListener('click', () => {
            ul.querySelectorAll('.cinema-item').forEach(l => l.classList.remove('active'));
            li.classList.add('active');
            state.selectedCinema = cinemas.find(c => c.cinemasId == li.dataset.id);
            fetchShowtimes(); // Gọi API lấy phim theo ID rạp (1, 2, 3...)
        });
    });
}

// ============================================================
// SHOWTIMES SECTION
// ============================================================
function hideShowtimes() {
    document.getElementById('showtime-section').style.display = 'none';
}

function showShowtimesSkeleton() {
    const sec = document.getElementById('showtime-section');
    sec.style.display = 'block';
    updateInfoBar();
    document.getElementById('showtime-list').innerHTML =
        Array(3).fill(`
      <div class="skeleton-card">
        <div class="skeleton sk-poster"></div>
        <div class="sk-lines">
          <div class="skeleton sk-line w80"></div>
          <div class="skeleton sk-line w50"></div>
          <div class="skeleton sk-line w35"></div>
        </div>
      </div>`).join('');
    sec.scrollIntoView({ behavior: 'smooth', block: 'start' });
}

function updateInfoBar() {
    const bar = document.getElementById('showtime-info-bar');
    const d   = state.selectedDate;
    const dFmt = d ? d.split('-').reverse().join('/') : '—';

    // SỬA: Thay .name bằng .cinemaName để khớp với API Backend
    const cinemaName = state.selectedCinema?.cinemaName || '—';
    const cityName = state.selectedCity || '—';

    bar.innerHTML = `
    <i class="fas fa-map-marker-alt" style="color:var(--red)"></i>
    <strong>${cityName}</strong>
    <span class="sib-sep">|</span>
    <i class="fas fa-store" style="color:var(--red)"></i>
    <strong>${cinemaName}</strong> 
    <span class="sib-sep">|</span>
    <i class="fas fa-calendar" style="color:var(--red)"></i>
    <strong>${dFmt}</strong>`;
}

function renderShowtimes() {
    updateInfoBar();
    const list = document.getElementById('showtime-list');

    // 1. Kiểm tra nếu không có dữ liệu
    if (!state.moviesWithShowtimes || state.moviesWithShowtimes.length === 0) {
        list.innerHTML = `
            <div class="bk-empty">
                <i class="fas fa-film"></i>
                <h3>Không có suất chiếu nào</h3>
                <p>Vui lòng chọn rạp hoặc ngày khác.</p>
            </div>`;
        return;
    }

    // 2. Render danh sách phim
    list.innerHTML = state.moviesWithShowtimes.map((movie, idx) => {
        const delay = idx * 0.08;
        return `
        <div class="movie-showtime-card" style="animation-delay:${delay}s">
            <div class="msc-header">
                <img class="msc-poster" src="${movie.img}" alt="${movie.title}" 
                     onerror="this.src='https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=200&q=80'" />
                <div class="msc-info">
                    <div class="msc-title">${movie.title}</div>
                    <div class="msc-meta">
                        <span><i class="fas fa-clock"></i> ${movie.duration} phút</span>
                        <span><i class="fas fa-user-shield"></i> ${movie.age}</span>
                    </div>
                    <div class="msc-genre-tags">
                        ${(movie.genres || []).map(g => `<span class="msc-gtag">${g}</span>`).join('')}
                    </div>
                </div>
                <i class="fas fa-chevron-down msc-toggle open"></i>
            </div>
            <div class="msc-body">
                ${movie.typeGroups.map(group => renderFormatGroup(group, movie.id)).join('')}
            </div>
        </div>`;
    }).join('');

    // 3. Gán lại các sự kiện (Collapse & Click)
    attachShowtimeEvents();
}

/** * Render từng khối định dạng (IMAX, 2D, 4DX...)
 */
function renderFormatGroup(group, movieId) {
    const typeClass = { 'IMAX': 'imax', '4DX': 't4dx', '3D': 't3d', '2D': 't2d' }[group.formatName] || '';

    return `
        <div class="room-type-block">
            <div class="room-type-label ${typeClass}">
                <i class="fas fa-film"></i> ${group.formatName}
            </div>
            ${group.rooms.map(room => `
                <div class="room-row">
                    <div class="room-name">${room.roomName}</div>
                    <div class="showtimes-row">
                        ${room.times.map(t => {
        const isFull = t.seats <= 0;
        const isLow = t.seats > 0 && t.seats <= 10;
        const statusClass = isFull ? 'st-full' : (isLow ? 'st-low' : 'st-plenty');

        return `
                                <button class="st-btn ${isFull ? 'disabled' : ''}" 
                                    data-movie="${movieId}" 
                                    data-type="${group.formatName}"
                                    data-room="${room.roomName}" 
                                    data-time="${t.time}" 
                                    data-seats="${t.seats}"
                                    ${isFull ? 'disabled' : ''}>
                                    <span class="st-time">${t.time}</span>
                                    <span class="st-seats ${statusClass}">${isFull ? 'Hết vé' : t.seats + ' ghế'}</span>
                                </button>`;
    }).join('')}
                    </div>
                </div>
            `).join('')}
        </div>`;
}
// ============================================================
// TOAST — selected showtime notification
// ============================================================
function showToast() {
    let toast = document.getElementById('bk-toast');
    if (!toast) {
        toast = document.createElement('div');
        toast.id = 'bk-toast';
        // Giữ nguyên phần Object.assign(toast.style, ...) cũ của bạn ở đây
        Object.assign(toast.style, {
            position: 'fixed', bottom: '24px', left: '50%',
            transform: 'translateX(-50%)',
            background: '#222', color: '#fff',
            padding: '12px 24px', borderRadius: '12px',
            border: '1px solid rgba(229,9,20,.4)',
            fontSize: '.875rem', fontFamily: 'inherit',
            boxShadow: '0 8px 32px rgba(0,0,0,.5)',
            zIndex: '3000', transition: 'opacity .3s ease',
            display: 'flex', alignItems: 'center', gap: '10px',
        });
        document.body.appendChild(toast);
    }

    // LẤY DỮ LIỆU TỪ STATE (API) thay vì DB mock
    const { movieId, type, room, time, seats } = state.selectedTime;

    // Tìm phim trong danh sách đã tải từ API
    const movie = state.moviesWithShowtimes.find(m => m.id == movieId);

    if (movie) {
        toast.innerHTML = `
      <i class="fas fa-check-circle" style="color:#00c853"></i>
      <span>
        <strong>${movie.title}</strong> · ${type} · ${room} · <strong>${time}</strong> · ${seats} ghế còn
      </span>
      <a href="#" style="color:#E50914; font-weight:700; margin-left:8px; text-decoration:none">Tiếp tục →</a>`;

        toast.style.opacity = '1';
        toast.style.display = 'flex'; // Đảm bảo nó hiện ra

        clearTimeout(toast._hide);
        toast._hide = setTimeout(() => { toast.style.opacity = '0'; }, 5000);
    }
}

function attachShowtimeEvents() {
    const list = document.getElementById('showtime-list');

    // Sự kiện đóng/mở thẻ phim
    list.querySelectorAll('.msc-header').forEach(h => {
        h.onclick = () => {
            const body = h.nextElementSibling;
            const toggle = h.querySelector('.msc-toggle');
            const isOpen = body.style.display !== 'none';
            body.style.display = isOpen ? 'none' : 'block';
            toggle.classList.toggle('open', !isOpen);
        };
    });

    // Sự kiện chọn giờ chiếu
    list.querySelectorAll('.st-btn:not(.disabled)').forEach(btn => {
        btn.onclick = () => {
            const card = btn.closest('.movie-showtime-card');
            card.querySelectorAll('.st-btn').forEach(b => b.classList.remove('selected'));
            btn.classList.add('selected');

            state.selectedTime = {
                movieId: btn.dataset.movie,
                type: btn.dataset.type,
                room: btn.dataset.room,
                time: btn.dataset.time,
                seats: btn.dataset.seats,
            };
            showToast(); // Hàm toast bạn đã có sẵn
        };
    });
}

// ============================================================
// INIT
// ============================================================
document.addEventListener('DOMContentLoaded', () => {
    buildDates();     // Khởi tạo dải ngày (Client-side logic)
    fetchCities();    // Bắt đầu tải danh sách thành phố từ Database
    console.log('%c🎬 CineMax Booking API Mode Ready', 'color:#E50914;font-weight:bold');
});