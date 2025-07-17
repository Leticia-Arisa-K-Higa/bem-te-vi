// test/widget_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:bem_te_vi/main.dart';
import 'package:bem_te_vi/core/constants/app_strings.dart';
import 'package:bem_te_vi/core/database/app_database.dart';

void main() {
  testWidgets('HomeScreen loads and displays initial information', (
    WidgetTester tester,
  ) async {
    // This is a "mock" or fake version of your database for the test.
    final AppDatabase mockDatabase = AppDatabase();

    // Build the app and trigger a frame.
    // We pass the mock database just like in your real main.dart
    await tester.pumpWidget(MyApp(database: mockDatabase));

    // Verify that the title of the HomeScreen is displayed.
    expect(find.text(AppStrings.homeTitle), findsOneWidget);

    // You can also verify that the input fields are present.
    expect(find.text(AppStrings.patientNameLabel), findsOneWidget);
    expect(find.text(AppStrings.examinerNameLabel), findsOneWidget);
  });
}
