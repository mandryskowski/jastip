// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jastip/main.dart';

void main() {
  testWidgets('User is sent to the delivery page after 2 second loading phase', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    // Verify that we are on the delivery page.
    final currPage = find.byType(Scaffold);
    final currPageTitle = tester.widget<Text>(find.descendant(
      of: currPage,
      matching: find.byType(Text),
    ).first);

    expect(currPageTitle.data, 'JASTIP+');
  });
}
