import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_guard/flutter_jailbreak_guard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _status = 'Checking';

  @override
  void initState() {
    super.initState();
    _checkJailbreak();
  }

  Future<void> _checkJailbreak() async {
    String status;
    try {
      status = await FlutterJailbreakGuard.isJailbroken ? 'Jailbroken' : 'Not jailbroken';
    } on PlatformException catch (e) {
      status = 'Failed: ${e.code}';
    }

    if (!mounted) return;

    setState(() {
      _status = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('flutter_jailbreak_guard')),
        body: Center(child: Text('Status: $_status')),
      ),
    );
  }
}
