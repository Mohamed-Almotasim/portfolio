/// The prefilled email the contact form opens. Spaces are encoded as %20,
/// not '+', because several mail clients show '+' literally.
Uri contactMailto({
  required String to,
  required String name,
  required String email,
  required String projectType,
  required String message,
  String? budget,
}) {
  final body = [
    'Name: $name',
    'Email: $email',
    'Project: $projectType',
    if (budget != null) 'Budget: $budget',
    '',
    message,
  ].join('\n');
  final params = {'subject': '$projectType enquiry from $name', 'body': body};
  return Uri(
    scheme: 'mailto',
    path: to,
    query: params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&'),
  );
}
