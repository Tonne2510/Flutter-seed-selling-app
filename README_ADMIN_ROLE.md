# 🎯 Tính Năng Role-Based Access (Admin vs User) - Hướng Dẫn Hoàn Chỉnh

## 📌 Giới Thiệu

Dự án đã được cập nhật để hỗ trợ **phân quyền người dùng**:
- ✅ **Admin** (`admin@gmail.com`): Có quyền truy cập phần quản trị
- ✅ **User Thường**: Chỉ có quyền truy cập bình thường

---

## 🚀 Cài Đặt Nhanh

### Bước 1: Kiểm Tra Các Tệp Mới
```
✅ lib/controller/helper_classes/user_role_helper.dart (TẬP TIN MỚI)
✅ lib/models/resources.dart (ĐÃ CẬP NHẬT)
✅ lib/views/screens/log_in_screen.dart (ĐÃ CẬP NHẬT)
✅ lib/views/screens/sign_in_screen.dart (ĐÃ CẬP NHẬT)
✅ lib/views/components/drawer_component.dart (ĐÃ CẬP NHẬT)
```

### Bước 2: Chạy Ứng Dụng
```bash
flutter clean
flutter pub get
flutter run
```

---

## 🔍 Cách Kiểm Tra Tính Năng

### Test 1️⃣: Đăng Ký User Thường
```
1. Chạy ứng dụng
2. Nhấp "Đăng ký"
3. Nhập email: user@example.com
4. Nhập mật khẩu bất kỳ
5. Nhấp "Đăng ký"
6. Kết quả: Drawer hiển thị "User" (KHÔNG có phần quản trị)
```

### Test 2️⃣: Đăng Nhập Admin
```
1. Từ màn hình login, nhấp "Quay lại"
2. Nhấp "Đăng nhập"
3. Nhập email: admin@gmail.com
4. Nhập bất kỳ mật khẩu nào
5. Nhấp "Đăng nhập"
6. Kết quả: Drawer hiển thị "👤 Admin ⭐" (CÓ phần quản trị màu vàng)
```

---

## 📚 Tài Liệu Chi Tiết

| Tệp | Mô Tả |
|-----|-------|
| [ADMIN_ROLE_GUIDE.md](./ADMIN_ROLE_GUIDE.md) | Hướng dẫn đầy đủ về tính năng role-based |
| [CHANGES_SUMMARY.md](./CHANGES_SUMMARY.md) | Tóm tắt các thay đổi mã |
| [CODE_EXAMPLES.md](./CODE_EXAMPLES.md) | Ví dụ code sử dụng |

---

## 🏗️ Cấu Trúc Các Tệp

### `user_role_helper.dart` (Quản lý vai trò)
```dart
// Kiểm tra nếu user là admin
bool isAdmin = await UserRoleHelper.userRoleHelper.isAdmin();

// Lấy email hiện tại
String? email = UserRoleHelper.userRoleHelper.getCurrentUserEmail();

// Lưu vai trò vào Firestore
await UserRoleHelper.userRoleHelper.saveUserRole(
  email: 'user@example.com',
  role: 'user',
);

// Lấy vai trò từ Firestore
String role = await UserRoleHelper.userRoleHelper.getUserRole(
  email: 'user@example.com',
);
```

### Biến Global (`resources.dart`)
```dart
String? currentUserEmail;  // Email user đang đăng nhập
String userRole = 'user';  // 'admin' hoặc 'user'
```

### Kiểm Tra Vai Trò (Bất Kỳ Đâu)
```dart
if (userRole == 'admin') {
  // Hiển thị nội dung admin
} else {
  // Hiển thị nội dung user
}
```

---

## 🎨 Giao Diện Admin

Khi user đăng nhập với `admin@gmail.com`, drawer sẽ hiển thị:

```
┌─────────────────────────────┐
│  👤 Admin ⭐               │  ← Badge Admin
├─────────────────────────────┤
│ ♥ Favourite                 │
│ 👤 Users                    │
├─────────────────────────────┤
│ ⚙️ Quản lý sản phẩm          │  
│ 📊 Thống kê bán hàng         │  ← Admin Section
│ 👥 Quản lý người dùng        │  (Màu Vàng)
├─────────────────────────────┤
│ ⚙️ Settings                 │
│ 🛒 Orders                   │
│ ❓ Help                      │
└─────────────────────────────┘
```

