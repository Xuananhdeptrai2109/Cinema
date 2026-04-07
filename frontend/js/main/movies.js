// ============================================================
// movies.js — CineMax Movie List Page
// Features: mock data (50 phim), tab filter, search, genre/lang/sort,
//           pagination (20/trang, 5 cột × 4 hàng), skeleton loading
// ============================================================
// MARQUEE — riêng cho movies page, dùng ResizeObserver đo chính xác
// ============================================================
function initMoviesMarquee() {
    document.querySelectorAll('#movies-grid .card-title, #movies-grid .card-genre').forEach(el => {
        if (el.dataset.mq) return;
        el.dataset.mq = '1';

        const inner = el.querySelector('.marquee-inner');
        if (!inner) return;

        const SPEED = 45;
        let rafId = null, posX = 0, lastTs = null, active = false, ready = false;

        function stop() {
            if (rafId) { cancelAnimationFrame(rafId); rafId = null; }
            lastTs = null;
        }
        function reset() {
            stop(); active = false; posX = 0;
            inner.style.transform = 'translateX(0)';
        }
        function tick(ts) {
            if (!active) { reset(); return; }
            if (lastTs === null) lastTs = ts;
            posX -= SPEED * (ts - lastTs) / 1000;
            lastTs = ts;
            const half = inner.scrollWidth / 2;
            if (posX <= -half) posX += half;
            inner.style.transform = `translateX(${posX}px)`;
            rafId = requestAnimationFrame(tick);
        }

        function check() {
            if (inner.scrollWidth > el.clientWidth && !ready) {
                const original = inner.textContent;
                inner.textContent = original + '\u00A0'.repeat(8) + original;
                inner.style.display    = 'inline-block';
                inner.style.whiteSpace = 'nowrap';
                inner.style.animation  = 'none';
                inner.style.transform  = 'translateX(0)';
                inner.style.willChange = 'transform';
                ready = true;
            }
        }

        const card = el.closest('.movie-card');
        if (!card) return;

        card.addEventListener('mouseenter', () => {
            if (!ready) return;
            active = true;
            if (!rafId) { lastTs = null; rafId = requestAnimationFrame(tick); }
        });
        card.addEventListener('mouseleave', reset);

        // Đo chính xác khi layout ổn định
        const ro = new ResizeObserver(() => { check(); ro.disconnect(); });
        ro.observe(el);
        requestAnimationFrame(() => requestAnimationFrame(check));
    });
}
// ============================================================
// STATE
// ============================================================
const ITEMS_PER_PAGE = 20; // 5 cột × 4 hàng

let state = {
    tab:     'all',   // 'all' | 'now' | 'coming'
    search:  '',
    genre:   '',
    lang:    '',
    sort:    'default',
    page:    1,
};
// ============================================================
// LẤY DỮ LIỆU TỪ DATABASE (API)
// ============================================================
// Biến lưu trữ dữ liệu từ Database trả về
let ALL_MOVIES_FROM_DB = [];
let filteredMovies = [];

async function fetchMoviesFromDB() {
    const grid = document.getElementById('movies-grid');
    try {
        const response = await fetch('http://localhost:8080/api/movies/home');
        if (!response.ok) throw new Error("Server trả về lỗi: " + response.status);

        const data = await response.json();
        // Gộp danh sách đang chiếu và sắp chiếu từ API
        ALL_MOVIES_FROM_DB = [
            ...(data.nowShowing || []),
            ...(data.comingSoon || [])
        ];
        renderAll();
    } catch (error) {
        console.error("Lỗi khi lấy dữ liệu phim:", error);
    }
}
// ============================================================
// FILTER & SORT
// ============================================================
function applyFilters() {
    let list = [...ALL_MOVIES_FROM_DB];

    // Tab
    if (state.tab !== 'all') {
        const tabMap = {
            'now': 'showing',
            'coming': 'coming_soon'
        };
        // Fix: đổi statusMap thành tabMap cho đúng khai báo
        list = list.filter(m => m.status === tabMap[state.tab]);
    }

    // Search
    if (state.search) {
        const q = state.search.toLowerCase();
        list = list.filter(m => m.title.toLowerCase().includes(q));
    }

    // Genre
    if (state.genre) {
        list = list.filter(m => m.genreNames && m.genreNames.includes(state.genre));
    }

    // Language
    if (state.lang) {
        list = list.filter(m => m.language === state.lang);
    }

    // Sort
    switch (state.sort) {
        case 'name-asc':    list.sort((a,b) => a.title.localeCompare(b.title, 'vi')); break;
        case 'name-desc':   list.sort((a,b) => b.title.localeCompare(a.title, 'vi')); break;
        case 'rating-desc': list.sort((a,b) => b.rating - a.rating); break;
        case 'date-desc':
            list.sort((a,b) => {
                const parse = d => { const [dd,mm,yyyy] = d.split('/'); return new Date(`${yyyy}-${mm}-${dd}`); };
                return parse(b.date) - parse(a.date);
            });
            break;
    }

    filteredMovies = list;
}

