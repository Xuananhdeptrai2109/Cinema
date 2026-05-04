// ============================================================
// STATE
// ============================================================
let selectedRating = 0;
let allReviews     = [];
let uploadedFile   = null;
let currentMovie   = null;

const API_BASE = "http://localhost:8080/api";

// Khai báo biến DOM một lần duy nhất ở đầu file
const reviewsScroll  = document.getElementById('reviews-scroll');
const btnSubmit      = document.getElementById('btn-submit-review');
const reviewTextarea = document.getElementById('review-text');
const starPicker     = document.getElementById('star-picker');
const starHint       = document.getElementById('star-hint');
const stars          = starPicker ? starPicker.querySelectorAll('.sp-star') : [];
const formError      = document.getElementById('form-error');
const charCur        = document.getElementById('char-cur');
const uploadInput    = document.getElementById('upload-file');
const uploadPreview  = document.getElementById('upload-preview');

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
        const response = await fetch(`${API_BASE}/movies/${movieId}`);
        if (!response.ok) throw new Error('Không tìm thấy phim');
        currentMovie = await response.json();

        // 1. Hiển thị chi tiết phim (Hàm này sẽ tự xử lý ẩn/hiện vùng đánh giá)
        renderMovieDetail(currentMovie);

        // 2. Kiểm tra trạng thái để tải bình luận[cite: 33]
        const status = (currentMovie.status || "").toLowerCase();
        if (status === 'showing') {
            fetchComments(movieId);
        } else {
            allReviews = [];
        }

        // 3. Phim liên quan[cite: 33]
        if (currentMovie.genreNames && currentMovie.genreNames.length > 0) {
            fetchRelatedMovies(currentMovie.genreNames[0]);
        }

        // 4. KÍCH HOẠT HIỆU ỨNG (Gộp từ khối cũ vào đây)[cite: 33]
        const obs = initMovieFadeIn();
        document.querySelectorAll('.fade-in').forEach(el => obs.observe(el));

        setTimeout(() => {
            if (typeof applyMarquee === 'function') applyMarquee();
        }, 150);

        console.log('%c🎬 CineMax Movie page ready', 'color:#E50914;font-size:13px;font-weight:bold');

    } catch (error) {
        console.error("Lỗi khởi tạo:", error);
    }
});
// ============================================================
// COMMENT LOGIC (LƯU VÀ HIỂN THỊ TỪ DB)
// ============================================================
async function fetchComments(movieId) {
    try {
        const response = await fetch(`${API_BASE}/comments/movie/${movieId}`);
        if (response.ok) {
            allReviews = await response.json(); // Nhận List<CommentResponse> từ API
            renderReviews();
        }
    } catch (error) { console.error("Lỗi lấy bình luận:", error); }
}

// ============================================================
// SUBMIT REVIEW TO DB (BẢN SỬA LỖI MẤT DỮ LIỆU)
// ============================================================
btnSubmit.addEventListener('click', async () => {
    // BƯỚC 1: "Chụp" dữ liệu ngay lập tức khi vừa nhấn nút
    const finalContent = reviewTextarea.value.trim();
    const finalRating  = selectedRating;

    // BƯỚC 2: Kiểm tra dữ liệu đầu vào (Validate)
    if (finalRating === 0) {
        alert("Vui lòng chọn số sao đánh giá!");
        return;
    }
    if (!finalContent) {
        alert("Vui lòng nhập nội dung bình luận!");
        return;
    }

    const token = localStorage.getItem('token');
    if (!token) {
        alert("Bạn cần đăng nhập để thực hiện tác vụ này!");
        return;
    }

    try {
        btnSubmit.disabled = true;
        btnSubmit.textContent = 'Đang xử lý...';

        // BƯỚC 3: Xử lý ảnh sang Base64 (Nếu có)
        let base64Img = null;
        if (uploadedFile) {
            base64Img = await new Promise((resolve) => {
                const reader = new FileReader();
                reader.onload = (e) => resolve(e.target.result);
                reader.readAsDataURL(uploadedFile);
            });
        }

        // BƯỚC 4: Đóng gói dữ liệu (Ảnh luôn để cuối cùng)
        const commentData = {
            movieId: currentMovie.id,
            starRating: finalRating, // Dùng giá trị đã "chụp" ở Bước 1
            content: finalContent,   // Dùng giá trị đã "chụp" ở Bước 1
            imageUrl: base64Img      // Dữ liệu ảnh khổng lồ ở cuối
        };

        // BƯỚC 5: Gửi lên Server
        const response = await fetch(`${API_BASE}/comments`, {
            method: 'POST',
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(commentData)
        });

        if (response.ok) {
            // CHỈ RESET FORM KHI ĐÃ GỬI THÀNH CÔNG
            reviewTextarea.value = '';
            selectedRating = 0;
            updateStars(0);
            uploadedFile = null;
            if (uploadPreview) uploadPreview.innerHTML = '';

            // Tải lại danh sách bình luận
            fetchComments(currentMovie.id);
        } else {
            const err = await response.text();
        }

    } catch (error) {
        console.error("Lỗi kết nối:", error);
        alert("Không thể kết nối đến máy chủ.");
    } finally {
        btnSubmit.disabled = false;
        btnSubmit.innerHTML = '<i class="fas fa-paper-plane"></i> Gửi đánh giá';
    }
});

