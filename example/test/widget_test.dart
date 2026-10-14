import 'package:flutter/widgets.dart';
import 'package:flutter_jailbreak_guard_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the jailbreak status', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(
      find.byWidgetPredicate((widget) => widget is Text && widget.data!.startsWith('Status:')),
      findsOneWidget,
    );
  });
}
