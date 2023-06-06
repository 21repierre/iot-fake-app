import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  // Create storage
  final storage = const FlutterSecureStorage();

  static final instance = SecureStorage._();


  SecureStorage._();

  Future setToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  Future deleteToken() async {
    await storage.delete(key: 'token');
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }
}