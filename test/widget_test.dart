import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:temperature_converter_app/main.dart';

void main() {
  testWidgets('Temperature converter screen is displayed',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TemperatureConverterApp());

    expect(find.text('Temperature Converter'), findsOneWidget);
    expect(find.text('Calculate'), findsOneWidget);
    expect(find.text('Conversion Type'), findsOneWidget);
  });

  testWidgets('Converts Celsius to Fahrenheit', (WidgetTester tester) async {
    await tester.pumpWidget(const TemperatureConverterApp());

    await tester.tap(find.byType(DropdownButtonFormField<ConversionType>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Celsius to Fahrenheit (°C → °F)').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '100');
    await tester.tap(find.text('Calculate'));
    await tester.pump();

    expect(find.text('212.00 °F'), findsOneWidget);
  });

  testWidgets('Shows validation for empty input', (WidgetTester tester) async {
    await tester.pumpWidget(const TemperatureConverterApp());

    await tester.tap(find.text('Calculate'));
    await tester.pump();

    expect(find.text('Please enter a temperature value.'), findsOneWidget);
  });
}
