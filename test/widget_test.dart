import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:get_it/get_it.dart'; 
import 'package:countries_app/main.dart';
import 'package:countries_app/core/di/service_locator.dart'; 

void main() {

  setUp(() async {
    await GetIt.instance.reset();
  });

  testWidgets('App should initialize correctly', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await setupLocator(); 
    await tester.pumpWidget(MyApp(prefs: prefs));
    expect(find.byType(MyApp), findsOneWidget);
  });
}