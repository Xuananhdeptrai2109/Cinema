// ============================================================
// STATE
// ============================================================
let selectedRating = 0;
let allReviews     = [];
let uploadedFile   = null;
let currentMovie   = null;

// ============================================================
// INIT & FETCH DATA
// ============================================================
document.addEventListener('DOMContentLoaded', async () => {
    const urlParams = new URLSearchParams(window.location.search);
    const movieId = urlParams.get('id');

    if (!movieId) {
        window.location.href = 'home.html';
        return;
    }

    try {
        // 1. Lấy chi tiết phim từ DB
        const response = await fetch(`http://localhost:8080/api/movies/${movieId}`);
        if (!response.ok) throw new Error('Không tìm thấy phim');
        currentMovie = await response.json();

        // 2. Đổ dữ liệu phim vào HTML (Fix giao diện)
        renderMovieDetail(currentMovie);

        // 3. Lấy phim liên quan dựa trên thể loại đầu tiên
        if (currentMovie.genreNames && currentMovie.genreNames.length > 0) {
            fetchRelatedMovies(currentMovie.genreNames[0]);
        }

        // 4. Khởi tạo hiệu ứng cuộn
        const obs = initMovieFadeIn();
        document.querySelectorAll('.fade-in:not(.visible)').forEach(el => obs.observe(el));

    } catch (error) {
        console.error("Lỗi khởi tạo:", error);
    }

    renderReviews();
});

// ============================================================
// RENDER MOVIE DETAIL (FIX GIAO DIỆN)
// ============================================================
function renderMovieDetail(movie) {
    if (!movie) return;

    // 1. Tiêu đề trang & Breadcrumb
    document.title = `${movie.title} – CineMax`;
    const breadcrumbTitle = document.getElementById('breadcrumb-movie-title');
    if (breadcrumbTitle) breadcrumbTitle.textContent = movie.title;

    // 2. Backdrop & Poster
    const backdrop = document.getElementById('movie-backdrop');
    if (backdrop) backdrop.style.backgroundImage = `url('${movie.posterLink}')`;

    const poster = document.getElementById('movie-poster');
    if (poster) {
        poster.src = movie.posterLink;
        poster.alt = movie.title;
    }

    // 3. Status Badge (Đang chiếu / Sắp chiếu)
    const statusBadge = document.getElementById('movie-status');
    if (statusBadge) {
        const isShowing = movie.status === 'showing';
        statusBadge.textContent = isShowing ? 'ĐANG CHIẾU' : 'SẮP CHIẾU';
        statusBadge.className = `poster-badge ${isShowing ? 'now' : 'coming'}`;
    }

    // 4. Genre Tags (Fix lỗi mất thẻ đỏ)
    const genreContainer = document.getElementById('movie-genres');
    if (genreContainer && movie.genreNames) {
        genreContainer.innerHTML = movie.genreNames
            .map(g => `<span class="gtag">${g}</span>`)
            .join('');
    }

    // 5. Title & Star Rating
    document.getElementById('movie-title').textContent = movie.title;
    document.querySelector('.avg-score').textContent = movie.star || '0.0';

    // Render sao vàng dựa trên điểm star từ API
    const starContainer = document.getElementById('avg-stars');
    if (starContainer) {
        starContainer.innerHTML = buildStarHTML(Math.round(movie.star || 0));
    }

    // 6. Meta Grid (Thông tin chi tiết)
    const setMetaVal = (id, val) => {
        const el = document.getElementById(id);
        if (el) el.textContent = val || 'Đang cập nhật';
    };

    setMetaVal('movie-date', movie.releaseDate ? new Date(movie.releaseDate).toLocaleDateString('vi-VN') : 'Sắp chiếu');
    setMetaVal('movie-duration', movie.duration ? `${movie.duration} phút` : '---');
    setMetaVal('movie-language', movie.language);
    setMetaVal('movie-age', movie.ageRating);
    setMetaVal('movie-director', movie.director);
    setMetaVal('movie-actors', movie.actors);

    const directorVal = document.getElementById('movie-director');
    if (directorVal) {
        // movie.director là trường String chúng ta vừa thêm vào MovieResponse ở bước trên
        directorVal.textContent = movie.director || 'Đang cập nhật';
    }

    const actorsEl = document.getElementById('movie-actors');
    if (actorsEl && movie.performerNames) {
        actorsEl.textContent = movie.performerNames.join(', ') || 'Đang cập nhật';
    }

    // Age Chip Color
    const ageChip = document.getElementById('movie-age');
    if (ageChip) ageChip.className = 'meta-val age-chip';

    // 7. Description
    document.getElementById('movie-description').innerHTML = `<p>${movie.description}</p>`;

    // 8. Trailer Setup
    const trailerIframe = document.getElementById('trailer-iframe');
    const modalMovieName = document.getElementById('modal-movie-name');
    if (modalMovieName) modalMovieName.textContent = movie.title;

    if (trailerIframe && movie.trailerLink) {
        const videoId = extractVideoID(movie.trailerLink);
        const embedUrl = `https://www.youtube.com/embed/${videoId}?autoplay=1&rel=0`;

        // Gán vào data-src để dùng cho Modal
        trailerIframe.dataset.src = embedUrl;

        console.log("Đã nhận Trailer Link:", movie.trailerLink);
        console.log("Embed URL dự kiến:", embedUrl);
    } else {
        console.warn("Không tìm thấy trailerLink trong dữ liệu movie trả về từ API");
    }
}

