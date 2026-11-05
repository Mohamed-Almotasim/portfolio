import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/app.dart';
import 'package:portfolio/core/content/portfolio_content.dart';
import 'package:portfolio/core/routing/app_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/features/contact/contact_mailto.dart';
import 'package:portfolio/shared/utils/link_launcher.dart';

void main() {
  group('contactMailto', () {
    test('addresses the profile email with a subject naming the sender', () {
      final uri = contactMailto(
        to: 'me@example.com',
        name: 'Ada',
        email: 'ada@example.com',
        projectType: 'New app',
        message: 'Hello',
      );
      expect(uri.scheme, 'mailto');
      expect(uri.path, 'me@example.com');
      expect(uri.queryParameters['subject'], 'New app enquiry from Ada');
    });

    test('puts every field in the body and skips a missing budget', () {
      final body = contactMailto(
        to: 'me@example.com',
        name: 'Ada',
        email: 'ada@example.com',
        projectType: 'New app',
        message: 'Line one\nLine two',
      ).queryParameters['body']!;
      expect(body, contains('ada@example.com'));
      expect(body, contains('Line one\nLine two'));
      expect(body, isNot(contains('Budget')));
    });

    test('includes the budget when given', () {
      final body = contactMailto(
        to: 'me@example.com',
        name: 'Ada',
        email: 'ada@example.com',
        projectType: 'New app',
        budget: 'Not sure yet',
        message: 'Hi',
      ).queryParameters['body']!;
      expect(body, contains('Budget: Not sure yet'));
    });
  });

  group('contact form', () {
    late List<Uri> launched;
    late FutureOr<bool> Function() result;

    Future<void> pumpContact(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            routerProvider.overrideWithValue(
              createRouter(initialLocation: AppRoutes.contact),
            ),
            linkLauncherProvider.overrideWithValue((uri) async {
              launched.add(uri);
              return result();
            }),
          ],
          child: const PortfolioApp(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));
    }

    Future<void> fillValid(WidgetTester tester) async {
      await tester.enterText(find.widgetWithText(TextFormField, 'Name'), 'Ada');
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'ada@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Message'),
        'I need an app.',
      );
    }

    setUp(() {
      launched = [];
      result = () => true;
    });

    testWidgets('empty submit shows a message per required field', (
      tester,
    ) async {
      await pumpContact(tester);
      await tester.tap(find.text('Send message'));
      await tester.pump();
      expect(find.text('Please enter your name'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(
        find.text('Please tell me a little about the project'),
        findsOneWidget,
      );
      expect(launched, isEmpty);
    });

    testWidgets('rejects an invalid email', (tester) async {
      await pumpContact(tester);
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'not-an-email',
      );
      await tester.tap(find.text('Send message'));
      await tester.pump();
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('valid submit opens a mailto and shows success', (
      tester,
    ) async {
      await pumpContact(tester);
      await fillValid(tester);
      await tester.tap(find.text('Send message'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(launched.single.scheme, 'mailto');
      expect(launched.single.path, profile.email);
      expect(
        find.textContaining('Your email app should now be open'),
        findsOneWidget,
      );
    });

    testWidgets('a failed launch shows an error with the address', (
      tester,
    ) async {
      result = () => false;
      await pumpContact(tester);
      await fillValid(tester);
      await tester.tap(find.text('Send message'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(
        find.textContaining("Couldn't open your email app"),
        findsOneWidget,
      );
    });

    testWidgets('a second tap while sending does not send twice', (
      tester,
    ) async {
      final pending = Completer<bool>();
      result = () => pending.future;
      await pumpContact(tester);
      await fillValid(tester);
      await tester.tap(find.text('Send message'));
      await tester.pump();
      await tester.tap(find.byType(FilledButton).last, warnIfMissed: false);
      await tester.pump();
      pending.complete(true);
      await tester.pump(const Duration(milliseconds: 300));
      expect(launched, hasLength(1));
    });
  });
}