function resetReviewForm() {
    selectedRating = 0;
    updateStars(0);
    reviewTextarea.value = '';
    uploadedFile = null;
    if (uploadPreview) uploadPreview.innerHTML = '';
}
// ============================================================
// RENDER MOVIE DETAIL (FIX GIAO DIỆN)
// ============================================================
function renderMovieDetail(movie) {
    if (!movie) return;

    const status = (movie.status || "").toLowerCase();
    document.title = `${movie.title} – CineMax`;

    const breadcrumbTitle = document.getElementById('breadcrumb-movie-title');
    if (breadcrumbTitle) breadcrumbTitle.textContent = movie.title;
    document.getElementById('movie-title').textContent = movie.title;
    document.getElementById('movie-description').innerHTML = `<p>${movie.description}</p>`;

    const backdrop = document.getElementById('movie-backdrop');
    if (backdrop) backdrop.style.backgroundImage = `url('${movie.posterLink}')`;

    const poster = document.getElementById('movie-poster');
    if (poster) poster.src = movie.posterLink;

    // --- CẬP NHẬT LOGIC ẨN/HIỆN ĐÁNH GIÁ ---
    const avgScoreEl = document.querySelector('.avg-score');
    const starContainer = document.getElementById('avg-stars');
    const fullReviewSection = document.querySelector('.review-section');

    if (movie.status === 'coming_soon') {
        // 1. Hiển thị trạng thái chờ thay vì điểm số
        if (avgScoreEl) avgScoreEl.textContent = '---';
        if (starContainer) starContainer.innerHTML = '<span style="color:var(--muted); font-size: 0.9rem;">Chưa có đánh giá</span>';

        // 2. Thay thế Form nhập đánh giá bằng thông báo khóa
        if (fullReviewSection) {
            fullReviewSection.style.display = 'none';
        }
    } else {
        // Hiển thị điểm star bình thường cho phim 'showing'
        if (fullReviewSection) fullReviewSection.style.display = 'block';
        if (avgScoreEl) avgScoreEl.textContent = movie.star ? movie.star.toFixed(1) : '0.0';
        if (starContainer) starContainer.innerHTML = buildStarHTML(movie.star || 0);
    }

    // --- Cập nhật Meta Grid (Giữ nguyên) ---
    const setVal = (id, val) => { const el = document.getElementById(id); if (el) el.textContent = val || 'Đang cập nhật'; };
    setVal('movie-date', movie.releaseDate);
    setVal('movie-duration', `${movie.duration} phút`);
    setVal('movie-language', movie.language);
    setVal('movie-age', movie.ageRating);
    setVal('movie-director', movie.director);

    const actorsEl = document.getElementById('movie-actors');
    if (actorsEl && movie.performerNames) actorsEl.textContent = movie.performerNames.join(', ');

    const trailerIframe = document.getElementById('trailer-iframe');
    if (trailerIframe && movie.trailerLink) {
        trailerIframe.dataset.src = `https://www.youtube.com/embed/${extractVideoID(movie.trailerLink)}?autoplay=1`;
    }

    const btnTicket = document.querySelector('.btn-ticket-main');
    if (btnTicket) {
        if (status === 'coming_soon') {
            btnTicket.innerHTML = '<i class="fas fa-bell"></i> Nhận thông báo';
            btnTicket.style.background = '#444';
            btnTicket.onclick = () => alert("Phim sắp chiếu, chúng tôi sẽ thông báo khi có lịch!");
        } else {
            btnTicket.onclick = () => window.location.href = `booking.html?id=${movie.id}`;
        }
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
// HELPERS
// ============================================================
function buildStarHTML(rating) {
    let html = '';
    for (let i = 1; i <= 5; i++) {
        if (i <= rating) html += '<i class="fas fa-star"></i>';
        else if (i - 0.5 <= rating) html += '<i class="fas fa-star-half-alt"></i>';
        else html += '<i class="far fa-star"></i>';
    }
    return html;
}

function extractVideoID(url) {
    const regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/;
    const match = url.match(regExp);
    return (match && match[2].length === 11) ? match[2] : 'dQw4w9WgXcQ';
}

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
// const btnSpan     = readMoreBtn.querySelector('span');
const btnSpan = readMoreBtn ? readMoreBtn.querySelector('span') : null;

if (readMoreBtn && btnSpan) {
    readMoreBtn.addEventListener('click', () => {
        const isOpen = descExtra.classList.toggle('show');
        readMoreBtn.classList.toggle('open', isOpen);
        btnSpan.textContent = isOpen ? 'Thu gọn' : 'Xem thêm';
    });
}

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

    const countEl = document.getElementById('review-count');
    if (countEl) {
        countEl.textContent = allReviews.length;
    }

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

function renderReviews() {
    // 1. Kiểm tra phần tử hiển thị có tồn tại không
    if (!reviewsScroll) return;

    // 2. Lấy giá trị sắp xếp an toàn với Optional Chaining (?.)
    const sortSelect = document.getElementById('reviews-sort');
    const sortVal = sortSelect ? sortSelect.value : 'newest';

    // 3. Logic sắp xếp dữ liệu từ Database
    const sorted = [...allReviews].sort((a, b) => {
        if (sortVal === 'top') return b.starRating - a.starRating;
        if (sortVal === 'low') return a.starRating - b.starRating;
        // Mặc định sắp xếp theo ngày tạo (mới nhất lên đầu)
        return new Date(b.createdAt) - new Date(a.createdAt);
    });

    // 4. Hiển thị thông báo nếu chưa có bình luận và ẩn thanh cuộn
    if (!sorted.length) {
        reviewsScroll.innerHTML = `<div class="reviews-empty">Chưa có đánh giá nào. Hãy là người đầu tiên!</div>`;
        reviewsScroll.style.overflowY = 'hidden';
        return;
    }

    // 5. Vẽ danh sách bình luận thực tế
    reviewsScroll.innerHTML = sorted.map((r, i) => {
        const starsHTML = buildStarHTML(r.starRating);
        const mediaHTML = r.imageUrl ? `<div class="ri-media"><img src="${r.imageUrl}" alt="review-img" /></div>` : '';
        const dateStr = r.createdAt ? new Date(r.createdAt).toLocaleDateString('vi-VN') : 'Vừa xong';

        return `
      <div class="review-item" style="animation-delay:${Math.min(i * 0.05, 0.3)}s">
        <div class="ri-avatar" style="background:${avatarColor(r.userName || 'U')}">
            ${(r.userName || 'U').charAt(0).toUpperCase()}
        </div>
        <div class="ri-body">
          <div class="ri-top">
            <span class="ri-name">${r.fullName || 'Người dùng'} <small>(@${r.userName})</small></span>
            <div class="ri-stars">${starsHTML}</div>
            <span class="ri-date">${dateStr}</span>
          </div>
          <p class="ri-text">${r.content}</p>
          ${mediaHTML}
        </div>
      </div>`;
    }).join('');

    // 6. FIX: KÍCH HOẠT HIỆU ỨNG CUỘN
    // Nếu số lượng bình luận lớn hơn REVIEWS_PER_PAGE, bắt buộc hiện thanh cuộn
    if (sorted.length > REVIEWS_PER_PAGE) {
        reviewsScroll.style.maxHeight = '500px'; // Đặt chiều cao tối đa cho khung
        reviewsScroll.style.overflowY = 'auto';  // Bật thanh cuộn dọc
        reviewsScroll.style.paddingRight = '10px'; // Tránh việc thanh cuộn đè lên nội dung
    } else {
        reviewsScroll.style.maxHeight = 'none';  // Tự động giãn theo nội dung nếu ít
        reviewsScroll.style.overflowY = 'hidden'; // Ẩn thanh cuộn
        reviewsScroll.style.paddingRight = '0';
    }

    // 7. Cập nhật số lượng bình luận trên giao diện
    const countEl = document.getElementById('review-count');
    if (countEl) countEl.textContent = sorted.length;
}

// Lắng nghe sự kiện thay đổi kiểu sắp xếp
const sortSelect = document.getElementById('reviews-sort');
if (sortSelect) {
    sortSelect.addEventListener('change', renderReviews);
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
