# 💰 Sổ Chi Tiêu & Quỹ Tiết Kiệm Thông Minh (Smart Expense & Savings Planner)

Ứng dụng quản lý tài chính cá nhân và mục tiêu tiết kiệm thông minh được xây dựng bằng **Flutter & Dart**, phục vụ cho môn học **Lập trình thiết bị di động (LTTBDD)**.

---

## 🌳 Cấu Trúc Dự Án (Project Tree)

```text
lttbdd_group_app/
├── android/                        # Cấu hình dự án cho nền tảng Android
├── ios/                            # Cấu hình dự án cho nền tảng iOS
├── web/                            # Cấu hình dự án cho nền tảng Web
├── windows/                        # Cấu hình dự án cho nền tảng Windows Desktop
├── test/                           # Các bài unit test và widget test
├── pubspec.yaml                    # Quản lý dependencies và cấu hình dự án Flutter
├── firebase.json                   # Cấu hình FlutterFire CLI
│
└── lib/                            # Mã nguồn Dart chính của ứng dụng
    ├── main.dart                   # Điểm khởi chạy ứng dụng (main), cấu hình Theme & Providers
    ├── firebase_options.dart       # Cấu hình Firebase đa nền tảng (Web, Android, iOS, Windows)
    │
    ├── data/                       # Dữ liệu tĩnh và mock khởi tạo ban đầu
    │   └── initial_data.dart       # Dữ liệu mẫu ban đầu (danh mục chi tiêu, mục tiêu tiết kiệm)
    │
    ├── models/                     # Lớp định nghĩa đối tượng thực thể (Data Models)
    │   ├── models.dart             # Model: TransactionItem, ExpenseCategory, PresetItem, SavingsGoal
    │   └── user_model.dart         # Model: AppUser (thông tin tài khoản người dùng)
    │
    ├── providers/                  # Quản lý trạng thái ứng dụng (State Management với Provider)
    │   ├── auth_provider.dart      # Quản lý trạng thái xác thực: đăng nhập, đăng ký, phiên người dùng
    │   └── expense_provider.dart   # Quản lý giao dịch thu/chi, số dư, danh mục và quỹ tiết kiệm
    │
    ├── screens/                    # Giao diện người dùng (UI Screens)
    │   ├── login_screen.dart           # Màn hình Đăng nhập (hỗ trợ tài khoản mẫu)
    │   ├── register_screen.dart        # Màn hình Đăng ký tài khoản mới
    │   ├── main_navigation_screen.dart # Màn hình khung điều hướng chính (Bottom Navigation Bar)
    │   ├── home_screen.dart            # Màn hình Trang chủ (tổng quan số dư, thu chi gần đây, tiến độ quỹ)
    │   ├── categories_screen.dart      # Màn hình Quản lý danh mục thu/chi và hạn mức
    │   ├── category_detail_screen.dart # Màn hình Chi tiết giao dịch theo từng danh mục
    │   ├── analytics_screen.dart       # Màn hình Báo cáo & Phân tích trực quan tỷ trọng thu/chi
    │   ├── add_entry_screen.dart       # Màn hình Thêm giao dịch thu chi mới
    │   └── profile_screen.dart         # Màn hình Cá nhân (thông tin người dùng, cài đặt, đăng xuất)
    │
    ├── services/                   # Tầng dịch vụ logic nghiệp vụ (Services)
    │   └── auth_service.dart       # Dịch vụ xác thực người dùng (mô phỏng chuẩn Firebase Auth API)
    │
    └── utils/                      # Tiện ích bổ trợ (Utilities / Helpers)
        └── formatters.dart         # Tiện ích định dạng tiền tệ (VND) và ngày tháng chuẩn tiếng Việt
```

---

## ✨ Các Tính Năng Nổi Bật

1. **Xác thực người dùng (Authentication):**
   - Đăng nhập, đăng ký tài khoản với validation chặt chẽ.
   - Sẵn sàng tích hợp Firebase Authentication (hiện đang dùng AuthService mô phỏng).
2. **Tổng quan tài chính & Sổ thu chi (Dashboard & Transactions):**
   - Theo dõi tổng số dư, tổng thu, tổng chi trong tháng.
   - Danh sách lịch sử giao dịch trực quan, phân loại rõ ràng Thu / Chi.
   - Thêm nhanh các giao dịch mới kèm danh mục, ghi chú và mốc thời gian.
3. **Quản lý Quỹ tiết kiệm thông minh (Savings Fund Goals):**
   - Đặt mục tiêu tích lũy cụ thể (ví dụ: Mua laptop, Quỹ du lịch, v.v.).
   - Thanh tiến độ hiển thị phần trăm (%) hoàn thành mục tiêu trực quan.
4. **Báo cáo & Phân tích (Analytics):**
   - Thống kê tỷ trọng chi tiêu theo từng nhóm danh mục.
   - Giúp người dùng dễ dàng tối ưu hóa và kiểm soát ngân sách cá nhân.
5. **Giao diện hiện đại (Modern UI):**
   - Thiết kế theo chuẩn Google Material Design 3.
   - Bảng màu xanh lá tươi sáng, dịu mắt, tối ưu trải nghiệm người dùng di động.

---

## 🛠️ Công Nghệ Sử Dụng

- **Framework:** [Flutter](https://flutter.dev/) (phiên bản SDK >= 3.0.0)
- **Ngôn ngữ:** [Dart](https://dart.dev/)
- **Quản lý trạng thái:** `provider: ^6.1.2`
- **Định dạng dữ liệu:** `intl: ^0.19.0`
- **Nền tảng hỗ trợ:** Android, Web (Chrome, Edge), Windows Desktop, iOS.

---

## 🚀 Hướng Dẫn Cài Đặt & Chạy Ứng Dụng

### 1. Cài đặt dependencies
Mở Terminal tại thư mục dự án và chạy:
```bash
flutter pub get
```

### 2. Kiểm tra thiết bị khả dụng
```bash
flutter devices
```

### 3. Khởi chạy ứng dụng
- **Chạy trên trình duyệt Web (Chrome) - Nhanh nhất:**
  ```bash
  flutter run -d chrome
  ```
- **Chạy trên Windows Desktop:**
  ```bash
  flutter run -d windows
  ```
  *(Lưu ý: Bật Developer Mode trong Windows Settings nếu hệ thống yêu cầu)*
- **Chạy trên máy ảo / Thiết bị thật Android:**
  ```bash
  flutter run
  ```

---

## 🔑 Tài Khoản Đăng Nhập Kiểm Thử (Demo Accounts)

| Email | Mật khẩu | Vai trò |
| :--- | :--- | :--- |
| `demo@gmail.com` | `password123` | Người dùng trải nghiệm (Nguyễn Văn Demo) |
| `admin@sochitieu.vn` | `password123` | Quản trị / Chủ quỹ (Chủ Quỹ Thông Thái) |

*(Bạn cũng có thể bấm nút **"Đăng ký"** trên giao diện để tạo tài khoản mới)*
