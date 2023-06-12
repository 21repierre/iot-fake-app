import 'package:fake_sensor/CMqtt.dart';
import 'package:fake_sensor/SecureStorage.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class MqttPage extends StatefulWidget {
  const MqttPage({super.key});

  @override
  State<MqttPage> createState() => _MqttPage();
}

class _MqttPage extends State<MqttPage> {
  TextEditingController host = TextEditingController();
  TextEditingController port = TextEditingController();
  bool secure = true;

  String loginError = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Mqtt settings'),
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: const Color.fromARGB(0, 0, 0, 0),
            child: IconButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const MyHomePage();
                      },
                    ),
                  );
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color.fromARGB(255, 0, 0, 0),
                )),
          )),
      body: Center(
        child: Form(
          child: Column(
            children: [
              TextField(
                controller: host,
                decoration: const InputDecoration(
                  labelText: 'Host',
                ),
              ),
              TextField(
                controller: port,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Port',
                ),
              ),
              CheckboxListTile(
                value: secure,
                onChanged: (bool? value) {
                  setState(() {
                    secure = value ?? true;
                  });
                },
                title: const Text("Secure"),
              ),
              TextButton(
                  onPressed: () => changeMqttServer(context), child: const Text('Save'))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> changeMqttServer(BuildContext context) async {
    if (host.text != "" && port.text != "") {
      var _port = int.parse(port.text);
      CMqtt.instance.client.disconnect();
      await SecureStorage.instance.setMqttHost(host.text);
      await SecureStorage.instance.setMqttPort(_port);
      await SecureStorage.instance.setMqttSecure(secure);
      CMqtt.instance.connect();
      Navigator.push(context, MaterialPageRoute(
        builder: (BuildContext context) {
          return const MyHomePage();
        },
      ),);
    }
  }
}
