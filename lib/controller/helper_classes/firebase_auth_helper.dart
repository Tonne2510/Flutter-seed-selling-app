import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthHelper {
  FirebaseAuthHelper._();

  static final FirebaseAuthHelper firebaseAuthHelper = FirebaseAuthHelper._();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //TODO : Sign In Anonymously
  Future<Map<String, dynamic>> SignInAnonymously() async {
    Map<String, dynamic> res = {};
    try {
      UserCredential? userCredential = await firebaseAuth.signInAnonymously();
      User? user = userCredential.user;
      res = {
        'user': user,
      };
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'operation-not-allowed':
          res = {'error': 'Máy chủ tạm thời ngừng hoạt động....'};
          break;
      }
    }

    return res;
  }

  //TODO :Sign Up With Email Password
  Future<Map<String, dynamic>> createUserWithEmailPassword(
      {required String? email, required String? password}) async {
    Map<String, dynamic> res = {};
    try {
      UserCredential? userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email!, password: password!);
      User? user = userCredential.user;
      res = {
        'user': user,
      };
    } on FirebaseAuthException catch (e) {
      print("-----------------------");
      print(e.code);
      print("-----------------------");
      switch (e.code) {
        case 'invalid-email':
          res = {'error': 'Email không hợp lệ....'};
          break;
        case 'weak-password':
          res = {'error': 'Mật khẩu của bạn quá yếu....'};
          break;
        case 'operation-not-allowed':
          res = {'error': 'Máy chủ tạm thời ngừng hoạt động....'};
          break;
        case 'email-already-in-use':
          res = {'error': 'Hãy sử dụng email khác....'};
          break;
      }
    }
    return res;
  }

  //TODO :Sign In With Email Password
  Future<Map<String, dynamic>> signInWithEmailPassword(
      {required String? email, required String? password}) async {
    Map<String, dynamic> res = {};
    try {
      UserCredential? userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email!, password: password!);
      User? user = userCredential.user;
      res = {
        'user': user,
        'email': user?.email,
      };
    } on FirebaseAuthException catch (e) {
      print("-----------------------");
      print(e.code);
      print("-----------------------");
      switch (e.code) {
        case 'invalid-email':
          res = {'error': 'Email không hợp lệ....'};
          break;
        case 'user-disabled':
          res = {'error': 'Tài khoản này đã bị vô hiệu hóa....'};
          break;
        case 'user-not-found':
          res = {'error': 'Email này chưa được đăng ký....'};
          break;
        case 'wrong-password':
          res = {'error': 'Mật khẩu không chính xác....'};
          break;
        case 'operation-not-allowed':
          res = {'error': 'Máy chủ tạm thời ngừng hoạt động....'};
          break;
      }
    }
    return res;
  }
}
