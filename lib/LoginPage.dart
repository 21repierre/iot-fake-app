import 'dart:collection';
import 'dart:convert';

import 'package:fake_sensor/SecureStorage.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'main.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  TextEditingController baseUrl = TextEditingController(text: "http://10.0.2.2:5000");
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  String loginError = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Login'),
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
                controller: baseUrl,
                decoration: const InputDecoration(
                  labelText: 'Base url (no end /)',
                ),
              ),
              TextField(
                controller: username,
                decoration: InputDecoration(
                  labelText: 'Username/Email',
                  errorText: loginError != '' ? loginError : null,
                ),

              ),
              TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: loginError != '' ? loginError : null,
                ),
              ),
              TextButton(onPressed: () => login(context), child: const Text('Login'))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login(BuildContext context) async {
    if (username.text != '' && password.text != '' && baseUrl.text != '') {
      HashMap<String, String> datas = HashMap();
      datas.putIfAbsent("username", () => username.text);
      datas.putIfAbsent("password", () => password.text);
      var request = await http.post(
        Uri.parse('${baseUrl.text}/auth/signin'),
        headers: <String, String>{
        },
        body: datas,
      );

      var response = jsonDecode(request.body);
      if (response['Ok'] == true) {
        loginError = "";
        await SecureStorage.instance.setToken(response['token']);
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return const MyHomePage();
          },
        ),);
      } else {
        loginError = response['error'];
      }

    }
  }
}
