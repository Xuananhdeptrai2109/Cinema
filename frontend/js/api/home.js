// ============================================================
// api/home.js — Tầng kết nối dữ liệu (Data Fetching)
// ============================================================

const BASE_URL = 'http://localhost:8080/api/home';

export const fetchHomeInitialData = async () => {
    try {
        const response = await fetch(`${BASE_URL}/init`);
        if (!response.ok) throw new Error(`Lỗi HTTP: ${response.status}`);

        const data = await response.json();
        console.log("Dữ liệu nhận từ API:", data);
        return data;
    } catch (error) {
        console.error("Lỗi kết nối Backend:", error);
        return null;
    }
};