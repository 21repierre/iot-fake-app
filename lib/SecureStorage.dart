import 'dart:collection';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  // Create storage
  final storage = const FlutterSecureStorage();

  static final instance = SecureStorage._();

  final Map<String, String> iosValues = HashMap();

  SecureStorage._();

  Future setToken(String token) async {
    if (Platform.isIOS) {
      iosValues.update('token', (value) => token, ifAbsent: () => token);
      return;
    }
    await storage.write(key: 'token', value: token, aOptions: _getAndroidOptions(), iOptions: iosOptions);
  }

  Future deleteToken() async {
    if (Platform.isIOS) {
      iosValues.remove('token');
      return;
    }
    await storage.delete(key: 'token', aOptions: _getAndroidOptions(), iOptions: iosOptions);
  }

  Future<String?> getToken() async {
    if (Platform.isIOS) {
      return Future<String?>.value(iosValues.containsKey('token') ? iosValues['token'] : null);
    }
    return await storage.read(key: 'token', aOptions: _getAndroidOptions(), iOptions: iosOptions);
  }

  Future setMqttHost(String host) async {
    if (Platform.isIOS) {
      iosValues.update('mqtt-host', (value) => host, ifAbsent: () => host);
      return;
    }
    await storage.write(key: 'mqtt-host', value: host, aOptions: _getAndroidOptions(), iOptions: iosOptions);
  }

  Future<String?> getMqttHost() async {
    if (Platform.isIOS) {
      return Future<String?>.value(iosValues.containsKey('mqtt-host') ? iosValues['mqtt-host'] : null);
    }
    return await storage.read(key: 'mqtt-host', aOptions: _getAndroidOptions(), iOptions: iosOptions);
  }

  Future setMqttPort(int port) async {
    if (Platform.isIOS) {
      iosValues.update('mqtt-port', (value) => port.toString(), ifAbsent: () => port.toString());
      return;
    }
    await storage.write(key: 'mqtt-port', value: port.toString(), aOptions: _getAndroidOptions(), iOptions: iosOptions);
  }

  Future<int?> getMqttPort() async {
    if (Platform.isIOS) {
      return Future<int?>.value(iosValues.containsKey('mqtt-port') ? int.parse(iosValues['mqtt-port']!) : null);
    }
    return await storage.read(key: 'mqtt-port', aOptions: _getAndroidOptions(), iOptions: iosOptions).then((value) => value != null ? int.parse(value) : null);
  }

  Future setMqttSecure(bool secure) async {
    if (Platform.isIOS) {
      iosValues.update('mqtt-secure', (value) => secure.toString(), ifAbsent: () => secure.toString());
      return;
    }
    await storage.write(key: 'mqtt-secure', value: secure.toString(), aOptions: _getAndroidOptions(), iOptions: iosOptions);
  }

  Future<bool?> getMqttSecure() async {
    if (Platform.isIOS) {
      return Future<bool?>.value(iosValues.containsKey('mqtt-secure') ? iosValues['mqtt-secure'] == 'true' : null);
    }
    return await storage.read(key: 'mqtt-secure', aOptions: _getAndroidOptions(), iOptions: iosOptions).then((value) => value =='true' ? true : false);
  }

  final iosOptions = const IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );


}