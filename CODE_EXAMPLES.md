# Code Examples - Cách Sử Dụng Role-Based Access

## 1. Kiểm Tra Vai Trò User ở Bất Kỳ Widget Nào

```dart
// Ở bất kỳ đâu trong ứng dụng
import 'package:ecommerce_app_firebase/models/resources.dart';

// Kiểm tra xem user có phải admin không
if (userRole == 'admin') {
  // Hiển thị nội dung admin
  print('Đây là admin');
} else {
  // Hiển thị nội dung user thường
  print('Đây là user thường');
}

// Lấy email user hiện tại
print('Email: $currentUserEmail');
```

---

## 2. Hiển Thị Nội Dung Có Điều Kiện Theo Vai Trò

```dart
import 'package:flutter/material.dart';
import 'package:ecommerce_app_firebase/models/resources.dart';

class MyCustomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hiển thị cho tất cả user
        Container(
          color: Colors.blue,
          child: Text('Nội dung dành cho mọi người'),
        ),
        
        // Chỉ hiển thị cho admin
        if (userRole == 'admin')
          Container(
            color: Colors.amber.shade100,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.admin_panel_settings),
                  title: Text('Quản lý sản phẩm'),
                  onTap: () {
                    // Điều hướng đến trang quản lý
                    Navigator.pushNamed(context, 'adminProducts');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.bar_chart),
                  title: Text('Thống kê'),
                  onTap: () {
                    Navigator.pushNamed(context, 'adminStats');
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
```

---

## 3. Kiểm Tra Admin Bằng Async

```dart
import 'package:ecommerce_app_firebase/controller/helper_classes/user_role_helper.dart';

// Nếu muốn kiểm tra theo thời gian thực từ Firestore
Future<void> checkAdminStatus() async {
  bool isAdmin = await UserRoleHelper.userRoleHelper.isAdmin();
  
  if (isAdmin) {
    print('User này là admin');
  } else {
    print('User này không phải admin');
  }
}
```

---

## 4. Thêm Logout Logic (Reset vai trò)

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce_app_firebase/models/resources.dart';

Future<void> logout() async {
  await FirebaseAuth.instance.signOut();
  
  // Reset các biến global
  person = null;
  currentUserEmail = null;
  userRole = 'user'; // Reset về user mặc định
  
  // Điều hướng về login
  Navigator.pushReplacementNamed(context, 'logSignPage');
}
```

---

## 5. Widget Có Quyền Hạn (Protected Widget)

```dart
import 'package:flutter/material.dart';
import 'package:ecommerce_app_firebase/models/resources.dart';

class AdminOnlyWidget extends StatelessWidget {
  final Widget adminWidget;
  final Widget userWidget;

  const AdminOnlyWidget({
    required this.adminWidget,
    required this.userWidget,
  });

  @override
  Widget build(BuildContext context) {
    return userRole == 'admin' ? adminWidget : userWidget;
  }
}

// Cách sử dụng:
AdminOnlyWidget(
  adminWidget: Container(
    color: Colors.amber,
    child: Text('Admin Panel'),
  ),
  userWidget: Container(
    color: Colors.blue,
    child: Text('Regular User'),
  ),
)
```

---

## 6. Thêm Vai Trò Mới (Advanced)

Nếu muốn thêm va trò khác ngoài 'admin' và 'user':

```dart
// Trong resources.dart, mở rộng:
String userRole = 'user'; // 'admin', 'user', 'moderator', ...

// Kiểm tra vai trò:
bool isAdmin = userRole == 'admin';
bool isModerator = userRole == 'moderator';
bool isRegularUser = userRole == 'user';
```

---

## 7. Lưu Vai Trò Vào Firestore (Khi Cần)

```dart
import 'package:ecommerce_app_firebase/controller/helper_classes/user_role_helper.dart';

// Lưu vai trò user
await UserRoleHelper.userRoleHelper.saveUserRole(
  email: 'user@example.com',
  role: 'admin', // hoặc 'user'
);

// Lấy vai trò từ Firestore
String userRoleFromDb = await UserRoleHelper.userRoleHelper.getUserRole(
  email: 'user@example.com',
);
print('Vai trò từ DB: $userRoleFromDb');
```

---

## 8. Kiểm Tra Email

```dart
import 'package:ecommerce_app_firebase/controller/helper_classes/user_role_helper.dart';

// Lấy email user hiện tại
String? userEmail = UserRoleHelper.userRoleHelper.getCurrentUserEmail();
print('Email: $userEmail');

// Hoặc từ global variable
print('Email: $currentUserEmail');
```

---

## 📝 Best Practices

1. **Luôn kiểm tra trước khi hiển thị nội dung admin**
   ```dart
   if (userRole == 'admin') {
     // Hiển thị tính năng admin
   }
   ```

2. **Reset vai trò khi logout**
   ```dart
   userRole = 'user';
   currentUserEmail = null;
   ```

3. **Sử dụng GetX/Provider cho state management lớn**
   ```dart
   // Thay vì global variable, sử dụng:
   class UserController extends GetxController {
     var userRole = 'user'.obs;
     var currentUserEmail = Rxn<String>();
   }
   ```

4. **Kiểm tra backend nếu bảo mật quan trọng**
   - Không chỉ dựa vào biến global
   - Sử dụng Firebase Security Rules để kiểm tra

---

**Ghi chú**: Các ví dụ này giả định bạn đã hiểu cơ bản về Flutter. Điều chỉnh theo nhu cầu dự án của bạn!
