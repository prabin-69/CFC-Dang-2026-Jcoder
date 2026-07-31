import 'package:flutter_test/flutter_test.dart';
import 'package:worklink/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const WorkLinkApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.text('WorkLink'), findsOneWidget);
  });
}