// ============================================================
// RENDER
// ============================================================
const grid         = document.getElementById('movies-grid');
const resultCount  = document.getElementById('result-count');
const emptyState   = document.getElementById('empty-state');
const paginationWrap = document.getElementById('pagination-wrap');

async function fetchAndRenderGenres() {
    const listUl = document.getElementById('genre-list');
    const trigger = document.getElementById('genre-trigger');
    const selectedText = document.getElementById('genre-selected');

    try {
        // 1. Lấy dữ liệu từ API
        const response = await fetch('http://localhost:8080/api/genres/all');
        const genres = await response.json();

        // 2. Đổ dữ liệu vào <ul>
        let html = '<li class="genre-item active" data-value="">Tất cả thể loại</li>';
        html += genres.map(name => `<li class="genre-item" data-value="${name}">${name}</li>`).join('');
        listUl.innerHTML = html;

        // 3. LOGIC BẤM ĐỂ MỞ (Sửa lỗi "không bấm được")
        trigger.onclick = (e) => {
            e.stopPropagation(); // Ngăn sự kiện lan ra ngoài
            listUl.classList.toggle('open');
        };

        // 4. Logic chọn thể loại
        listUl.querySelectorAll('.genre-item').forEach(item => {
            item.onclick = () => {
                const val = item.dataset.value;
                selectedText.textContent = item.textContent;

                // Cập nhật UI active
                listUl.querySelectorAll('.genre-item').forEach(li => li.classList.remove('active'));
                item.classList.add('active');

                // Lọc phim
                state.genre = val;
                state.page = 1;
                renderAll();

                listUl.classList.remove('open'); // Đóng menu sau khi chọn
            };
        });

    } catch (error) {
        console.error("Lỗi cập nhật thể loại:", error);
    }
}

// Click ra ngoài màn hình thì đóng menu
document.addEventListener('click', () => {
    document.getElementById('genre-list')?.classList.remove('open');
});

