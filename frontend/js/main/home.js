// ============================================================
// main/home.js — UI Logic Layer
// ============================================================
import { fetchHomeInitialData } from '../api/home.js';


function renderHeroSlider(movies) {
    const wrapper = document.getElementById('main-slider-wrapper');
    if (!wrapper || !movies || movies.length === 0) return;

    wrapper.innerHTML = movies.map((m, index) => `
        <div class="slide ${index === 0 ? 'active' : ''}">
            <div class="slide-bg" style="background-image:url('${m.posterLink}')"></div>
            <div class="container">
                <div class="slide-content">
                    <div class="slide-badge">
                        <i class="fas fa-fire"></i> ${m.status === 'showing' ? 'Đang chiếu' : 'Sắp chiếu'}
                    </div>
                    <h1 class="slide-title">${m.title.replace(':', ':<br>')}</h1>
                    <div class="slide-meta">
                        <span><i class="fas fa-star"></i> 9.0</span> 
                        <span><i class="fas fa-clock"></i> ${m.duration} phút</span>
                        <span><i class="fas fa-tag"></i> ${m.genreNames ? m.genreNames.join(' · ') : m.language}</span>
                    </div>
                    <p class="slide-desc">${m.description || 'Chưa có mô tả cho bộ phim này.'}</p>
                    <div class="slide-actions">
                        <a href="booking.html?id=${m.id}" class="btn-ticket">
                            <i class="fas fa-ticket-alt"></i> Đặt vé ngay
                        </a>
                        <a href="${m.trailerLink || '#'}" class="btn-trailer" target="_blank">
                            <span class="play-icon"><i class="fas fa-play"></i></span> 
                            Xem trailer
                        </a>
                    </div>
                </div>
            </div>
        </div>
    `).join('');

    // Quan trọng: Sau khi render xong mới khởi tạo lại hàm chạy Slide
    initSlider();
}
// ============================================================
// RENDER FUNCTIONS
// ============================================================
function renderNowShowing(movies) {
    const grid = document.getElementById('now-showing-grid');
    if (!grid || !movies) return;

    grid.innerHTML = movies.map((m, i) => `
    <div class="movie-card fade-in">
      <div class="poster-wrap">
        <img src="${m.posterLink}" alt="${m.title}" loading="lazy" 
          onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=400&q=80'" />
        <span class="rating-badge"><i class="fas fa-star"></i> ${m.star || 'N/A'}</span>
        <span class="age-badge">${m.ageRating || 'T13'}</span>
        <div class="poster-overlay">
          <button class="btn-book" 
                  style="background:rgba(229,9,20,.85);backdrop-filter:blur(8px)"
                  onclick="window.location.href='movie.html?id=${m.id}'">
            <i class="fas fa-ticket-alt"></i> Xem chi tiết
          </button>
        </div>
      </div>
      <div class="card-body">
        <div class="card-genre">
            ${(m.genreNames || []).join(' - ') || m.language}
        </div>
        <div class="card-title"><span class="marquee-inner">${m.title}</span></div>
        <div class="card-info">
          <span><i class="far fa-clock"></i> ${m.duration} phút</span>
        </div>
        <button class="btn-book btn-coming" onclick="window.location.href='booking.html?id=${m.id}'">Đặt vé ngay</button>
      </div>
    </div>
  `).join('');
}

