import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Şu an giriş yapmış kullanıcı
  User? get currentUser => _firebaseAuth.currentUser;

  // Kullanıcı giriş/çıkış durumunu dinleme
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Kayıt olma
  Future<void> createUser({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Giriş yapma
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Çıkış yapma
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
