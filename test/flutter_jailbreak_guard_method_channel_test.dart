import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_guard/flutter_jailbreak_guard_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final platform = MethodChannelFlutterJailbreakGuard();
  const channel = MethodChannel('flutter_jailbreak_guard');
  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  void mockResult({required String method, required Object? result}) {
    messenger.setMockMethodCallHandler(channel, (methodCall) async {
      return methodCall.method == method ? result : null;
    });
  }

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
  });

  test('isJailbroken returns the native result', () async {
    mockResult(method: 'isJailbroken', result: false);

    expect(await platform.isJailbroken(), isFalse);
  });

  test('isJailbroken returns true when the native result is null', () async {
    mockResult(method: 'isJailbroken', result: null);

    expect(await platform.isJailbroken(), isTrue);
  });

  test('isDeveloperMode returns the native result', () async {
    mockResult(method: 'isDeveloperMode', result: false);

    expect(await platform.isDeveloperMode(), isFalse);
  });

  test('isDeveloperMode returns true when the native result is null', () async {
    mockResult(method: 'isDeveloperMode', result: null);

    expect(await platform.isDeveloperMode(), isTrue);
  });
}
