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
  String _jailbreakStatus = 'Checking';
  String _developerModeStatus = 'Checking';

  @override
  void initState() {
    super.initState();
    _checkDevice();
  }

  Future<void> _checkDevice() async {
    final jailbreakStatus = await _describe(
      check: () => FlutterJailbreakGuard.isJailbroken,
      onTrue: 'Jailbroken',
      onFalse: 'Not jailbroken',
    );
    final developerModeStatus = await _describe(
      check: () => FlutterJailbreakGuard.isDeveloperMode,
      onTrue: 'On',
      onFalse: 'Off',
    );

    if (!mounted) return;

    setState(() {
      _jailbreakStatus = jailbreakStatus;
      _developerModeStatus = developerModeStatus;
    });
  }

  Future<String> _describe({
    required Future<bool> Function() check,
    required String onTrue,
    required String onFalse,
  }) async {
    try {
      return await check() ? onTrue : onFalse;
    } on PlatformException catch (e) {
      return 'Failed: ${e.code}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('flutter_jailbreak_guard')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Status: $_jailbreakStatus'),
              Text('Developer mode: $_developerModeStatus'),
            ],
          ),
        ),
      ),
    );
  }
}
