import 'package:flutter_jailbreak_guard/flutter_jailbreak_guard_platform_interface.dart';

class FlutterJailbreakGuard {
  const FlutterJailbreakGuard._();

  static Future<bool> get isJailbroken => FlutterJailbreakGuardPlatform.instance.isJailbroken();

  static Future<bool> get isDeveloperMode => FlutterJailbreakGuardPlatform.instance.isDeveloperMode();
}
