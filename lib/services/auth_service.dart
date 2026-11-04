import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth;
  final FlutterSecureStorage storage;

  AuthService({
    FirebaseAuth? auth,
    FlutterSecureStorage? storage,
  })  : _auth = auth ?? FirebaseAuth.instance,
        storage = storage ?? const FlutterSecureStorage();

  Future<String?> createUser(
    String nombre,
    String apellido,
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        return 'Firebase no creó el usuario.';
      }

      await user.updateDisplayName('$nombre $apellido');
      await user.sendEmailVerification();
      await _saveSession(user);
      return null;
    } on FirebaseAuthException catch (error) {
      return _messageFor(error);
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        return 'Firebase no devolvió el usuario autenticado.';
      }
      if (!user.emailVerified) {
        await _auth.signOut();
        return 'El correo electrónico no ha sido verificado. Por favor, verifica tu correo antes de iniciar sesión.';
      }

      await _saveSession(user);
      return null;
    } on FirebaseAuthException catch (error) {
      return _messageFor(error);
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final user = _auth.currentUser;
    if (user == null) {
      return null;
    }

    return {
      'displayName': user.displayName ?? '',
      'email': user.email ?? '',
      'createdAt': user.metadata.creationTime?.millisecondsSinceEpoch
              .toString() ??
          '',
      'localId': user.uid,
      'emailVerified': user.emailVerified,
    };
  }

  Future<void> logout() async {
    await _auth.signOut();
    await storage.delete(key: 'token');
    await storage.delete(key: 'refreshToken');
    await storage.delete(key: 'userId');
  }

  Future<String> readToken() async {
    final user = _auth.currentUser;
    if (user != null) {
      final token = await user.getIdToken();
      if (token != null && token.isNotEmpty) {
        await storage.write(key: 'token', value: token);
        return token;
      }
    }
    return await storage.read(key: 'token') ?? '';
  }

  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (error) {
      return _messageFor(error);
    }
  }

  Future<void> _saveSession(User user) async {
    final token = await user.getIdToken();
    await storage.write(key: 'token', value: token);
    await storage.write(key: 'userId', value: user.uid);
  }

  String _messageFor(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-credential':
      case 'invalid-email':
      case 'user-not-found':
      case 'wrong-password':
        return 'El correo electrónico o la contraseña son incorrectos.';
      case 'user-disabled':
        return 'Esta cuenta está deshabilitada.';
      case 'email-already-in-use':
        return 'Ese correo electrónico ya está registrado.';
      case 'weak-password':
        return 'La contraseña es demasiado débil.';
      case 'network-request-failed':
        return 'No hay conexión con Firebase.';
      default:
        return error.message ?? 'No se pudo completar la autenticación.';
    }
  }
}
