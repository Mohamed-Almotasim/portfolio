import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:portfolio/core/content/engagement_model.dart';
import 'package:portfolio/core/content/faq_item.dart';
import 'package:portfolio/core/content/portfolio_content.dart' as content;
import 'package:portfolio/core/content/portfolio_content_ar.dart' as ar;
import 'package:portfolio/core/content/profile.dart';
import 'package:portfolio/core/state/locale_provider.dart';
import 'package:portfolio/core/state/profile_provider.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_typography.dart';
import 'package:portfolio/features/contact/contact_mailto.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/shared/layout/app_page.dart';
import 'package:portfolio/shared/layout/inspectable.dart';
import 'package:portfolio/shared/utils/link_launcher.dart';
import 'package:portfolio/shared/widgets/app_section.dart';
import 'package:portfolio/shared/widgets/faq_accordion.dart';
import 'package:portfolio/shared/widgets/profile_photo.dart';

final contactProjectTypesProvider = Provider<List<String>>(
  (ref) => ref.watch(isArabicProvider)
      ? ar.contactProjectTypes
      : content.contactProjectTypes,
);
final contactBudgetsProvider = Provider<List<String>>(
  (ref) =>
      ref.watch(isArabicProvider) ? ar.contactBudgets : content.contactBudgets,
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).emailCopied)),
    );
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
    final text = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);
    return AppPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.s48),
          Semantics(
            header: true,
            child: Text(l10n.navContact, style: text.displayLarge),
          ),
          const SizedBox(height: AppSpacing.s16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Text(l10n.ctLead, style: AppTypography.lead(context)),
          ),
          const SizedBox(height: AppSpacing.s64),
          LayoutBuilder(
            builder: (context, c) {
              final pitch = _Pitch(profile: profile);
              const form = Inspectable(
                label: 'ContactForm',
                child: _ContactForm(),
              );
              if (c.maxWidth < 860) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    form,
                    const SizedBox(height: AppSpacing.s64),
                    pitch,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(flex: 7, child: form),
                  const SizedBox(width: AppSpacing.s64),
                  Expanded(flex: 4, child: pitch),
                ],
              );
            },
          ),
          AppSection(
            number: '01',
            title: l10n.waysToWork,
            child: const _Engagements(),
          ),
          AppSection(
            number: '02',
            title: l10n.ctQuestions,
            child: FaqAccordion(items: ref.watch(faqsProvider)),
          ),
        ],
      ),
    );
  }
}

final engagementModelsProvider = Provider<List<EngagementModel>>(
  (ref) => ref.watch(isArabicProvider)
      ? ar.engagementModels
      : content.engagementModels,
);
final faqsProvider = Provider<List<FaqItem>>(
  (ref) => ref.watch(isArabicProvider) ? ar.faqs : content.faqs,
);

