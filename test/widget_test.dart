import 'package:flutter/material.dart';
import 'package:flutter_snippet/Widgets/bloc/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('BlocTest increments and decrements counter', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: BlocTest()));

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });
}
