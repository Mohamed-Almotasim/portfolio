import 'package:flutter/material.dart';

class SocialLink {
  const SocialLink({
    required this.label,
    required this.url,
    required this.icon,
  });

  final String label;
  final String url;
  final IconData icon;
}

class Profile {
  const Profile({
    required this.name,
    required this.title,
    required this.tagline,
    required this.shortBio,
    required this.location,
    required this.email,
    required this.availability,
    required this.socials,
    this.resumeUrl,
  });

  final String name;
  final String title;
  final String tagline;

  /// Words wrapped in `*asterisks*` are rendered in the primary color.
  final String shortBio;
  final String location;
  final String email;
  final String availability;
  final List<SocialLink> socials;
  final String? resumeUrl;

  /// [socials] followed by a mailto link for [email].
  List<SocialLink> get contactLinks => [
    ...socials,
    SocialLink(label: 'Email', url: 'mailto:$email', icon: Icons.email),
  ];
}
