document.addEventListener('DOMContentLoaded', () => {
    const username = localStorage.getItem('username');
    const guestZone = document.getElementById('guest-zone');
    const userZone = document.getElementById('user-zone');
    const displayUsername = document.getElementById('display-username');

    if (username) {
        // Nếu có username trong localStorage -> Đã đăng nhập
        if (guestZone) guestZone.style.display = 'none';
        if (userZone) {
            userZone.style.display = 'block';
            displayUsername.textContent = username;
        }
    } else {
        // Nếu không có -> Hiển thị nút đăng ký/đăng nhập
        if (guestZone) guestZone.style.display = 'block';
        if (userZone) userZone.style.display = 'none';
    }
});

// Hàm đăng xuất
function logout() {
    localStorage.removeItem('username');
    localStorage.removeItem('token');
    window.location.reload(); // Load lại trang để cập nhật giao diện
}