function renderGrid() {
    const start = (state.page - 1) * ITEMS_PER_PAGE;
    const end   = start + ITEMS_PER_PAGE;
    const page  = filteredMovies.slice(start, end);

    resultCount.textContent = filteredMovies.length;

    if (!filteredMovies.length) {
        grid.innerHTML = '';
        emptyState.style.display = 'block';
        paginationWrap.style.display = 'none';
        return;
    }

    emptyState.style.display = 'none';
    paginationWrap.style.display = 'flex';

    grid.innerHTML = page.map((m, i) => {
        const delay = Math.min(i * 0.03, 0.4);

        // Mapping dữ liệu từ MovieResponse
        const title    = m.title || 'Chưa có tiêu đề';
        const poster   = m.posterLink || 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=400&q=80';
        const rating   = m.star || 0;
        const age      = m.ageRating || 'T13';
        const genres   = m.genreNames && m.genreNames.length > 0 ? m.genreNames.join(' - ') : 'Phim';
        const date     = m.releaseDate ? new Date(m.releaseDate).toLocaleDateString('vi-VN') : 'Sắp chiếu';

        const isNow    = m.status === 'showing';

        return `
      <div class="movie-card" style="animation-delay:${delay}s">
        <div class="poster-wrap">
          <img src="${poster}" alt="${title}" loading="lazy"
            onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=400&q=80'" />
          
          <span class="rating-badge"><i class="fas fa-star"></i> ${rating}</span>
          <span class="age-badge">${age}</span>
          
          ${m.status === 'showing'
            ? `<span class="status-badge now">Đang chiếu</span>`
            : `<span class="status-badge coming">Sắp chiếu</span>`
        }

          <div class="card-overlay-btns">
            ${m.status === 'showing'
            ? `<button class="overlay-btn detail" onclick="window.location.href='movie.html?id=${m.id}'">
                     <i class="fas fa-info-circle"></i> Xem chi tiết
                   </button>`
            : `<button class="overlay-btn overlay-follow" onclick="toggleFollowOverlay(this)">
                     <i class="far fa-bookmark"></i> <span>Theo dõi</span>
                   </button>`
        }
          </div>
        </div>

        <div class="card-body">
          <div class="card-genre">
            <span class="marquee-inner">${genres}</span>
          </div>
          <div class="card-title">
            <span class="marquee-inner">${title}</span>
          </div>
          <div class="card-info">
            <span><i class="fas fa-calendar-alt"></i> ${date}</span>
          </div>

          ${m.status === 'showing'
            ? `<button class="btn-book btn-coming" onclick="window.location.href='booking.html?id=${m.id}'">Đặt vé ngay</button>`
            : `<button class="btn-book btn-coming" onclick="window.location.href='movie.html?id=${m.id}'">
                 Xem chi tiết
               </button>`
        }
        </div>
      </div>`;
    }).join('');
    renderMovieDetail
    initMoviesMarquee();
}

// ============================================================
// PAGINATION
// ============================================================
const pagination = document.getElementById('pagination');
const pageInfo   = document.getElementById('page-info');

function renderPagination() {
    const total = Math.ceil(filteredMovies.length / ITEMS_PER_PAGE);
    if (total <= 1) { pagination.innerHTML = ''; pageInfo.textContent = ''; return; }

    const cur   = state.page;
    const delta = 2; // pages around current
    let html    = '';

    // Prev
    html += `<button class="pg-btn" ${cur === 1 ? 'disabled' : ''} data-page="${cur - 1}">
    <i class="fas fa-chevron-left"></i>
  </button>`;

    // Page numbers with ellipsis
    const pages = [];
    for (let p = 1; p <= total; p++) {
        if (p === 1 || p === total || (p >= cur - delta && p <= cur + delta)) {
            pages.push(p);
        }
    }

    let last = null;
    for (const p of pages) {
        if (last !== null && p - last > 1) {
            html += `<button class="pg-btn pg-dots" disabled>…</button>`;
        }
        html += `<button class="pg-btn ${p === cur ? 'active' : ''}" data-page="${p}">${p}</button>`;
        last = p;
    }

    // Next
    html += `<button class="pg-btn" ${cur === total ? 'disabled' : ''} data-page="${cur + 1}">
    <i class="fas fa-chevron-right"></i>
  </button>`;

    pagination.innerHTML = html;

    // Page info
    const start = (cur - 1) * ITEMS_PER_PAGE + 1;
    const end   = Math.min(cur * ITEMS_PER_PAGE, filteredMovies.length);
    pageInfo.textContent = `Hiển thị ${start}–${end} / ${filteredMovies.length} phim`;
}

pagination.addEventListener('click', (e) => {
    const btn = e.target.closest('.pg-btn[data-page]');
    if (!btn || btn.disabled) return;
    const p = parseInt(btn.dataset.page);
    if (p === state.page) return;
    state.page = p;
    renderAll();
    // Scroll to top of grid
    document.querySelector('.tabs-bar').scrollIntoView({ behavior: 'smooth', block: 'start' });
});

// ============================================================
// RENDER ALL (grid + pagination)
// ============================================================
function renderAll() {
    applyFilters();
    renderGrid();
    renderPagination();
}

