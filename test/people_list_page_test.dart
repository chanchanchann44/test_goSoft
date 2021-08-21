import 'package:employees_catalogue/data/api.dart';
import 'package:employees_catalogue/data/component.dart';
import 'package:employees_catalogue/people_list_page.dart';
import 'package:employees_catalogue/main.dart';
import 'package:employees_catalogue/person_details_page.dart';
import 'package:employees_catalogue/widget_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:employees_catalogue/data/person.dart';
import 'package:mockito/mockito.dart';
import 'package:employees_catalogue/data/extensions.dart';

import 'mock_classes.dart';

void main() {
  Component.instance.api = MockApi();
  final api = Component.instance.api;

  when(api.searchPeople(query: anyNamed('query'), responsibility: anyNamed('responsibility')))
      .thenAnswer((realInvocation) => Api().searchPeople());
  when(api.searchPeople()).thenAnswer((realInvocation) => Api().searchPeople());
  when(api.searchPeople(
          query: anyNamed('query'),
          responsibility: argThat(equals(Responsibility.Accounting), named: 'responsibility')))
      .thenAnswer((realInvocation) => Api().searchPeople(responsibility: Responsibility.Accounting));
  when(api.searchPeople(query: argThat(equals('empty'), named: 'query'), responsibility: anyNamed('responsibility')))
      .thenAnswer((realInvocation) => []);
  when(api.getPerson(1)).thenAnswer((realInvocation) => Api().getPerson(1));

  testWidgets('shouldDisplayTheSameAmountOfPeopleAsInPeopleDataSourceSampleData', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.byKey(WidgetKey.listOfPeople), findsOneWidget);

    expect(find.byType(PersonItemWidget), findsNWidgets(api.searchPeople().length));
  });

  testWidgets('shouldDisplayFullnameAndResponsibilityOnListItems', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.byKey(WidgetKey.listOfPeople), findsOneWidget);

    api.searchPeople().forEach((element) {
      expect(find.descendant(of: find.byKey(WidgetKey.listOfPeople), matching: find.text(element.fullName)),
          findsOneWidget);
      expect(
          find.descendant(
              of: find.byKey(WidgetKey.listOfPeople), matching: find.text(element.responsibility.toNameString())),
          findsWidgets);
    });
  });

  testWidgets('shouldLaunchPersonDetailsOnRowClick', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.byKey(WidgetKey.listOfPeople), findsOneWidget);

    api.searchPeople().forEach((element) {
      expect(find.descendant(of: find.byKey(WidgetKey.listOfPeople), matching: find.text(element.fullName)),
          findsOneWidget);
      expect(
          find.descendant(
              of: find.byKey(WidgetKey.listOfPeople), matching: find.text(element.responsibility.toNameString())),
          findsWidgets);
    });

    await tester.tap(find.text(api.getPerson(1).fullName));

    await tester.pumpAndSettle();

    expect(find.byType(PersonDetailsPage), findsOneWidget);
  });

  testWidgets('shouldFilterListByResponsibility', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.byKey(WidgetKey.listOfPeople), findsOneWidget);
    expect(find.byKey(WidgetKey.filter), findsOneWidget);

    await tester.tap(find.byKey(WidgetKey.filter));

    await tester.pumpAndSettle();

    expect(find.byType(typeOf<PopupMenuItem<Responsibility>>()), findsNWidgets(6));
    await tester.tap(find.descendant(
        of: find.byType(typeOf<PopupMenuItem<Responsibility>>()),
        matching: find.text(Responsibility.Accounting.toNameString())));

    await tester.pumpAndSettle();

    expect(
        find.descendant(
            of: find.byKey(WidgetKey.listOfPeople), matching: find.text(Responsibility.Accounting.toNameString())),
        findsOneWidget);
    expect(
        find.descendant(
            of: find.byKey(WidgetKey.listOfPeople), matching: find.text(Responsibility.DevOps.toNameString())),
        findsNothing);
  });

  testWidgets('showPeopleThatNameContainsQuery', (WidgetTester tester) async {
    when(api.searchPeople(query: argThat(equals('bur'), named: 'query'), responsibility: anyNamed('responsibility')))
        .thenAnswer((realInvocation) => Api().searchPeople(query: 'bur'));

    await tester.pumpWidget(MyApp());
    await tester.tap(find.byType(LeadingWidget));
    await tester.pump(Duration(milliseconds: 400));
    expect(find.byKey(WidgetKey.search), findsOneWidget);

    await tester.enterText(find.byKey(WidgetKey.search), 'bur');

    await tester.pumpAndSettle();
    expect(find.byWidgetPredicate((widget) {
      if (widget is Text) {
        final Text textWidget = widget;
        if (textWidget.data != null) return textWidget.data.contains('Bur');
        return textWidget.textSpan.toPlainText().contains('Bur');
      }
      return false;
    }), findsNWidgets(2));
  });
}

Type typeOf<T>() => T;