// ============================================================
// RELATED MOVIES (API Version)
// ============================================================
async function fetchRelatedMovies(mainGenre) {
    try {
        const response = await fetch('http://localhost:8080/api/movies/home');
        const data = await response.json();
        const allMovies = [...(data.nowShowing || []), ...(data.upcomingMovies || [])];

        const related = allMovies
            .filter(m => m.id !== currentMovie.id && m.genreNames.includes(mainGenre))
            .slice(0, 5);

        renderRelated(related);
    } catch (error) {
        console.error("Lỗi lấy phim liên quan:", error);
    }
}

function renderRelated(movies) {
    const grid = document.getElementById('related-grid');
    if (!grid) return;

    grid.innerHTML = movies.map((m, i) => `
    <div class="movie-card fade-in" style="transition-delay: ${i * 0.1}s">
      <div class="poster-wrap">
        <img src="${m.posterLink}" alt="${m.title}" loading="lazy" 
             onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=400&q=80'" />
        <span class="rating-badge"><i class="fas fa-star"></i> ${m.star || 0}</span>
        <span class="age-badge">${m.ageRating}</span>
        <div class="card-overlay-btns">
             <button class="overlay-btn detail" onclick="window.location.href='movie.html?id=${m.id}'">
                <i class="fas fa-info-circle"></i> Chi tiết
             </button>
        </div>
      </div>
      <div class="card-body">
        <div class="card-genre"><span>${m.genreNames[0]}</span></div>
        <div class="card-title"><span>${m.title}</span></div>
        <button class="btn-book" onclick="window.location.href='booking.html?id=${m.id}'">Đặt vé</button>
      </div>
    </div>`).join('');
}

// ============================================================
// HELPERS (Giữ nguyên từ bản JS thuần)
// ============================================================
function buildStarHTML(rating) {
    let html = '';
    for (let i = 1; i <= 5; i++) {
        html += `<i class="fas fa-star${i <= rating ? '' : ' empty'}"></i>`;
    }
    return html;
}

function extractVideoID(url) {
    const regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/;
    const match = url.match(regExp);
    return (match && match[2].length === 11) ? match[2] : 'dQw4w9WgXcQ';
}

// ... Copy các hàm Modal, Star Picker, Review, FadeIn từ bản JS thuần của bạn vào đây ...

function generateAvatar(name) {
    return name.trim().charAt(0).toUpperCase();
}

function avatarColor(name) {
    const hues = [0, 30, 60, 120, 180, 200, 240, 280, 320];
    let h = 0;
    for (let i = 0; i < name.length; i++) h += name.charCodeAt(i);
    return `hsl(${hues[h % hues.length]}, 60%, 45%)`;
}
// ============================================================
// TRAILER MODAL
// ============================================================
const trailerModal  = document.getElementById('trailer-modal');
const openTrailerBtn = document.getElementById('open-trailer');
const closeTrailerBtn = document.getElementById('close-trailer');
const trailerIframe = document.getElementById('trailer-iframe');

function openTrailer() {
    trailerIframe.src = trailerIframe.dataset.src;
    trailerModal.classList.add('open');
    document.body.style.overflow = 'hidden';
}

function closeTrailer() {
    trailerModal.classList.remove('open');
    trailerIframe.src = '';  // stop video
    document.body.style.overflow = '';
}

openTrailerBtn.addEventListener('click', openTrailer);
closeTrailerBtn.addEventListener('click', closeTrailer);

// Close on backdrop click
trailerModal.addEventListener('click', (e) => {
    if (e.target === trailerModal) closeTrailer();
});

// Close on Escape
document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && trailerModal.classList.contains('open')) closeTrailer();
});

// ============================================================
// READ MORE / LESS
// ============================================================
const readMoreBtn = document.getElementById('read-more-btn');
const descExtra   = document.getElementById('desc-extra');
const btnSpan     = readMoreBtn.querySelector('span');

