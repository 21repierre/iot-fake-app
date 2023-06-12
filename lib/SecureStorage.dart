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

  Future setMqttHost(String host) async {
    await storage.write(key: 'mqtt-host', value: host);
  }

  Future<String?> getMqttHost() async {
    return await storage.read(key: 'mqtt-host');
  }

  Future setMqttPort(int port) async {
    await storage.write(key: 'mqtt-port', value: port.toString());
  }

  Future<int?> getMqttPort() async {
    return await storage.read(key: 'mqtt-port').then((value) => value != null ? int.parse(value) : null);
  }

  Future setMqttSecure(bool secure) async {
    await storage.write(key: 'mqtt-secure', value: secure.toString());
  }

  Future<bool?> getMqttSecure() async {
    return await storage.read(key: 'mqtt-secure').then((value) => value =='true' ? true : false);
  }

}