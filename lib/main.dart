import 'package:calc/calc.dart';
import 'package:fake_sensor/CMqtt.dart';
import 'package:fake_sensor/LoginPage.dart';
import 'package:fake_sensor/MqttPage.dart';
import 'package:fake_sensor/SecureStorage.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT test app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      routes: {'login': (context) => LoginPage()},
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? token;
  double lastTemp = 25;

  @override
  void initState() {
    super.initState();
    SecureStorage.instance.getToken().then((value) => {
          setState(() {
            token = value;
          })
        });
    CMqtt.instance.connect(context);
    CMqtt.instance.send();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('IoT test app'),
      ),
      body: Center(
        child: Column(
          children: [
            if (token == null)
              TextButton(
                  onPressed: () => {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return LoginPage();
                        }))
                      },
                  child: const Text('Login'))
            else
              TextButton(
                  onPressed: () {
                    CMqtt.instance.client.disconnect();
                    SecureStorage.instance.deleteToken();
                    setState(() {
                      token = null;
                    });
                  },
                  child: const Text('Logout')),
            TextButton(
                onPressed: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                    return const MqttPage();
                  }))
                },
                child: const Text('Mqtt settings')),
            ValueListenableBuilder(
              valueListenable: CMqtt.instance.isConnected,
              builder: (BuildContext context, bool value, Widget? child) {
                if (value) {
                  return Column(
                    children: [
                      const Text("Connected to MQTT"),
                      TextButton(
                          onPressed: () {
                            MqttClientPayloadBuilder bdl = MqttClientPayloadBuilder();
                            var dist = NormalDistribution(mean: lastTemp, variance: 0.1);
                            lastTemp = dist.sample();
                            var currentTime = DateTime.now().microsecondsSinceEpoch * 1000;
                            bdl.addString('temperature lng=50.6113,lat=3.13487,value=$lastTemp $currentTime');
                            CMqtt.instance.client.publishMessage("icare/temperature", MqttQos.atLeastOnce, bdl.payload!);
                            print("Sent $lastTemp at $currentTime");
                          },
                          child: const Text("Send fake temperature"))
                    ],
                  );
                } else {
                  return const Text("Not connected to MQTT");
                }
              },
            ),

          ],
        ),
      ),
    );
  }
}