---

## 🔐 Bảo Mật

### ⚠️ Lưu Ý
- Email `admin@gmail.com` được **hardcode** để test nhanh
- **Trong production**, cần:
  1. Lưu danh sách admin trong Firestore
  2. Sử dụng Firebase Cloud Functions để xác minh vai trò
  3. Thiết lập Firebase Security Rules

### Ví Dụ Firestore Structure
```
users/ (collection)
├── admin@gmail.com/ (document)
│   ├── email: "admin@gmail.com"
│   ├── role: "admin"
│   └── createdAt: 2026-01-03T10:00:00Z
└── user@example.com/ (document)
    ├── email: "user@example.com"
    ├── role: "user"
    └── createdAt: 2026-01-03T10:05:00Z
```

---

## 🎯 Các Bước Tiếp Theo (Optional)

### 1. Tạo Trang Admin
```dart
// lib/views/screens/admin_products_page.dart
// Quản lý sản phẩm

// lib/views/screens/admin_statistics_page.dart
// Xem thống kê bán hàng

// lib/views/screens/admin_users_page.dart
// Quản lý người dùng
```

### 2. Thêm Routes
```dart
// Trong main.dart
routes: {
  'adminProducts': (context) => AdminProductsPage(),
  'adminStats': (context) => AdminStatisticsPage(),
  'adminUsers': (context) => AdminUsersPage(),
  // ...
}
```

### 3. Kết Nối Menu
```dart
// Trong drawer_component.dart
if (userRole == 'admin')
  GestureDetector(
    onTap: () => Navigator.pushNamed(context, 'adminProducts'),
    child: // Quản lý sản phẩm
  ),
```

---

## 📖 Code Patterns

### Pattern 1: Kiểm Tra Vai Trò (Simple)
```dart
if (userRole == 'admin') {
  // Admin code
}
```

### Pattern 2: Widget Có Điều Kiện
```dart
if (userRole == 'admin')
  AdminPanel(),
else
  UserPanel(),
```

### Pattern 3: Async Check
```dart
bool isAdmin = await UserRoleHelper.userRoleHelper.isAdmin();
if (isAdmin) {
  // Handle admin
}
```

---

## 🆘 Troubleshooting

| Vấn Đề | Giải Pháp |
|--------|----------|
| Drawer không hiển thị admin | Kiểm tra `userRole == 'admin'` |
| Email không được lưu | Kiểm tra `currentUserEmail` sau login |
| Admin không nhận ra | Email phải chính xác là `admin@gmail.com` |
| Lỗi compile | Chạy `flutter clean` và `flutter pub get` |

---

## 📞 Hỗ Trợ

### Các Tệp Tham Khảo
- [Flutter GetX Documentation](https://pub.dev/packages/get)
- [Firebase Auth Docs](https://firebase.google.com/docs/auth)
- [Flutter State Management](https://flutter.dev/docs/development/data-and-backend/state-mgmt)

---

## ✅ Checklist Hoàn Thiện

- [x] Tạo `UserRoleHelper` class
- [x] Thêm biến global `userRole` và `currentUserEmail`
- [x] Cập nhật `LogInScreen` để lưu vai trò
- [x] Cập nhật `SignInScreen` để lưu vai trò
- [x] Thêm phần Admin vào Drawer
- [x] Tạo tài liệu hướng dẫn
- [ ] (Optional) Tạo trang quản lý admin
- [ ] (Optional) Thiết lập Firebase Security Rules

---

## 📝 Thông Tin Chi Tiết

**Phiên bản**: 1.0  
**Ngày cập nhật**: 01/03/2026  
**Flutter Version**: 3.0.0+  
**Dart Version**: 3.0.0+  

---

**🎉 Thành công! Ứng dụng đã sẵn sàng với tính năng Role-Based Access!**