function renderComingSoon(movies) {
    const grid = document.getElementById('coming-soon-grid');
    if (!grid || !movies) return;

    grid.innerHTML = movies.map((m, i) => `
    <div class="movie-card fade-in">
      <div class="poster-wrap">
        <img src="${m.posterLink}" alt="${m.title}" loading="lazy" 
             onerror="this.src='https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=400&q=80'"/>
        <span class="age-badge">${m.ageRating || 'T13'}</span>
        <div class="poster-overlay">
          <button class="btn-book" 
            style="background:rgba(255,215,0,.15);border:1px solid rgba(255,215,0,.5);color:var(--gold);backdrop-filter:blur(8px)"
            onclick="toggleFollowOverlay(this)">
            <i class="far fa-bookmark"></i> Theo dõi
          </button>
        </div>
      </div>
      <div class="card-body">
        <div class="card-title"><span class="marquee-inner">${m.title}</span></div>
        <div class="premiere-date">
          <i class="fas fa-calendar"></i> Khởi chiếu: ${m.releaseDate ? new Date(m.releaseDate).toLocaleDateString('vi-VN') : 'Sắp ra mắt'}
        </div>
        <button class="btn-book"
          style="background:rgba(255,215,0,.12);color:var(--gold);border:1px solid rgba(255,215,0,.3)"
          onclick="window.location.href='movie.html?id=${m.id}'">
          Xem chi tiết
        </button>
      </div>
    </div>
  `).join('');
}
// Biến toàn cục để giữ dữ liệu sau khi load
let homeData = null;

// --- 1. Hàm khởi tạo Dropdown thành phố ---
function initCustomDropdown(locations) {
    const trigger = document.getElementById('dropdown-trigger');
    const list = document.getElementById('dropdown-list');
    const selectedText = document.getElementById('dropdown-selected');

    if (!trigger || !list || !locations || locations.length === 0) return;

    // Render danh sách li
    list.innerHTML = locations.map((loc, index) => `
        <li class="dropdown-item ${index === 0 ? 'active' : ''}" data-value="${loc.provinceId}">
            ${loc.provinceName}
        </li>
    `).join('');

    // Hiển thị tên tỉnh đầu tiên
    selectedText.textContent = locations[0].provinceName;

    // Sự kiện mở/đóng menu
    trigger.onclick = (e) => {
        e.stopPropagation();
        list.classList.toggle('open');
    };

    // Sự kiện chọn tỉnh
    list.querySelectorAll('.dropdown-item').forEach(item => {
        item.onclick = () => {
            const provinceId = item.dataset.value;
            selectedText.textContent = item.textContent.trim();

            // Xóa active cũ, thêm active mới
            list.querySelectorAll('.dropdown-item').forEach(i => i.classList.remove('active'));
            item.classList.add('active');

            // Cập nhật danh sách rạp tương ứng
            const province = locations.find(p => p.provinceId == provinceId);
            if (province) renderCinemaTabs(province.cinemas);

            list.classList.remove('open');
        };
    });

    // Click ra ngoài thì đóng
    document.addEventListener('click', () => list.classList.remove('open'));
}

// --- 2. Hàm render danh sách Tab rạp (bên trái) ---
function renderCinemaTabs(cinemas) {
    const tabsContainer = document.getElementById('cinema-tabs');
    if (!tabsContainer) return;

    if (!cinemas || cinemas.length === 0) {
        tabsContainer.innerHTML = '<p>Không có rạp tại khu vực này.</p>';
        return;
    }

    tabsContainer.innerHTML = cinemas.map((c, index) => `
        <button class="cinema-tab ${index === 0 ? 'active' : ''}" data-id="${c.cinemasId}">
            ${c.cinemaName}
        </button>
    `).join('');

    // Hiển thị rạp đầu tiên mặc định
    renderCinemaDetail(cinemas[0]);

    // Gán sự kiện click cho từng tab rạp
    tabsContainer.querySelectorAll('.cinema-tab').forEach((tab, idx) => {
        tab.onclick = () => {
            tabsContainer.querySelectorAll('.cinema-tab').forEach(t => t.classList.remove('active'));
            tab.classList.add('active');
            renderCinemaDetail(cinemas[idx]);
        };
    });
}

