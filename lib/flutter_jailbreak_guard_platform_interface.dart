import 'package:flutter_jailbreak_guard/flutter_jailbreak_guard_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class FlutterJailbreakGuardPlatform extends PlatformInterface {
  FlutterJailbreakGuardPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterJailbreakGuardPlatform _instance = MethodChannelFlutterJailbreakGuard();

  static FlutterJailbreakGuardPlatform get instance => _instance;

  static set instance(FlutterJailbreakGuardPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> isJailbroken() {
    throw UnimplementedError('isJailbroken() has not been implemented.');
  }

  Future<bool> isDeveloperMode() {
    throw UnimplementedError('isDeveloperMode() has not been implemented.');
  }
}
