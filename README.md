# Cinema Management System

Hệ thống quản lý rạp chiếu phim — đặt vé, quản lý lịch chiếu, sơ đồ ghế.

---

## Tech Stack

| Thành phần | Công nghệ                   |
|---|-----------------------------|
| Backend | Java 21 + Spring Boot 3.x   |
| Frontend | HTML, CSS, JS               |
| Database | MySQL 8.x                   |
| ORM | Spring Data JPA + Hibernate |
| Xác thực | Spring Security + JWT       |
| Build tool | Maven                       |

---

## Cấu trúc dự án

```
cinema-project/
├── backend/                        # Spring Boot API
│   ├── src/main/java/com/cinema/
│   │   ├── config/                 # SecurityConfig, CorsConfig
│   │   ├── controller/             # REST endpoints
│   │   ├── service/                # Business logic + @Transactional
│   │   ├── repository/             # JPA, gọi Stored Procedure & View
│   │   ├── entity/                 # Ánh xạ bảng DB
│   │   ├── dto/                    # request/ và response/
│   │   ├── security/               # JwtFilter, UserPrincipal
│   │   └── exception/              # GlobalExceptionHandler
│   ├── src/main/resources/
│   │   └── application.properties  # Cấu hình đọc từ .env
│   └── pom.xml
│
├── frontend/                       # React SPA
│   ├── src/
│   │   ├── api/                    # axios client + các api module
│   │   ├── components/
│   │   │   ├── common/             # Header, Footer, Button, Modal
│   │   │   ├── movie/              # MovieCard, MovieList, MovieDetail
│   │   │   ├── booking/            # SeatMap, BookingForm, InvoiceCard
│   │   │   └── auth/               # LoginForm, RegisterForm
│   │   ├── pages/                  # Home, MovieDetail, Booking, Profile
│   │   ├── hooks/                  # useMovies, useSeatMap, useAuth
│   │   └── utils/                  # formatDate, formatPrice
│   ├── .env.example
│   ├── vite.config.js
│   └── package.json
│
├── database/
│   └── cinema.sql                  # Schema + stored procedure + trigger + view
├── .env.example                    # Mẫu biến môi trường
├── .env                            # Biến thật — KHÔNG commit lên git
├── .gitignore
└── README.md
```


## Yêu cầu môi trường

- Java 17+
- Node.js 18+
- MySQL 8.x
- Maven 3.8+


## Cài đặt & chạy

### 1. Clone repository

```bash
git clone <repo-url>
cd cinema-project
```

### 2. Cấu hình biến môi trường

```bash
cp .env.example .env
```

Mở `.env` và điền thông tin thực:

```env
DB_HOST=localhost
DB_PORT=3306
DB_NAME=cinema
DB_USERNAME=root
DB_PASSWORD=your_password

JWT_SECRET=your_secret_key_minimum_32_characters
JWT_EXPIRATION_MS=86400000

SERVER_PORT=8080
FRONTEND_URL=http://localhost:5173
```

### 3. Import database

```bash
mysql -u root -p < database/cinema.sql
```

### 4. Chạy Backend

```bash
cd backend
./mvnw spring-boot:run
```

API chạy tại: `http://localhost:8080`

### 5. Chạy Frontend

```bash
cd frontend
cp .env.example .env        # điền VITE_API_URL nếu cần
npm install
npm run dev
```

UI chạy tại: `http://localhost:5173`


## API Endpoints

### Auth

| Method | Endpoint | Mô tả |
|---|---|---|
| POST | `/api/auth/login` | Đăng nhập, trả về JWT token |
| POST | `/api/auth/register` | Đăng ký tài khoản |

### Phim

| Method | Endpoint | Mô tả |
|---|---|---|
| GET | `/api/movies` | Danh sách tất cả phim |
| GET | `/api/movies?status=showing` | Phim đang chiếu |
| GET | `/api/movies/{id}` | Chi tiết phim |

### Lịch chiếu & Ghế

| Method | Endpoint | Mô tả |
|---|---|---|
| GET | `/api/showtimes?movieId=1&date=2026-03-18` | Lịch chiếu theo phim |
| GET | `/api/seats/{showtimeId}` | Sơ đồ ghế theo suất |

### Đặt vé *(yêu cầu đăng nhập)*

| Method | Endpoint | Mô tả |
|---|---|---|
| POST | `/api/booking` | Đặt vé |
| DELETE | `/api/booking/{invoiceId}` | Hủy vé |
| GET | `/api/user/history` | Lịch sử đặt vé |

### Admin *(yêu cầu role ADMIN)*

| Method | Endpoint | Mô tả |
|---|---|---|
| GET | `/api/admin/revenue` | Báo cáo doanh thu |
| POST | `/api/admin/showtimes` | Tạo suất chiếu |


## Database Objects

| Loại | Tên | Mô tả |
|---|---|---|
| Procedure | `sp_get_available_seats` | Ghế trống theo suất chiếu |
| Procedure | `sp_get_showtime_by_movie` | Lịch chiếu còn vé |
| Procedure | `sp_get_revenue_by_cinema` | Doanh thu theo rạp |
| Procedure | `sp_release_expired_holds` | Giải phóng ghế quá hạn |
| Trigger | `trg_after_booking_seat_insert` | Cập nhật ghế → booked |
| Trigger | `trg_before_showtime_insert` | Chặn lịch chiếu trùng phòng |
| Trigger | `trg_after_invoice_insert` | Tăng used_count discount |
| Trigger | `trg_before_invoice_insert` | Validate mã giảm giá |
| View | `v_movie_details` | Phim + đạo diễn + thể loại + diễn viên |
| View | `v_now_showing` | Lịch chiếu hôm nay |
| View | `v_invoice_summary` | Tổng quan hóa đơn |
| View | `v_seat_map` | Sơ đồ ghế real-time |

---

## Tài khoản mặc định (dev)

| Role | Username | Password |
|---|---|---|
| Admin | `admin` | `admin123` |
| Nhân viên | `nhanvien` | `nv123` |

> Đổi password trước khi deploy lên production.


## Thành viên nhóm

| Họ tên | MSSV | Phân công |
|---|---|---|
| | | Backend — Auth, Booking |
| | | Backend — Movie, Showtime |
| | | Frontend — UI, SeatMap |
| | | Database — Schema, Procedure, Trigger |


## Ghi chú

- File `.env` chứa thông tin nhạy cảm, đã được thêm vào `.gitignore` và **không được commit lên git**.
- `spring.jpa.hibernate.ddl-auto=none` — Hibernate không tự tạo/xóa bảng, schema quản lý bằng `cinema.sql`.
- Ghế bị giữ quá 10 phút sẽ tự động được giải phóng thông qua `sp_release_expired_holds` chạy định kỳ.

