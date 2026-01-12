import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRoleHelper {
  UserRoleHelper._();

  static final UserRoleHelper userRoleHelper = UserRoleHelper._();
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Check if current user is admin
  Future<bool> isAdmin() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      // Check if the current user's email is admin email
      if (currentUser.email == 'admin@gmail.com') {
        return true;
      }
      return false;
    } catch (e) {
      print('Error checking admin status: $e');
      return false;
    }
  }

  /// Get current user email
  String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }

  /// Save user role to Firestore
  Future<void> saveUserRole(
      {required String email, required String role}) async {
    try {
      await db.collection('users').doc(email).set({
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving user role: $e');
    }
  }

  /// Get user role from Firestore
  Future<String> getUserRole({required String email}) async {
    try {
      DocumentSnapshot doc = await db.collection('users').doc(email).get();
      if (doc.exists) {
        return doc['role'] ?? 'user';
      }
      return 'user';
    } catch (e) {
      print('Error getting user role: $e');
      return 'user';
    }
  }
}
