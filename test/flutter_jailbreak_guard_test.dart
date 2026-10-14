import 'package:flutter_jailbreak_guard/flutter_jailbreak_guard.dart';
import 'package:flutter_jailbreak_guard/flutter_jailbreak_guard_method_channel.dart';
import 'package:flutter_jailbreak_guard/flutter_jailbreak_guard_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class FakeFlutterJailbreakGuardPlatform with MockPlatformInterfaceMixin implements FlutterJailbreakGuardPlatform {
  @override
  Future<bool> isJailbroken() => Future.value(true);
}

void main() {
  final initialPlatform = FlutterJailbreakGuardPlatform.instance;

  test('$MethodChannelFlutterJailbreakGuard is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterJailbreakGuard>());
  });

  test('isJailbroken delegates to the platform instance', () async {
    FlutterJailbreakGuardPlatform.instance = FakeFlutterJailbreakGuardPlatform();

    expect(await FlutterJailbreakGuard.isJailbroken, isTrue);
  });
}
