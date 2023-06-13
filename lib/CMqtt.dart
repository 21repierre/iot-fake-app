import 'package:calc/calc.dart';
import 'package:fake_sensor/DebugDialog.dart';
import 'package:fake_sensor/SecureStorage.dart';
import 'package:flutter/cupertino.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:geolocator/geolocator.dart';

class CMqtt {
  static final instance = CMqtt._();

  MqttServerClient client;
  ValueNotifier<bool> isConnected = ValueNotifier(false);
  bool sending = false;

  CMqtt._() : client = MqttServerClient.withPort("10.0.2.2", "", 8883) {
    client.secure = true;
    client.onBadCertificate = (Object certificate) => true;
    client.keepAlivePeriod = 20;
    client.setProtocolV311();
    client.logging(on: false);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
  }

  void connect(BuildContext context) async {
    String host = await SecureStorage.instance.getMqttHost() ?? '10.0.2.2';
    String token = await SecureStorage.instance.getToken() ?? '';
    int port = await SecureStorage.instance.getMqttPort() ?? 8883;
    bool secure = await SecureStorage.instance.getMqttSecure() ?? true;


    client = MqttServerClient.withPort(host, token, port);
    client.secure = secure;
    client.onBadCertificate = (Object certificate) => true;
    client.keepAlivePeriod = 20;
    client.setProtocolV311();
    client.logging(on: false);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;


    // final token = await SecureStorage.instance.getToken();
    String dbg = "Host: $host\nPort: $port\nSecure: $secure\nToken: $token\n";
    // showAlertDialog(context, "mqtt connect", dbg);

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

  void send() async {
    if (sending) return;
    double lastTemp = 25;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }
    sending = true;

    while (true) {
      if (CMqtt.instance.isConnected.value) {
        var position = await Geolocator.getCurrentPosition();

        MqttClientPayloadBuilder bdl = MqttClientPayloadBuilder();
        var dist = NormalDistribution(mean: lastTemp, variance: 0.001);
        lastTemp = dist.sample();
        var currentTime = DateTime.now().microsecondsSinceEpoch * 1000;
        bdl.addString('temperature lng=${position.longitude},lat=${position.latitude},value=$lastTemp $currentTime');
        CMqtt.instance.client.publishMessage("apolline/temperature", MqttQos.atLeastOnce, bdl.payload!);
        print("Sent $lastTemp at $currentTime");
      }
      await Future.delayed(const Duration(milliseconds: 250));
    }
  }

}
