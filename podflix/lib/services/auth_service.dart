import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<void> saveUserCredentials(String email, String password) async {
    await _storage.write(key: 'user_email', value: email);
    await _storage.write(key: 'hashed_password', value: _hashPassword(password));
  }

  Future<bool> validateCredentials(String email, String password) async {
    final savedEmail = await _storage.read(key: 'user_email');
    final savedHash = await _storage.read(key: 'hashed_password');
    
    return savedEmail == email && savedHash == _hashPassword(password);
  }
}