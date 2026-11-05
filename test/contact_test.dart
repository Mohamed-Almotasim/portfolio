import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:portfolio/core/content/portfolio_content.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/features/contact/contact_mailto.dart';
import 'package:portfolio/features/contact/contact_page.dart';
import 'package:portfolio/shared/utils/link_launcher.dart';

import 'helpers/pump_app.dart';

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

    Future<void> pumpContact(WidgetTester tester) => pumpApp(
      tester,
      path: AppRoutes.contact,
      size: const Size(1280, 1800),
      overrides: [
        linkLauncherProvider.overrideWithValue((uri) async {
          launched.add(uri);
          return result();
        }),
      ],
    );

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
        find.text('If no email app opened, email me at ${profile.email}'),
        findsOneWidget,
      );
      expect(find.byTooltip('Copy email address'), findsNWidgets(2));
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

    group('with a Formspree endpoint', () {
      late List<http.Request> posted;

      Future<void> pumpForm(
        WidgetTester tester,
        Future<http.Response> Function() respond,
      ) => pumpApp(
        tester,
        path: AppRoutes.contact,
        size: const Size(1280, 1800),
        overrides: [
          contactFormEndpointProvider.overrideWithValue(
            'https://formspree.io/f/test',
          ),
          httpClientProvider.overrideWithValue(
            MockClient((req) {
              posted.add(req);
              return respond();
            }),
          ),
          linkLauncherProvider.overrideWithValue((uri) async {
            launched.add(uri);
            return true;
          }),
        ],
      );

      setUp(() => posted = []);

      Future<void> send(WidgetTester tester) async {
        await fillValid(tester);
        await tester.tap(find.text('Send message'));
        await tester.pump(const Duration(milliseconds: 300));
      }

      testWidgets('posts JSON and shows success, no mailto', (tester) async {
        await pumpForm(tester, () async => http.Response('{"ok":true}', 200));
        await send(tester);
        final req = posted.single;
        expect(req.url.toString(), 'https://formspree.io/f/test');
        expect(req.headers['Accept'], 'application/json');
        expect(jsonDecode(req.body), {
          'name': 'Ada',
          'email': 'ada@example.com',
          'projectType': 'New app',
          'message': 'I need an app.',
          '_subject': 'New app enquiry from Ada',
        });
        expect(launched, isEmpty);
        expect(find.textContaining('your message was sent'), findsOneWidget);
      });

      testWidgets('shows the error Formspree returns', (tester) async {
        await pumpForm(
          tester,
          () async => http.Response(
            '{"errors":[{"field":"email","message":"should be an email"}]}',
            422,
          ),
        );
        await send(tester);
        expect(find.textContaining('should be an email'), findsOneWidget);
      });

      testWidgets('a network failure shows an error with the address', (
        tester,
      ) async {
        await pumpForm(tester, () async => throw http.ClientException('down'));
        await send(tester);
        expect(
          find.textContaining("Couldn't reach the form service"),
          findsOneWidget,
        );
        expect(find.textContaining(profile.email), findsWidgets);
      });
    });
  });
}