// ============================================================
// TAB SWITCHING
// ============================================================
document.querySelectorAll('.tab-btn').forEach(btn => {
    btn.addEventListener('click', () => {
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        state.tab  = btn.dataset.tab;
        state.page = 1;

        // Sync header nav active class
        const navLinks = document.querySelectorAll('#header .nav a, #header .mobile-nav a');
        navLinks.forEach(a => a.classList.remove('active'));
        if (state.tab === 'now') {
            navLinks.forEach(a => { if (a.textContent.trim() === 'Đang chiếu') a.classList.add('active'); });
        } else if (state.tab === 'coming') {
            navLinks.forEach(a => { if (a.textContent.trim() === 'Sắp chiếu') a.classList.add('active'); });
        }

        // Update breadcrumb
        const labels = { all: 'Tất cả phim', now: 'Phim đang chiếu', coming: 'Phim sắp chiếu' };
        document.getElementById('breadcrumb-label').textContent = labels[state.tab];
        renderAll();
    });
});

// ============================================================
// SEARCH
// ============================================================
const searchInput = document.getElementById('filter-search');
const clearBtn    = document.getElementById('fs-clear');

let searchTimer;
searchInput.addEventListener('input', () => {
    state.search = searchInput.value.trim();
    state.page   = 1;
    clearBtn.classList.toggle('show', !!state.search);
    clearTimeout(searchTimer);
    searchTimer = setTimeout(renderAll, 220);
});

clearBtn.addEventListener('click', () => {
    searchInput.value = '';
    state.search      = '';
    state.page        = 1;
    clearBtn.classList.remove('show');
    renderAll();
    searchInput.focus();
});

// ============================================================
// FILTER DROPDOWNS
// ============================================================
document.getElementById('filter-lang').addEventListener('change', function () {
    state.lang = this.value; state.page = 1; renderAll();
});
document.getElementById('filter-sort').addEventListener('change', function () {
    state.sort = this.value; state.page = 1; renderAll();
});

