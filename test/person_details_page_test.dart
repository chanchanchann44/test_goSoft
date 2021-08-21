import 'package:employees_catalogue/data/api.dart';
import 'package:employees_catalogue/data/component.dart';
import 'package:employees_catalogue/person_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:employees_catalogue/data/extensions.dart';

import 'mock_classes.dart';

void main() {
  Component.instance.api = MockApi();
  final api = Component.instance.api;
  final int VALID_PERSON_ID = 1;
  final int INVALID_PERSON_ID = 111;

  when(api.getPerson(argThat(lessThan(INVALID_PERSON_ID)))).thenAnswer((realInvocation) => Api().getPerson(1));
  when(api.getPerson(argThat(greaterThanOrEqualTo(INVALID_PERSON_ID)))).thenAnswer((realInvocation) => null);

  Widget pageWithId(int personId) {
    return MaterialApp(home: PersonDetailsPage(personId: personId));
  }

  Widget pageWithProperId() {
    return pageWithId(VALID_PERSON_ID);
  }

  Widget pageWithInvalidId() {
    return pageWithId(INVALID_PERSON_ID);
  }

  testWidgets('shouldFinishWhenPersonWasNotFound', (WidgetTester tester) async {
    await tester.pumpWidget(pageWithInvalidId());

    await tester.pumpAndSettle();

    expect(find.byType(PersonDetailsPage), findsNothing);
  });

  testWidgets('shouldDisplayFullname', (WidgetTester tester) async {
    await tester.pumpWidget(pageWithProperId());

    await tester.pumpAndSettle();

    expect(find.text(api.getPerson(VALID_PERSON_ID).fullName), findsOneWidget);
  });

  testWidgets('shouldDisplayResponsibility', (WidgetTester tester) async {
    await tester.pumpWidget(pageWithProperId());

    await tester.pumpAndSettle();

    expect(find.text(api.getPerson(VALID_PERSON_ID).responsibility.toNameString()), findsOneWidget);
  });

  testWidgets('shouldDisplayRoom', (WidgetTester tester) async {
    await tester.pumpWidget(pageWithProperId());

    await tester.pumpAndSettle();

    expect(find.text(api.getPerson(VALID_PERSON_ID).room), findsOneWidget);
  });

  testWidgets('shouldDisplayPhoneNumber', (WidgetTester tester) async {
    await tester.pumpWidget(pageWithProperId());

    await tester.pumpAndSettle();

    expect(find.text(api.getPerson(VALID_PERSON_ID).phone), findsOneWidget);
  });

  testWidgets('shouldDisplayEmailAddress', (WidgetTester tester) async {
    await tester.pumpWidget(pageWithProperId());

    await tester.pumpAndSettle();

    expect(find.text(api.getPerson(VALID_PERSON_ID).email), findsOneWidget);
  });
}