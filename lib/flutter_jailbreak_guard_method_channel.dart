import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_guard/flutter_jailbreak_guard_platform_interface.dart';

class MethodChannelFlutterJailbreakGuard extends FlutterJailbreakGuardPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_jailbreak_guard');

  @override
  Future<bool> isJailbroken() => _invokeFailClosed('isJailbroken');

  @override
  Future<bool> isDeveloperMode() => _invokeFailClosed('isDeveloperMode');

  Future<bool> _invokeFailClosed(String method) async {
    final result = await methodChannel.invokeMethod<bool>(method);
    return result ?? true;
  }
}