readMoreBtn.addEventListener('click', () => {
    const isOpen = descExtra.classList.toggle('show');
    readMoreBtn.classList.toggle('open', isOpen);
    btnSpan.textContent = isOpen ? 'Thu gọn' : 'Xem thêm';
});

// ============================================================
// WISHLIST TOGGLE
// ============================================================
document.getElementById('btn-wishlist').addEventListener('click', function () {
    this.classList.toggle('active');
    const icon = this.querySelector('i');
    icon.classList.toggle('far');
    icon.classList.toggle('fas');
});

// ============================================================
// STAR RATING PICKER
// ============================================================
const starPicker = document.getElementById('star-picker');
const starHint   = document.getElementById('star-hint');
const stars      = starPicker.querySelectorAll('.sp-star');

const LABELS = ['', 'Tệ', 'Không hay', 'Bình thường', 'Hay', 'Xuất sắc!'];

function updateStars(val, mode = 'selected') {
    stars.forEach((s, i) => {
        s.classList.remove('selected', 'hovered');
        if (i < val) s.classList.add(mode);
    });
}

// Hover
stars.forEach((star, idx) => {
    star.addEventListener('mouseenter', () => {
        updateStars(idx + 1, 'hovered');
        starHint.textContent = LABELS[idx + 1];
    });
    star.addEventListener('mouseleave', () => {
        updateStars(selectedRating, 'selected');
        starHint.textContent = selectedRating ? LABELS[selectedRating] : 'Chưa chọn';
    });
    // Click
    star.addEventListener('click', () => {
        selectedRating = idx + 1;
        updateStars(selectedRating, 'selected');
        starHint.textContent = LABELS[selectedRating];
        starHint.style.color = 'var(--gold)';
    });
});

// ============================================================
// UPLOAD PREVIEW
// ============================================================
const uploadInput   = document.getElementById('upload-file');
const uploadPreview = document.getElementById('upload-preview');

uploadInput.addEventListener('change', () => {
    const file = uploadInput.files[0];
    if (!file) return;

    // Size check 20MB
    if (file.size > 20 * 1024 * 1024) {
        showFormError('File quá lớn. Tối đa 20MB.');
        uploadInput.value = '';
        return;
    }

    uploadedFile = file;
    renderUploadPreview(file);
});

function renderUploadPreview(file) {
    uploadPreview.innerHTML = '';
    const url  = URL.createObjectURL(file);
    const item = document.createElement('div');
    item.className = 'preview-item';

    if (file.type.startsWith('image/')) {
        item.innerHTML = `<img src="${url}" alt="preview" />`;
    } else if (file.type.startsWith('video/')) {
        item.innerHTML = `<video src="${url}" muted playsinline></video>`;
    }

    // Remove button
    const rm = document.createElement('button');
    rm.className   = 'preview-remove';
    rm.innerHTML   = '<i class="fas fa-times"></i>';
    rm.title       = 'Xóa';
    rm.addEventListener('click', () => {
        uploadedFile = null;
        uploadInput.value = '';
        uploadPreview.innerHTML = '';
        URL.revokeObjectURL(url);
    });
    item.appendChild(rm);
    uploadPreview.appendChild(item);
}

// ============================================================
// FORM VALIDATION & SUBMIT REVIEW
// ============================================================
const formError      = document.getElementById('form-error');
const reviewTextarea = document.getElementById('review-text');
const charCur        = document.getElementById('char-cur');
const btnSubmit      = document.getElementById('btn-submit-review');

// Char count
reviewTextarea.addEventListener('input', () => {
    charCur.textContent = reviewTextarea.value.length;
    clearFormError();
});

function showFormError(msg) {
    formError.innerHTML = `<i class="fas fa-exclamation-circle"></i> ${msg}`;
}
function clearFormError() { formError.innerHTML = ''; }

