import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:portfolio/core/content/portfolio_content.dart' as content;
import 'package:portfolio/core/content/profile.dart';
import 'package:portfolio/core/state/profile_provider.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/features/contact/contact_mailto.dart';
import 'package:portfolio/shared/layout/app_page.dart';
import 'package:portfolio/shared/utils/link_launcher.dart';

final contactProjectTypesProvider = Provider<List<String>>(
  (ref) => content.contactProjectTypes,
);
final contactBudgetsProvider = Provider<List<String>>(
  (ref) => content.contactBudgets,
);
final contactFormEndpointProvider = Provider<String?>(
  (ref) => content.contactFormEndpoint,
);

/// Override with a `MockClient` in tests.
final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

Future<void> _copyEmail(BuildContext context, String email) async {
  await Clipboard.setData(ClipboardData(text: email));
  if (context.mounted) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Email address copied')));
  }
}

/// Formspree's reason for a rejected submission, if the body has one.
String? _formspreeError(String body) {
  try {
    final json = jsonDecode(body);
    if (json case {'errors': [{'message': final String m}, ...]}) return m;
    if (json case {'error': final String m}) return m;
  } on FormatException {
    // Not JSON (proxy error page etc.); the caller falls back to the status.
  }
  return null;
}

class ContactPage extends ConsumerWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    return AppPage(
      title: 'Contact',
      child: LayoutBuilder(
        builder: (context, c) {
          final pitch = _Pitch(profile: profile);
          const form = _ContactForm();
          if (c.maxWidth < 860) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                pitch,
                const SizedBox(height: AppSpacing.s48),
                form,
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 4, child: pitch),
              const SizedBox(width: AppSpacing.s64),
              const Expanded(flex: 5, child: form),
            ],
          );
        },
      ),
    );
  }
}

class _Pitch extends ConsumerWidget {
  const _Pitch({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final deco = AppDecorations.of(context);
    Widget fact(IconData icon, String value, {Color? color}) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color ?? scheme.onSurfaceVariant),
          const SizedBox(width: AppSpacing.s12),
          Expanded(child: Text(value, style: text.bodyMedium)),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Let's talk about your app", style: text.headlineMedium),
        const SizedBox(height: AppSpacing.s12),
        Text(
          "Tell me what you're building and where you're stuck. I'll reply "
          "with how I'd approach it and what it would take.",
          style: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.s32),
        fact(Icons.circle, profile.availability, color: deco.success),
        if (profile.responseTime != null)
          fact(Icons.schedule, profile.responseTime!),
        fact(Icons.place_outlined, profile.location),
        const SizedBox(height: AppSpacing.s24),
        Container(
          padding: const EdgeInsets.only(left: AppSpacing.s16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: deco.cardBorder),
          ),
          child: Row(
            children: [
              Expanded(
                child: SelectableText(profile.email, style: text.titleMedium),
              ),
              IconButton(
                tooltip: 'Copy email address',
                icon: const Icon(Icons.copy, size: 18),
                onPressed: () => _copyEmail(context, profile.email),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s24),
        Wrap(
          spacing: AppSpacing.s8,
          children: [
            for (final s in profile.socials)
              IconButton.outlined(
                tooltip: s.label,
                icon: Icon(s.icon, semanticLabel: s.label),
                onPressed: () => openLink(context, ref, Uri.parse(s.url)),
              ),
          ],
        ),
      ],
    );
  }
}

enum _Status { idle, sending, sent, failed }

class _ContactForm extends ConsumerStatefulWidget {
  const _ContactForm();

