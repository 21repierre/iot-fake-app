import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  // Create storage
  final storage = const FlutterSecureStorage();

  static final instance = SecureStorage._();


  SecureStorage._();

  Future setToken(String token) async {
    await storage.write(key: 'token', value: token, aOptions: _getAndroidOptions(), iOptions: iosOptions);
  }

  Future deleteToken() async {
    await storage.delete(key: 'token', aOptions: _getAndroidOptions(), iOptions: iosOptions);
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token', aOptions: _getAndroidOptions(), iOptions: iosOptions);
  }

  Future setMqttHost(String host) async {
    await storage.write(key: 'mqtt-host', value: host, aOptions: _getAndroidOptions(), iOptions: iosOptions);
  }

  Future<String?> getMqttHost() async {
    return await storage.read(key: 'mqtt-host', aOptions: _getAndroidOptions(), iOptions: iosOptions);
  }

  Future setMqttPort(int port) async {
    await storage.write(key: 'mqtt-port', value: port.toString(), aOptions: _getAndroidOptions(), iOptions: iosOptions);
  }

  Future<int?> getMqttPort() async {
    return await storage.read(key: 'mqtt-port', aOptions: _getAndroidOptions(), iOptions: iosOptions).then((value) => value != null ? int.parse(value) : null);
  }

  Future setMqttSecure(bool secure) async {
    await storage.write(key: 'mqtt-secure', value: secure.toString(), aOptions: _getAndroidOptions(), iOptions: iosOptions);
  }

  Future<bool?> getMqttSecure() async {
    return await storage.read(key: 'mqtt-secure', aOptions: _getAndroidOptions(), iOptions: iosOptions).then((value) => value =='true' ? true : false);
  }

  final iosOptions = const IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );


}