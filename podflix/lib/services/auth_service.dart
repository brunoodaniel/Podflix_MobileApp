import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AuthService {
  final _storage = const FlutterSecureStorage();
  
  /// Cria hash SHA-256 da senha
  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  /// Armazena credenciais de forma segura
  Future<void> saveUserCredentials(String email, String password) async {
    await _storage.write(
      key: 'user_credentials',
      value: json.encode({
        'email': email,
        'hashedPassword': _hashPassword(password),
      }),
    );
  }

  /// Valida credenciais armazenadas
  Future<bool> validateCredentials(String email, String password) async {
    final credentials = await _storage.read(key: 'user_credentials');
    if (credentials == null) return false;
    
    final data = json.decode(credentials);
    return data['email'] == email && 
           data['hashedPassword'] == _hashPassword(password);
  }

  /// Remove credenciais ao deslogar
  Future<void> clearCredentials() async {
    await _storage.delete(key: 'user_credentials');
  }
}