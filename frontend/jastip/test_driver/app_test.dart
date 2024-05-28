import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_driver/flutter_driver.dart' as Fd;

void main() {
  group('Jastip', () {
    late Fd.FlutterDriver driver;

    setUpAll(() async {
      driver = await Fd.FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Check if app is running', () async {
      // Check if a specific widget is present on the screen
      expect(await driver.getText(Fd.find.text('Welcome')), 'Welcome'); // Fully qualify find method
    });

    // Add more integration tests as needed
  });
}