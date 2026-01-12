# 📝 Ghi Chú Quan Trọng - Role-Based Access

## 🔑 Key Points

### 1. Admin Email
```dart
// Hardcoded trong user_role_helper.dart
if (currentUser.email == 'admin@gmail.com') {
  // User này là admin
}
```
- **Email admin**: `admin@gmail.com`
- **Không phân biệt chữ hoa/thường**
- Có thể thay đổi hoặc thêm nhiều admin

---

### 2. Global Variables
```dart
// Trong resources.dart
String? currentUserEmail;  // Email user đang đăng nhập
String userRole = 'user';  // 'admin' hoặc 'user'
```
- Có thể truy cập từ **bất kỳ widget nào**
- Được set khi **đăng nhập/đăng ký thành công**
- Nên **reset khi logout**

---

### 3. Khi Nào Set Vai Trò?

| Sự Kiện | userRole | currentUserEmail |
|--------|----------|-----------------|
| Đăng ký user | "user" | Email vừa đăng ký |
| Đăng nhập admin | "admin" | "admin@gmail.com" |
| Đăng nhập user | "user" | Email đã đăng nhập |
| Logout | "user" | null |

---

### 4. Firestore Collection (Optional)

**Nếu bạn muốn lưu vai trò trong database**:

```
Database → users/ (collection)
           ├── admin@gmail.com/
           │   ├── email: "admin@gmail.com"
           │   ├── role: "admin"
           │   └── createdAt: timestamp
           └── user@example.com/
               ├── email: "user@example.com"
               ├── role: "user"
               └── createdAt: timestamp
```

**Lưu khi đăng ký**:
```dart
await UserRoleHelper.userRoleHelper.saveUserRole(
  email: email,
  role: 'user',
);
```

**Lấy từ DB**:
```dart
String role = await UserRoleHelper.userRoleHelper.getUserRole(
  email: 'user@example.com',
);
```

---

### 5. Các Hàm Chính

#### `isAdmin()` - Kiểm tra admin
```dart
bool isAdmin = await UserRoleHelper.userRoleHelper.isAdmin();
// Kiểm tra email hiện tại = "admin@gmail.com"
```

#### `getCurrentUserEmail()` - Lấy email
```dart
String? email = UserRoleHelper.userRoleHelper.getCurrentUserEmail();
// Hoặc từ global: currentUserEmail
```

#### `saveUserRole()` - Lưu vai trò
```dart
await UserRoleHelper.userRoleHelper.saveUserRole(
  email: 'user@example.com',
  role: 'user',
);
```

#### `getUserRole()` - Lấy vai trò từ DB
```dart
String role = await UserRoleHelper.userRoleHelper.getUserRole(
  email: 'user@example.com',
);
// Kết quả: 'admin', 'user', ...
```

---

## 🚨 Important Notes

### ⚠️ Bảo Mật
- **KHÔNG** để `admin@gmail.com` trong production
- **KHÔNG** dựa vào global variable cho quyền hạn cao
- **CÓ THỂ** để Firestore Security Rules kiểm soát truy cập
- **NÊNVÀ** sử dụng Backend (Cloud Functions) để xác minh

### 📦 State Management
Nếu ứng dụng lớn, nên dùng:
- **GetX**: `userRole.obs` (reactive)
- **Provider**: `ChangeNotifier`
- **Riverpod**: `StateNotifier`

### 🔄 Logout
**PHẢI** reset khi user logout:
```dart
void logout() {
  FirebaseAuth.instance.signOut();
  userRole = 'user';           // Reset
  currentUserEmail = null;     // Reset
}
```

---

## 📚 Code Patterns

### Pattern 1: Inline Check
```dart
if (userRole == 'admin') {
  // Admin code
}
```

### Pattern 2: Conditional Widget
```dart
userRole == 'admin' ? AdminWidget() : UserWidget()
```

### Pattern 3: Helper Function
```dart
bool canManageProducts() => userRole == 'admin';

if (canManageProducts()) {
  // Show manage button
}
```