/// Engagement models as ruled rows; a price shows only when one is set.
class _Engagements extends ConsumerWidget {
  const _Engagements();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final models = ref.watch(engagementModelsProvider);
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    final mute = text.labelMedium?.copyWith(color: deco.inkMute);
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        for (final (i, m) in models.indexed)
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s24),
            decoration: BoxDecoration(
              border: Border(
                top: i == 0 ? BorderSide.none : BorderSide(color: deco.rule),
              ),
            ),
            child: Wrap(
              spacing: AppSpacing.s48,
              runSpacing: AppSpacing.s12,
              children: [
                SizedBox(
                  width: 420,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.title, style: text.titleLarge),
                      const SizedBox(height: AppSpacing.s8),
                      Text(m.description, style: text.bodyLarge),
                    ],
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: Text(
                    l10n.ctBestFor(m.bestFor) +
                        (m.price == null ? '' : '\n${l10n.ctFrom(m.price!)}'),
                    style: mute?.copyWith(height: 1.8),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Pitch extends ConsumerWidget {
  const _Pitch({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    final l10n = AppLocalizations.of(context);
    Widget fact(String label, String value) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: text.labelSmall?.copyWith(color: deco.inkMute)),
          const SizedBox(height: AppSpacing.s4),
          Text(value, style: text.labelLarge),
        ],
      ),
    );

    return Inspectable(
      label: 'ContactFacts',
      child: Container(
        padding: const EdgeInsets.only(top: AppSpacing.s16),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: deco.ruleStrong)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // A face next to the address: who is going to reply.
            if (profile.photo != null) ...[
              const ProfilePhoto(width: 180),
              const SizedBox(height: AppSpacing.s32),
            ],
            Text(
              l10n.ctWriteDirectly,
              style: text.labelSmall?.copyWith(color: deco.inkMute),
            ),
            Row(
              children: [
                Flexible(
                  child: SelectableText(profile.email, style: text.titleMedium),
                ),
                IconButton(
                  tooltip: l10n.copyEmail,
                  icon: const Icon(Icons.copy, size: 18),
                  onPressed: () => _copyEmail(context, profile.email),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s16),
            fact(l10n.availability, profile.availability),
            if (profile.responseTime != null)
              fact(l10n.replies, profile.responseTime!),
            fact(l10n.basedIn, profile.location),
            Wrap(
              spacing: AppSpacing.s8,
              children: [
                for (final s in profile.socials)
                  TextButton(
                    onPressed: () => openLink(context, ref, Uri.parse(s.url)),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: Text('${s.label} ↗'),
                  ),
              ],
            ),
          ],
        ),
      ),
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
  // Indexes, not labels, so a pick survives a language switch.
  int _projectTypeIndex = 0;
  int? _budgetIndex;
  String get _projectType =>
      ref.read(contactProjectTypesProvider)[_projectTypeIndex];
  String? get _budget => _budgetIndex == null
      ? null
      : ref.read(contactBudgetsProvider)[_budgetIndex!];
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
    final l10n = AppLocalizations.of(context);
    final endpoint = ref.read(contactFormEndpointProvider);
    final String? error;
    if (endpoint != null) {
      error = await _post(endpoint, l10n);
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
  Future<String?> _post(String endpoint, AppLocalizations l10n) async {
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
      return _formspreeError(res.body) ?? l10n.ctServiceStatus(res.statusCode);
    } on Exception {
      return l10n.ctServiceUnreachable;
    }
  }

  String? _required(String? v, String message) =>
      (v == null || v.trim().isEmpty) ? message : null;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final types = ref.watch(contactProjectTypesProvider);
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
            _Labeled(
              label: l10n.name,
              child: TextFormField(
                key: const Key('field-Name'),
                controller: _name,
                autofillHints: const [AutofillHints.name],
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                validator: (v) => _required(v, l10n.ctNameRequired),
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            _Labeled(
              label: l10n.ctEmail,
              child: TextFormField(
                key: const Key('field-Email'),
                controller: _email,
                autofillHints: const [AutofillHints.email],
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    _required(v, l10n.ctEmailRequired) ??
                    (_emailPattern.hasMatch(v!.trim())
                        ? null
                        : l10n.ctEmailInvalid),
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
            Text(l10n.ctProjectKind, style: text.labelLarge),
            const SizedBox(height: AppSpacing.s8),
            Wrap(
              spacing: AppSpacing.s8,
              runSpacing: AppSpacing.s8,
              children: [
                for (final (i, t) in types.indexed)
                  ChoiceChip(
                    label: Text(t),
                    selected: _projectTypeIndex == i,
                    onSelected: (_) => setState(() => _projectTypeIndex = i),
                  ),
              ],
            ),
            if (budgets.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.s24),
              _Labeled(
                label: l10n.ctBudget,
                child: DropdownButtonFormField<int>(
                  initialValue: _budgetIndex,
                  hint: Text(l10n.ctBudgetHint),
                  items: [
                    for (final (i, b) in budgets.indexed)
                      DropdownMenuItem(value: i, child: Text(b)),
                  ],
                  onChanged: (v) => setState(() => _budgetIndex = v),
                ),
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
              child: _Labeled(
                label: l10n.ctMessage,
                child: TextFormField(
                  key: const Key('field-Message'),
                  controller: _message,
                  decoration: InputDecoration(helperText: l10n.ctMessageHelper),
                  minLines: 5,
                  maxLines: 10,
                  keyboardType: TextInputType.multiline,
                  validator: (v) => _required(v, l10n.ctMessageRequired),
                ),
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
                    ? l10n.ctSend
                    : viaForm
                    ? l10n.ctSending
                    : l10n.ctOpeningEmail,
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
                  message: l10n.ctSent(_email.text.trim()),
                ),
                _Status.sent => _Notice(
                  key: const ValueKey('sent'),
                  icon: Icons.check_circle_outline,
                  color: AppDecorations.of(context).success,
                  message: l10n.ctSentMailto(myEmail),
                  copyEmail: myEmail,
                ),
                _Status.failed => _Notice(
                  key: const ValueKey('failed'),
                  icon: Icons.error_outline,
                  color: scheme.error,
                  message: viaForm
                      ? l10n.ctFailedForm(_error ?? '', myEmail)
                      : l10n.ctFailedMailto(myEmail),
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
              tooltip: AppLocalizations.of(context).copyEmail,
              icon: const Icon(Icons.copy, size: 18),
              onPressed: () => _copyEmail(context, email),
            ),
        ],
      ),
    );
  }
}

/// A mono label above its field, so it stays visible once you type.
class _Labeled extends StatelessWidget {
  const _Labeled({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(
          child: Text(label, style: Theme.of(context).textTheme.labelLarge),
        ),
        const SizedBox(height: AppSpacing.s8),
        Semantics(label: label, child: child),
      ],
    );
  }
}
