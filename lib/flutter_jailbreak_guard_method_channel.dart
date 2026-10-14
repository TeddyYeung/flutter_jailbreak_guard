import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_guard/flutter_jailbreak_guard_platform_interface.dart';

class MethodChannelFlutterJailbreakGuard extends FlutterJailbreakGuardPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_jailbreak_guard');

  @override
  Future<bool> isJailbroken() async {
    final isJailbroken = await methodChannel.invokeMethod<bool>('isJailbroken');
    if (isJailbroken == null) {
      throw PlatformException(code: 'null_result', message: 'isJailbroken returned null.');
    }
    return isJailbroken;
  }
}
