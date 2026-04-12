// frontend/js/auth.js

const BASE_URL = "http://localhost:8080/api/auth";
const messageElement = document.getElementById('message');

// Hàm chính để xử lý gọi API Đăng ký
async function handleRegister(registerData) {
    try {
        // Gửi yêu cầu POST đến Backend Java
        const response = await fetch(`${BASE_URL}/register`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(registerData) // Chuyển đổi dữ liệu sang chuỗi JSON
        });

        const result = await response.json(); // Phân giải JSON từ AuthResponse của Java

        // Xử lý kết quả dựa trên mã trạng thái HTTP
        if (response.ok) {
            // Đăng ký thành công (Giống kết quả 200 OK trên Postman)
            messageElement.innerText = "Thành công: " + (result.message || "Đăng ký thành công!");
            messageElement.className = "success";
            console.log("Token nhận được:", result.token);

            // Lưu Token vào localStorage để dùng cho các request sau
            localStorage.setItem('accessToken', result.token);

            // Bạn có thể chuyển hướng sang trang đăng nhập sau vài giây
            setTimeout(() => {
                window.location.href = "login.html";
            }, 2000);
        } else {
            // Lỗi từ backend (ví dụ: username đã tồn tại)
            messageElement.innerText = "Lỗi: " + (result.message || "Đăng ký thất bại!");
            messageElement.className = "error";
        }
    } catch (error) {
        // Lỗi kết nối (ví dụ: server không chạy)
        console.error("Lỗi kết nối server:", error);
        messageElement.innerText = "Lỗi: Không thể kết nối đến server!";
        messageElement.className = "error";
    }
}