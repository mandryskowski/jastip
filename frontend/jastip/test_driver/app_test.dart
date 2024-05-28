import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_driver/flutter_driver.dart';

void main() {
  group('MyApp', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Check if app is running', () async {
      // Check if a specific widget is present on the screen
      expect(await driver.getText(find.text('Welcome')), 'Welcome');
    });

    // Add more integration tests as needed
  });
}