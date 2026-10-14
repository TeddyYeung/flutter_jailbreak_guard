import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_guard/flutter_jailbreak_guard_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final platform = MethodChannelFlutterJailbreakGuard();
  const channel = MethodChannel('flutter_jailbreak_guard');
  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  void mockResult(Object? result) {
    messenger.setMockMethodCallHandler(channel, (methodCall) async {
      return methodCall.method == 'isJailbroken' ? result : null;
    });
  }

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
  });

  test('isJailbroken returns the native result', () async {
    mockResult(false);

    expect(await platform.isJailbroken(), isFalse);
  });

  test('isJailbroken throws PlatformException when the native result is null', () async {
    mockResult(null);

    expect(platform.isJailbroken(), throwsA(isA<PlatformException>()));
  });
}
