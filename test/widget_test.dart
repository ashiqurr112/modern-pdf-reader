import 'package:flutter_test/flutter_test.dart';
import 'package:modern_pdf_reader/main.dart';
import 'package:modern_pdf_reader/core/di/service_locator.dart';

void main() {
  setUpAll(() {
    setupLocator();
  });

  testWidgets('App launches and displays title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the AppBar title is displayed.
    expect(find.text('PDF Reader'), findsOneWidget);
  });
}