  @override
  ConsumerState<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends ConsumerState<_ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();
  late String _projectType = ref.read(contactProjectTypesProvider).first;
  String? _budget;
  _Status _status = _Status.idle;
  String? _error; // why the form service rejected the message

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_status == _Status.sending) return; // no double submits
    if (!_formKey.currentState!.validate()) return;
    setState(() => _status = _Status.sending);
    final endpoint = ref.read(contactFormEndpointProvider);
    final String? error;
    if (endpoint != null) {
      error = await _post(endpoint);
    } else {
      final uri = contactMailto(
        to: ref.read(profileProvider).email,
        name: _name.text.trim(),
        email: _email.text.trim(),
        projectType: _projectType,
        budget: _budget,
        message: _message.text.trim(),
      );
      bool ok;
      try {
        ok = await ref.read(linkLauncherProvider)(uri);
      } on Exception {
        ok = false;
      }
      error = ok ? null : '';
    }
    if (mounted) {
      setState(() {
        _status = error == null ? _Status.sent : _Status.failed;
        _error = error;
      });
    }
  }

  /// Sends the form to Formspree. Returns null on success, else the reason.
  Future<String?> _post(String endpoint) async {
    final name = _name.text.trim();
    try {
      final res = await ref
          .read(httpClientProvider)
          .post(
            Uri.parse(endpoint),
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'name': name,
              'email': _email.text.trim(),
              'projectType': _projectType,
              'budget': ?_budget,
              'message': _message.text.trim(),
              '_subject': '$_projectType enquiry from $name',
            }),
          );
      if (res.statusCode >= 200 && res.statusCode < 300) return null;
      return _formspreeError(res.body) ??
          'The form service answered ${res.statusCode}.';
    } on Exception {
      return "Couldn't reach the form service.";
    }
  }

  String? _required(String? v, String message) =>
      (v == null || v.trim().isEmpty) ? message : null;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final budgets = ref.watch(contactBudgetsProvider);
    final sending = _status == _Status.sending;
    final viaForm = ref.watch(contactFormEndpointProvider) != null;
    final myEmail = ref.watch(profileProvider).email;

    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name'),
              autofillHints: const [AutofillHints.name],
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              validator: (v) => _required(v, 'Please enter your name'),
            ),
            const SizedBox(height: AppSpacing.s16),
            TextFormField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Email'),
              autofillHints: const [AutofillHints.email],
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (v) =>
                  _required(v, 'Please enter your email') ??
                  (_emailPattern.hasMatch(v!.trim())
                      ? null
                      : 'Please enter a valid email'),
            ),
            const SizedBox(height: AppSpacing.s24),
            Text('What kind of project?', style: text.labelLarge),
            const SizedBox(height: AppSpacing.s8),
            Wrap(
              spacing: AppSpacing.s8,
              runSpacing: AppSpacing.s8,
              children: [
                for (final t in ref.watch(contactProjectTypesProvider))
                  ChoiceChip(
                    label: Text(t),
                    selected: _projectType == t,
                    onSelected: (_) => setState(() => _projectType = t),
                  ),
              ],
            ),
            if (budgets.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.s24),
              DropdownButtonFormField<String>(
                initialValue: _budget,
                decoration: const InputDecoration(
                  labelText: 'Budget (optional)',
                ),
                items: [
                  for (final b in budgets)
                    DropdownMenuItem(value: b, child: Text(b)),
                ],
                onChanged: (v) => setState(() => _budget = v),
              ),
            ],
            const SizedBox(height: AppSpacing.s24),
            // Ctrl/Cmd+Enter sends from the multi-line message field.
            CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.enter, control: true):
                    _submit,
                const SingleActivator(LogicalKeyboardKey.enter, meta: true):
                    _submit,
              },
              child: TextFormField(
                controller: _message,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  alignLabelWithHint: true,
                  helperText: 'Ctrl + Enter to send',
                ),
                minLines: 5,
                maxLines: 10,
                keyboardType: TextInputType.multiline,
                validator: (v) =>
                    _required(v, 'Please tell me a little about the project'),
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
            FilledButton.icon(
              onPressed: sending ? null : _submit,
              icon: sending
                  ? const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send, size: 18),
              label: Text(
                !sending
                    ? 'Send message'
                    : viaForm
                    ? 'Sending…'
                    : 'Opening your email…',
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: switch (_status) {
                _Status.sent when viaForm => _Notice(
                  key: const ValueKey('sent'),
                  icon: Icons.check_circle_outline,
                  color: AppDecorations.of(context).success,
                  message:
                      "Thanks, your message was sent. I'll reply to "
                      '${_email.text.trim()}.',
                ),
                _Status.sent => _Notice(
                  key: const ValueKey('sent'),
                  icon: Icons.check_circle_outline,
                  color: AppDecorations.of(context).success,
                  message: 'If no email app opened, email me at $myEmail',
                  copyEmail: myEmail,
                ),
                _Status.failed => _Notice(
                  key: const ValueKey('failed'),
                  icon: Icons.error_outline,
                  color: scheme.error,
                  message: viaForm
                      ? "Couldn't send your message: $_error "
                            'Please email me at $myEmail instead.'
                      : "Couldn't open your email app. Please write to "
                            '$myEmail directly.',
                  copyEmail: myEmail,
                ),
                _ => const SizedBox.shrink(),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({
    super.key,
    required this.icon,
    required this.color,
    required this.message,
    this.copyEmail,
  });

  final IconData icon;
  final Color color;
  final String message;

  /// Shows a copy button for this address.
  final String? copyEmail;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: AppSpacing.s8),
          Expanded(
            child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
          ),
          if (copyEmail case final email?)
            IconButton(
              tooltip: 'Copy email address',
              icon: const Icon(Icons.copy, size: 18),
              onPressed: () => _copyEmail(context, email),
            ),
        ],
      ),
    );
  }
}
