import 'dart:async';

import 'package:flutter/material.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3_web.dart';

void main() async {
  await GRecaptchaV3.ready("6Lfl7coUAAAAAKUjryaKQDhrrklXE9yrvWNXqKTj");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _token = 'Click the refresh floating button to generate token';

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> getToken() async {
    String token;

    token = await GRecaptchaV3.execute('submit') ?? '';
    GRecaptchaV3Web.execute('submit');
    setState(() {
      _token = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Recaptcha V3 Web example app'),
        ),
        body: Center(
          child: SelectableText('Token: $_token\n'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: getToken,
          tooltip: 'Click to generate token',
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}
