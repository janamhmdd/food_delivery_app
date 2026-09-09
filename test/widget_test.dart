import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery_app/core/di/service_locator.dart';
import 'package:food_delivery_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    setupGetIt();
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FoodDeliveryApp());
    // Pump past the 2-second splash timer
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
  });
}