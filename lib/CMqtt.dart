import 'package:fake_sensor/SecureStorage.dart';
import 'package:flutter/cupertino.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class CMqtt {
  static final instance = CMqtt._();

  final MqttServerClient client;
  ValueNotifier<bool> isConnected = ValueNotifier(false);

  CMqtt._() : client = MqttServerClient.withPort("10.0.2.2", "fake-app-1", 8883) {
    client.secure = true;
    client.onBadCertificate = (Object certificate) => true;
    client.keepAlivePeriod = 20;
    client.setProtocolV311();
    client.logging(on: false);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
  }

  void connect() async {
    final token = await SecureStorage.instance.getToken();
    if (token == null || isConnected.value) return;

    final connectionMessage = MqttConnectMessage().authenticateAs(token, token);
    client.connectionMessage = connectionMessage;
    await client.connect();
  }

  void onConnected() {
    isConnected.value = true;
    print("Connected to MQTT server.");
  }

  void onDisconnected() {
    isConnected.value = false;
    print("Disconnected from MQTT server.");
  }
}