btnSubmit.addEventListener('click', () => {
    clearFormError();

    if (!selectedRating) {
        showFormError('Vui lòng chọn số sao trước khi gửi.');
        starPicker.style.animation = 'none';
        starPicker.offsetHeight;
        starPicker.style.animation = 'shake .35s ease';
        return;
    }
    if (!reviewTextarea.value.trim()) {
        showFormError('Vui lòng nhập nội dung đánh giá.');
        reviewTextarea.focus();
        return;
    }

    // Build new review
    const now = new Date();
    const dateStr = `${String(now.getDate()).padStart(2,'0')}/${String(now.getMonth()+1).padStart(2,'0')}/${now.getFullYear()}`;

    const newReview = {
        name:   'Bạn',
        rating: selectedRating,
        text:   reviewTextarea.value.trim(),
        date:   dateStr,
        media:  uploadedFile ? [{ type: uploadedFile.type, url: URL.createObjectURL(uploadedFile) }] : [],
        isNew:  true,
    };

    // Prepend to list
    allReviews.unshift(newReview);
    renderReviews();

    // Scroll to reviews list
    document.getElementById('reviews-scroll').scrollTo({ top: 0, behavior: 'smooth' });

    // Reset form
    selectedRating = 0;
    updateStars(0, 'selected');
    starHint.textContent = 'Chưa chọn';
    starHint.style.color = '';
    reviewTextarea.value = '';
    charCur.textContent  = '0';
    uploadedFile  = null;
    uploadInput.value    = '';
    uploadPreview.innerHTML = '';

    // Update review count
    document.getElementById('review-count').textContent = allReviews.length + 128 - seedReviews.length;

    // Success flash
    btnSubmit.textContent = '✓ Đã gửi!';
    btnSubmit.style.background = '#00c853';
    setTimeout(() => {
        btnSubmit.innerHTML = '<i class="fas fa-paper-plane"></i> Gửi đánh giá';
        btnSubmit.style.background = '';
    }, 2000);
});

// ============================================================
// RENDER REVIEWS
// ============================================================
const REVIEWS_PER_PAGE = 5; // Số bình luận hiển thị trước khi cuộn

const reviewsScroll = document.getElementById('reviews-scroll');

function renderReviews() {
    const sortVal = document.getElementById('reviews-sort').value;

    // Sắp xếp theo filter
    const sorted = [...allReviews].sort((a, b) => {
        if (sortVal === 'top') return b.rating - a.rating;
        if (sortVal === 'low') return a.rating - b.rating;
        return 0; // 'newest' → giữ thứ tự chèn (mới nhất đầu)
    });

    if (!sorted.length) {
        reviewsScroll.innerHTML = `
      <div class="reviews-empty">
        <i class="far fa-comment-dots"></i>
        Chưa có đánh giá nào. Hãy là người đầu tiên!
      </div>`;
        reviewsScroll.style.overflowY = 'hidden';
        return;
    }

    reviewsScroll.innerHTML = sorted.map((r, i) => {
        const starsHTML = buildStarHTML(r.rating);
        const mediaHTML = r.media.map(m => {
            if (m.type && m.type.startsWith('video/')) return `<video src="${m.url}" controls></video>`;
            if (m.url) return `<img src="${m.url}" alt="media" />`;
            return '';
        }).join('');

        const delay = Math.min(i * 0.05, 0.3);
        return `
      <div class="review-item" style="animation-delay:${delay}s">
        <div class="ri-avatar" style="background:${avatarColor(r.name)}">${generateAvatar(r.name)}</div>
        <div class="ri-body">
          <div class="ri-top">
            <span class="ri-name">${r.name}</span>
            <div class="ri-stars">${starsHTML}</div>
            <span class="ri-date">${r.date}</span>
          </div>
          <p class="ri-text">${r.text}</p>
          ${mediaHTML ? `<div class="ri-media">${mediaHTML}</div>` : ''}
        </div>
      </div>`;
    }).join('');

    // Bật / tắt cuộn tuỳ số lượng bình luận
    if (sorted.length > REVIEWS_PER_PAGE) {
        reviewsScroll.style.overflowY = 'auto';
    } else {
        reviewsScroll.style.overflowY = 'hidden';
    }
}

document.getElementById('reviews-sort').addEventListener('change', renderReviews);

// ============================================================
// SCROLL FADE-IN (standalone — không cần IntersectionObserver từ script.js)
// ============================================================
function initMovieFadeIn() {
    const obs = new IntersectionObserver((entries) => {
        entries.forEach(e => {
            if (e.isIntersecting) { e.target.classList.add('visible'); obs.unobserve(e.target); }
        });
    }, { threshold: 0.1 });

    document.querySelectorAll('.fade-in').forEach(el => obs.observe(el));
    return obs;
}

// ============================================================
// INIT
// ============================================================
document.addEventListener('DOMContentLoaded', () => {
    renderReviews();
    // renderRelated();

    const obs = initMovieFadeIn();
    // Re-observe after render
    document.querySelectorAll('.fade-in:not(.visible)').forEach(el => obs.observe(el));

    // Marquee for related cards
    setTimeout(() => {
        if (typeof applyMarquee === 'function') applyMarquee();
    }, 150);

    console.log('%c🎬 CineMax Movie page ready', 'color:#E50914;font-size:13px;font-weight:bold');
});