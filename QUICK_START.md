# ⚡ Quick Start - Role-Based Access

## 🎯 Mục Tiêu
- Khi đăng nhập/đăng ký bằng `admin@gmail.com` → Hiển thị menu Admin
- Khi đăng nhập/đăng ký bằng email khác → Hiển thị menu User thường

---

## ✨ Thay Đổi Chính

### 1️⃣ Tệp Mới
```
📄 lib/controller/helper_classes/user_role_helper.dart
```

### 2️⃣ Tệp Sửa
```
📝 lib/models/resources.dart                    (+2 biến global)
📝 lib/views/screens/log_in_screen.dart        (lưu vai trò sau login)
📝 lib/views/screens/sign_in_screen.dart       (lưu vai trò sau signup)
📝 lib/views/components/drawer_component.dart  (hiển thị menu admin)
```

---

## 🧪 Test Ngay

### Test 1: User Thường
```bash
# 1. Chạy app: flutter run
# 2. Đăng ký: user@example.com / password123
# 3. Kết quả: Drawer hiển thị "User" (KHÔNG có menu admin)
```

### Test 2: Admin
```bash
# 1. Chạy app: flutter run
# 2. Đăng nhập: admin@gmail.com / password123
# 3. Kết quả: Drawer hiển thị "👤 Admin ⭐" (CÓ menu admin)
```

---

## 📖 Dùng Ở Đâu?

### Kiểm Tra Vai Trò
```dart
import 'package:ecommerce_app_firebase/models/resources.dart';

// Bất kỳ widget nào
if (userRole == 'admin') {
  // Hiển thị nội dung admin
} else {
  // Hiển thị nội dung user
}
```

### Lấy Email User
```dart
print(currentUserEmail); // "admin@gmail.com" hoặc "user@example.com"
```

### Kiểm Tra Admin (Async)
```dart
import 'package:ecommerce_app_firebase/controller/helper_classes/user_role_helper.dart';

bool isAdmin = await UserRoleHelper.userRoleHelper.isAdmin();
```

---

## 🎨 Kết Quả Hiển Thị

| User Thường | Admin |
|---|---|
| ![User](https://via.placeholder.com/150x200?text=User) | ![Admin](https://via.placeholder.com/150x200?text=Admin) |
| Drawer: "User" | Drawer: "👤 Admin ⭐" |
| KHÔNG menu admin | CÓ menu admin (vàng) |

---

## 📂 File Structure
```
lib/
├── controller/
│   └── helper_classes/
│       ├── firebase_auth_helper.dart    (cũ)
│       ├── firebase_firestore_helper.dart (cũ)
│       └── user_role_helper.dart        ✅ MỚI
├── models/
│   ├── resources.dart                   ✏️ CẬP NHẬT
│   └── ...
├── views/
│   ├── components/
│   │   └── drawer_component.dart        ✏️ CẬP NHẬT
│   ├── screens/
│   │   ├── log_in_screen.dart           ✏️ CẬP NHẬT
│   │   ├── sign_in_screen.dart          ✏️ CẬP NHẬT
│   │   └── ...
│   └── ...
└── main.dart
```

---

## 🚀 Tiếp Theo (Optional)

Để hoàn thiện, bạn có thể:

1. **Tạo trang admin** (nếu muốn):
   - Quản lý sản phẩm
   - Thống kê bán hàng
   - Quản lý user

2. **Thêm Firestore rules** (bảo mật):
   ```
   match /products/{document=**} {
     allow read: if true;
     allow write: if isAdmin();
   }
   ```

3. **Refactor state management** (cho ứng dụng lớn):
   - Dùng GetX thay vì global variable
   - Dùng Provider/Riverpod

---

## 📚 Tài Liệu

- **Chi tiết**: [ADMIN_ROLE_GUIDE.md](./ADMIN_ROLE_GUIDE.md)
- **Ví dụ code**: [CODE_EXAMPLES.md](./CODE_EXAMPLES.md)
- **Tóm tắt thay đổi**: [CHANGES_SUMMARY.md](./CHANGES_SUMMARY.md)

---

## ❓ FAQ

**Q: Admin email hardcode ở đâu?**  
A: Trong `user_role_helper.dart` line 17: `if (currentUser.email == 'admin@gmail.com')`

**Q: Làm sao để thêm admin khác?**  
A: Thay `==` bằng `contains()` hoặc kiểm tra Firestore

**Q: Vai trò được lưu ở đâu?**  
A: Biến global `userRole` trong `resources.dart`. Optionally lưu vào Firestore.

**Q: Làm sao logout?**  
A: Reset: `userRole = 'user'` và `currentUserEmail = null`

---

## ⏰ Thời Gian Hoàn Thiện
- ✅ Base setup: 5 phút
- ✅ Testing: 5 phút
- ✅ Mở rộng (optional): 30+ phút

---

**👍 Sẵn sàng rồi! Chúc bạn thành công!**