### Pattern 4: Widget Wrapper
```dart
class AdminOnly extends StatelessWidget {
  final Widget child;
  
  const AdminOnly({required this.child});
  
  @override
  Widget build(BuildContext context) {
    return userRole == 'admin' ? child : SizedBox.shrink();
  }
}

// Dùng:
AdminOnly(
  child: ManageProductsButton(),
)
```

---

## 🎨 UI Changes

### Drawer Header
**Trước**: Chỉ hiển thị "User"
```
┌─────────────────┐
│ user@gmail.com  │
│      User       │
└─────────────────┘
```

**Sau (User)**:
```
┌─────────────────┐
│ user@gmail.com  │
│      User       │
└─────────────────┘
```

**Sau (Admin)**:
```
┌─────────────────┐
│ admin@gmail.com │
│ 👤 Admin ⭐     │
└─────────────────┘
```

### Admin Section
Màu vàng, chỉ hiển thị cho admin:
```
┌──────────────────────────┐
│ ⚙️ Quản lý sản phẩm      │
│ 📊 Thống kê bán hàng     │
│ 👥 Quản lý người dùng    │
└──────────────────────────┘
```

---

## 🔍 Debugging Tips

### Kiểm tra vai trò hiện tại
```dart
print('Role: $userRole');
print('Email: $currentUserEmail');
```

### Kiểm tra từ Firestore
```dart
var doc = await FirebaseFirestore.instance
  .collection('users')
  .doc('admin@gmail.com')
  .get();
print(doc['role']); // Output: 'admin'
```

### Kiểm tra Firebase Auth
```dart
print('Current User: ${FirebaseAuth.instance.currentUser?.email}');
print('UID: ${FirebaseAuth.instance.currentUser?.uid}');
```

---

## 📋 Checklist Trước Deploy

- [ ] Email admin không hardcode (nên lưu trong Firestore/Config)
- [ ] Firebase Security Rules được thiết lập
- [ ] Logout logic reset vai trò
- [ ] Backend xác minh vai trò (Cloud Functions)
- [ ] Database rules kiểm soát truy cập
- [ ] Tests được viết
- [ ] Tài liệu được cập nhật

---

## 🚀 Production Checklist

### Bảo Mật
- [ ] Sử dụng Firestore Rules
- [ ] Cloud Functions xác minh vai trò
- [ ] Không expose admin list
- [ ] Rate limiting trên admin APIs
- [ ] Logging cho admin actions

### Performance
- [ ] Cache vai trò (ngăn kiểm tra nhiều lần)
- [ ] Optimize Firestore queries
- [ ] Pagination cho admin views

### Monitoring
- [ ] Log khi user trở thành admin
- [ ] Alert nếu unauthorized access
- [ ] Track admin actions

---

## 📞 Common Questions

**Q: Làm sao để thêm admin khác?**
```dart
// Option 1: Hardcode multiple
if (email == 'admin@gmail.com' || email == 'admin2@gmail.com') {
  // Is admin
}

// Option 2: Firestore list
List admins = await getAdminEmails();
if (admins.contains(email)) {
  // Is admin
}
```

**Q: Làm sao để thay đổi vai trò runtime?**
```dart
// Update trong app
userRole = 'moderator';

// Update trong Firestore
await UserRoleHelper.userRoleHelper.saveUserRole(
  email: currentUserEmail ?? '',
  role: 'moderator',
);
```

**Q: Vai trò có reset khi restart app?**
```
Không. Nó lưu trong biến global.
Khi restart app, sẽ reset về 'user'.
Cần re-login để khôi phục vai trò.
```

**Q: Có thể cache vai trò?**
```dart
// Lưu vào SharedPreferences
await preferences.setString('userRole', userRole);

// Khôi phục khi app start
userRole = preferences.getString('userRole') ?? 'user';
```

---

## 📖 References

- [Firebase Auth Documentation](https://firebase.flutter.dev/docs/auth/overview/)
- [Flutter State Management](https://flutter.dev/docs/development/data-and-backend/state-mgmt)
- [GetX Package](https://pub.dev/packages/get)
- [Provider Package](https://pub.dev/packages/provider)

---

**Cập nhật lần cuối**: 01/03/2026  
**Phiên bản**: 1.0