// --- 3. Hàm render chi tiết rạp (bên phải) ---
function renderCinemaDetail(cinema) {
    const container = document.getElementById('cinema-panels');
    if (!container || !cinema) return;

    const tagsHtml = (cinema.screeningTypes || []).map(t => `<span class="feat-tag">${t}</span>`).join('');

    container.innerHTML = `
        <div class="cinema-info-panel active">
            <div class="cinema-hero-img" style="background-image:url('${cinema.imageUrl || 'https://via.placeholder.com/800x400'}')"></div>
            <div class="cinema-detail">
                <div class="cinema-name">${cinema.cinemaName}</div>
                <div class="cinema-address"><i class="fas fa-map-marker-alt"></i> ${cinema.address}</div>
                <div class="cinema-features">${tagsHtml}</div>
                <div class="cinema-actions">
                    <button class="btn-red" onclick="window.location.href='booking.html?cinemaId=${cinema.cinemasId}'">Mua vé tại đây</button>
                    <button class="btn-directions" onclick="window.open('${cinema.mapUrl}', '_blank')">
                        <i class="fas fa-directions"></i> Chỉ đường
                    </button>
                </div>
            </div>
        </div>
    `;
}

// --- 4. Luồng khởi chạy chính ---
document.addEventListener('DOMContentLoaded', async () => {
    try {
        // 1. Gọi API khởi tạo dữ liệu trang chủ
        const response = await fetch('http://localhost:8080/api/home/init');
        const homeData = await response.json();

        if (homeData) {
            // 2. Render các thành phần địa điểm và rạp
            if (homeData.locations && homeData.locations.length > 0) {
                initCustomDropdown(homeData.locations);
                // Mặc định hiển thị rạp của tỉnh thành đầu tiên trong danh sách
                renderCinemaTabs(homeData.locations[0].cinemas);
            }

            // 3. Render danh sách Phim Đang Chiếu (Now Showing)
            if (homeData.showingMovies) {
                renderNowShowing(homeData.showingMovies);
            }

            // 4. Render danh sách Phim Sắp Chiếu (Coming Soon)
            if (homeData.upcomingMovies) {
                renderComingSoon(homeData.upcomingMovies);
            }
        }
    } catch (err) {
        console.error("Lỗi load dữ liệu trang chủ:", err);
        // Hiển thị thông báo lỗi lên giao diện nếu cần
    }
});

// ============================================================
// UI INITIALIZATION FUNCTIONS (Đã xóa IIFE để gọi được hàm)
// ============================================================

function initSlider() {
    const slides = document.querySelectorAll('.slide');
    const dotsContainer = document.getElementById('dots');
    const nextBtn = document.getElementById('next-btn');
    const prevBtn = document.getElementById('prev-btn');

    if (!slides.length || !dotsContainer) return;

    // XÓA dữ liệu cũ trước khi khởi tạo lại (tránh nhân đôi dots)
    dotsContainer.innerHTML = '';
    // 2. Clone nút Next và Prev để xóa bỏ Event Listeners cũ (Tránh chạy nhanh gấp đôi)
    const newNextBtn = nextBtn.cloneNode(true);
    nextBtn.parentNode.replaceChild(newNextBtn, nextBtn);

    const newPrevBtn = prevBtn.cloneNode(true);
    prevBtn.parentNode.replaceChild(newPrevBtn, prevBtn);

    let current = 0;
    let interval;

    // Tạo dots mới dựa trên số lượng phim thật
    slides.forEach((_, i) => {
        const dot = document.createElement('button');
        dot.className = 'dot' + (i === 0 ? ' active' : '');
        dot.addEventListener('click', () => { goTo(i); resetInterval(); });
        dotsContainer.appendChild(dot);
    });

    const goTo = (n) => {
        if(!slides[current]) return; // Guard clause
        slides[current].classList.remove('active');
        current = (n + slides.length) % slides.length;
        slides[current].classList.add('active');
        document.querySelectorAll('.dot').forEach((d, i) => d.classList.toggle('active', i === current));
    };

    const next = () => goTo(current + 1);
    const prev = () => goTo(current - 1);

    const resetInterval = () => { clearInterval(interval); interval = setInterval(next, 5000); };

    newNextBtn.addEventListener('click', () => { next(); resetInterval(); });
    newPrevBtn.addEventListener('click', () => { prev(); resetInterval(); });

    resetInterval();
}

