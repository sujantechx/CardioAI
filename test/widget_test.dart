import 'package:flutter_test/flutter_test.dart';
import 'package:cardio_ai/app.dart';

void main() {
  testWidgets('CardioAI app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CardioAIApp());
    await tester.pump();
  });
}