// Reset filters
function resetAllFilters() {
    // 1. Reset trạng thái logic (State)
    state.search = '';
    state.genre  = '';
    state.lang   = '';
    state.sort   = 'default';
    state.page   = 1;

    // 2. Reset ô tìm kiếm (Search Input)
    if (searchInput) {
        searchInput.value = '';
    }
    if (clearBtn) {
        clearBtn.classList.remove('show');
    }

    // 3. Reset Custom Genre Dropdown (UL/LI)
    // Xóa tất cả trạng thái active cũ
    document.querySelectorAll('.genre-item').forEach(item => {
        item.classList.remove('active');
    });

    // Active lại mục "Tất cả thể loại" (item có data-value rỗng)
    const defaultGenreItem = document.querySelector('.genre-item[data-value=""]');
    if (defaultGenreItem) {
        defaultGenreItem.classList.add('active');
    }

    // Cập nhật lại chữ hiển thị trên nút bấm
    const genreSelectedText = document.getElementById('genre-selected');
    if (genreSelectedText) {
        genreSelectedText.textContent = 'Tất cả thể loại';
    }

    // 4. Reset các Select truyền thống còn lại (nếu còn dùng)
    const langSelect = document.getElementById('filter-lang');
    if (langSelect) {
        langSelect.value = '';
    }

    const sortSelect = document.getElementById('filter-sort');
    if (sortSelect) {
        sortSelect.value = 'default';
    }

    // 5. Render lại toàn bộ danh sách phim với bộ lọc rỗng
    renderAll();

    // (Tùy chọn) Cuộn lên đầu danh sách để người dùng thấy kết quả mới
    const gridTitle = document.querySelector('.tabs-bar');
    if (gridTitle) {
        gridTitle.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
}
document.getElementById('btn-reset').addEventListener('click', resetAllFilters);
document.getElementById('empty-reset').addEventListener('click', resetAllFilters);

// ============================================================
// URL PARAM — ?tab=coming | ?tab=now
// ============================================================
function applyUrlParam() {
    const params = new URLSearchParams(window.location.search);
    const tab    = params.get('tab');
    if (tab === 'coming' || tab === 'now') {
        state.tab = tab;

        // Active đúng tab button
        document.querySelectorAll('.tab-btn').forEach(b => {
            b.classList.toggle('active', b.dataset.tab === tab);
        });

        // Sync breadcrumb
        const labels = { now: 'Phim đang chiếu', coming: 'Phim sắp chiếu' };
        const bc = document.getElementById('breadcrumb-label');
        if (bc) bc.textContent = labels[tab];

        // Sync header nav
        const navLinks = document.querySelectorAll('#header .nav a, #header .mobile-nav a');
        navLinks.forEach(a => a.classList.remove('active'));
        const navLabel = tab === 'now' ? 'Đang chiếu' : 'Sắp chiếu';
        navLinks.forEach(a => { if (a.textContent.trim() === navLabel) a.classList.add('active'); });
    }
}

// ============================================================
// THEO DÕI TOGGLE — icon bookmark đổi solid + hiệu ứng vàng
// ============================================================
function toggleFollow(btn) {
    const icon = btn.querySelector('i');
    const label = btn.querySelector('span');
    const isFollowed = btn.classList.toggle('followed');

    // Đổi icon far ↔ fas
    icon.classList.toggle('far', !isFollowed);
    icon.classList.toggle('fas', isFollowed);

    // Pop animation
    icon.classList.remove('bookmark-pop');
    void icon.offsetWidth; // reflow
    icon.classList.add('bookmark-pop');

    label.textContent = isFollowed ? 'Đã theo dõi' : 'Theo dõi';

    // Sync overlay button nếu có
    const card          = btn.closest('.movie-card');
    const overlayFollow = card && card.querySelector('.overlay-follow');
    if (overlayFollow) syncFollowBtn(overlayFollow, isFollowed);
}

function toggleFollowOverlay(btn) {
    const icon        = btn.querySelector('i');
    const label       = btn.querySelector('span');
    const isFollowed  = btn.classList.toggle('followed');

    icon.classList.toggle('far', !isFollowed);
    icon.classList.toggle('fas', isFollowed);
    icon.classList.remove('bookmark-pop');
    void icon.offsetWidth;
    icon.classList.add('bookmark-pop');

    label.textContent = isFollowed ? 'Đã theo dõi' : 'Theo dõi';
}

function syncFollowBtn(btn, isFollowed) {
    const icon  = btn.querySelector('i');
    const label = btn.querySelector('span');
    btn.classList.toggle('followed', isFollowed);
    if (icon)  { icon.classList.toggle('far', !isFollowed); icon.classList.toggle('fas', isFollowed); }
    if (label) label.textContent = isFollowed ? 'Đã theo dõi' : 'Theo dõi';
}
// ============================================================
// INTERCEPT NAV LINKS — khi đang ở movies.html, click nav
// "Đang chiếu" / "Sắp chiếu" sẽ switch tab trực tiếp
// ============================================================
(function interceptNavLinks() {
    const navMap = {
        'Đang chiếu':      'now',
        'Sắp chiếu':       'coming',
        'Phim đang chiếu': 'now',
        'Phim sắp chiếu':  'coming',
    };

    document.querySelectorAll('#header .nav a, #header .mobile-nav a').forEach(link => {
        const label = link.textContent.trim();
        if (!navMap[label]) return;

        link.addEventListener('click', (e) => {
            e.preventDefault();
            const tab = navMap[label];

            document.querySelectorAll('.tab-btn').forEach(b => {
                b.classList.toggle('active', b.dataset.tab === tab);
            });

            state.tab  = tab;
            state.page = 1;

            const labels = { now: 'Phim đang chiếu', coming: 'Phim sắp chiếu' };
            const bc = document.getElementById('breadcrumb-label');
            if (bc) bc.textContent = labels[tab];

            document.querySelectorAll('#header .nav a, #header .mobile-nav a')
                .forEach(a => a.classList.remove('active'));
            link.classList.add('active');

            document.getElementById('mobile-nav')?.classList.remove('open');
            document.getElementById('hamburger')?.classList.remove('open');

            renderAll();
        });
    });
})();
document.addEventListener('DOMContentLoaded', () => {
    applyUrlParam();
    fetchMoviesFromDB();
    fetchAndRenderGenres();
    console.log('%c🎬 CineMax Movies list ready', 'color:#E50914;font-size:13px;font-weight:bold');
});