function initStickyHeader() {
    const header = document.getElementById('header');
    if (!header) return;
    window.addEventListener('scroll', () => {
        header.classList.toggle('scrolled', window.scrollY > 60);
    }, { passive: true });
}

function initMobileMenu() {
    const hamburger = document.getElementById('hamburger');
    const mobileNav = document.getElementById('mobile-nav');
    if (!hamburger || !mobileNav) return;

    hamburger.addEventListener('click', () => {
        hamburger.classList.toggle('open');
        mobileNav.classList.toggle('open');
    });
}

function initCinemaTabs() {
    const tabs = document.querySelectorAll('.cinema-tab');
    const panels = document.querySelectorAll('.cinema-info-panel');
    if (!tabs.length) return;

    tabs.forEach(tab => {
        tab.addEventListener('click', () => {
            const idx = parseInt(tab.dataset.cinema, 10);
            tabs.forEach(t => t.classList.remove('active'));
            panels.forEach(p => p.classList.remove('active'));
            tab.classList.add('active');
            if (panels[idx]) panels[idx].classList.add('active');
        });
    });
}

function initBackToTop() {
    const btn = document.getElementById('back-top');
    if (!btn) return;
    window.addEventListener('scroll', () => {
        btn.classList.toggle('show', window.scrollY > 400);
    }, { passive: true });
    btn.addEventListener('click', () => window.scrollTo({ top: 0, behavior: 'smooth' }));
}

function initSmoothScroll() {
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', e => {
            const selector = anchor.getAttribute('href');
            if (selector === '#') return;
            const target = document.querySelector(selector);
            if (target) {
                e.preventDefault();
                window.scrollTo({ top: target.offsetTop - 80, behavior: 'smooth' });
            }
        });
    });
}

function initScrollAnimations() {
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
                observer.unobserve(entry.target);
            }
        });
    }, { threshold: 0.12 });
    document.querySelectorAll('.fade-in').forEach(el => observer.observe(el));
}

function applyMarquee() {
    // Defer để browser tính layout xong sau khi inject HTML
    requestAnimationFrame(() => requestAnimationFrame(() => {

        document.querySelectorAll('.card-title, .card-genre').forEach(titleEl => {
            // Tránh khởi tạo 2 lần
            if (titleEl.dataset.marqueeReady) return;
            titleEl.dataset.marqueeReady = '1';

            let inner = titleEl.querySelector('.marquee-inner');

            // Nếu chưa có span.marquee-inner, tạo mới
            if (!inner) {
                const text = titleEl.textContent;
                titleEl.innerHTML = `<span class="marquee-inner">${text}</span>`;
                inner = titleEl.querySelector('.marquee-inner');
            }

            // Đo text thực tế vs box
            const textW = inner.scrollWidth;
            const boxW  = titleEl.clientWidth;
            const overflows = textW > boxW;

            // Nếu không tràn → không cần marquee, bỏ qua
            if (!overflows) return;

            // Nhân đôi nội dung để loop liền mạch (chỉ khi tràn)
            const original = inner.textContent;
            const gap      = '\u00A0'.repeat(10);
            inner.textContent = original + gap + original;
            titleEl.classList.add('marquee');

            // Tắt CSS animation, dùng JS RAF
            inner.style.animation  = 'none';
            inner.style.transform  = 'translateX(0)';
            inner.style.willChange = 'transform';

            const SPEED = 45; // px/giây
            let rafId  = null;
            let posX   = 0;
            let lastTs = null;
            let active = false;

            function stop() {
                if (rafId) { cancelAnimationFrame(rafId); rafId = null; }
                lastTs = null;
            }

            function resetInstant() {
                stop();
                active = false;
                posX   = 0;
                inner.style.transform = 'translateX(0)';
            }

            function tick(ts) {
                if (!active) { resetInstant(); return; }
                if (lastTs === null) lastTs = ts;
                const dt = (ts - lastTs) / 1000;
                lastTs = ts;

                posX -= SPEED * dt;
                const half = inner.scrollWidth / 2;
                if (posX <= -half) posX += half; // loop mượt

                inner.style.transform = `translateX(${posX}px)`;
                rafId = requestAnimationFrame(tick);
            }

            // Gắn vào card cha — mỗi element có closure RAF riêng
            const card = titleEl.closest('.movie-card');
            if (!card) return;

            card.addEventListener('mouseenter', () => {
                active = true;
                if (!rafId) { lastTs = null; rafId = requestAnimationFrame(tick); }
            });

            card.addEventListener('mouseleave', () => {
                resetInstant();
            });
        });

    }));
}

