import 'package:flutter_jailbreak_guard/flutter_jailbreak_guard.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('isJailbroken returns a native result', (tester) async {
    expect(await FlutterJailbreakGuard.isJailbroken, isA<bool>());
  });
}
