// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:epicture/field_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("fieldvalidator PIN", () {
    String fakePIN = "";
    expect(FieldValidator.validatePin(fakePIN), "test");
  });

  test("fieldValidator good PIN", () {
    String fakePin = "12345";
    expect(FieldValidator.validatePin(fakePin), null);
  });
}
