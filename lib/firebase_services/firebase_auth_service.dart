import 'package:firebase_auth/firebase_auth.dart';
import 'package:focusflow/temp_user_db.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register with email and password
  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await result.user?.sendEmailVerification();
      // Kullanıcı başarıyla kaydedildiğinde aktif e-posta adresini UserDatabase'e atıyoruz
      if (result.user != null) {
        UserDatabase.activeEmail = result.user!.email ?? '';
      }
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception("An unexpected error occurred: ${e.toString()}");
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (result.user?.emailVerified == false) {
        await signOut();
        throw Exception("Please verify your email address.");
      }
      // Kullanıcı giriş yaptıktan sonra aktif e-posta adresini UserDatabase'e atıyoruz
      if (result.user != null) {
        UserDatabase.activeEmail = result.user!.email ?? '';
        await UserDatabase.loadRoutines();
      }

      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception("An unexpected error occurred: ${e.toString()}");
    }
  }

  // Common error handler for FirebaseAuthException
  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No user found for this email.');
      case 'wrong-password':
        return Exception('The password is incorrect.');
      case 'email-already-in-use':
        return Exception('The email is already registered.');
      case 'weak-password':
        return Exception('The password is too weak.');
      case 'invalid-email':
        return Exception('The email address is invalid.');
      default:
        return Exception('Authentication failed: ${e.message}');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      // Çıkış yapıldığında aktif e-posta adresini boşaltıyoruz
      UserDatabase.activeEmail = '';
    } catch (e) {
      throw Exception("Error signing out: ${e.toString()}");
    }
  }
}