// ============================================================
// MAIN INITIALIZATION
// ============================================================
document.addEventListener('DOMContentLoaded', async () => {
    // 1. Chạy các UI tĩnh (giữ nguyên)
    initStickyHeader();
    initMobileMenu();
    initBackToTop();
    initSmoothScroll();
    initCinemaTabs();
    // 2. Lấy dữ liệu từ Database
    try {
        const data = await fetchHomeInitialData();

        if (data) {
            // Lấy toàn bộ dữ liệu từ API
            const allShowing = data.showingMovies || [];
            const allUpcoming = data.upcomingMovies || [];

            // Lấy 3 phim đang chiếu để làm slide nổi bật
            const sliderMovies = data.showingMovies ? data.showingMovies.slice(0, 3) : [];
            renderHeroSlider(sliderMovies);

            // CHỈ HIỂN THỊ 5 PHIM TRÊN HOME
            renderNowShowing(allShowing.slice(0, 5));
            renderComingSoon(allUpcoming.slice(0, 5));

            if (data.locations && data.locations.length > 0) {
                // Khởi tạo dropdown thành phố
                initCustomDropdown(data.locations);

                // Hiển thị rạp của thành phố đầu tiên mặc định
                renderCinemaTabs(data.locations[0].cinemas);
            }

            initScrollAnimations();
            applyMarquee();

            // (Tùy chọn) Lưu toàn bộ dữ liệu vào sessionStorage
            // để trang "Xem tất cả" có thể lấy ra dùng ngay mà không cần gọi API lần nữa
            sessionStorage.setItem('allMovies', JSON.stringify(data));
        }
    } catch (err) {
        console.error("Lỗi khởi tạo dữ liệu:", err);
    }

    console.log('%c🎬 CineMax Home - Only 5 movies displayed!', 'color:#E50914;font-size:14px;font-weight:bold');
});

document.addEventListener('DOMContentLoaded', () => {
    const guestZone = document.getElementById('guest-zone');
    const userZone = document.getElementById('user-zone');
    const displayUsername = document.getElementById('display-username');
    const btnLogout = document.getElementById('btn-logout');

    // Lấy thông tin từ localStorage (đã lưu ở bước đăng ký/đăng nhập)
    const storedUsername = localStorage.getItem('username');

    if (storedUsername) {
        // Đã đăng nhập: Hiện tên, ẩn nút login
        if (guestZone) guestZone.style.display = 'none';
        if (userZone) {
            userZone.style.display = 'flex';
            displayUsername.textContent = storedUsername;
        }
    } else {
        // Chưa đăng nhập: Hiện nút login, ẩn vùng user
        if (guestZone) guestZone.style.display = 'flex';
        if (userZone) userZone.style.display = 'none';
    }

    // Xử lý đăng xuất
    if (btnLogout) {
        btnLogout.addEventListener('click', (e) => {
            e.preventDefault();
            localStorage.removeItem('username');
            localStorage.removeItem('token');
            window.location.reload(); // Tải lại trang để về trạng thái ban đầu
        });
    }
});