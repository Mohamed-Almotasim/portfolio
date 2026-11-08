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
    this.responseTime,
    this.resumeUrl,
    this.photo,
  });

  final String name;
  final String title;
  final String tagline;

  /// Plain text, shown under the hero statement. No emphasis markers.
  final String shortBio;
  final String location;
  final String email;
  final String availability;
  final List<SocialLink> socials;

  /// e.g. "Usually within one business day". Hidden when null.
  final String? responseTime;
  final String? resumeUrl;

  /// Asset path of a 4:5 portrait. Hidden when null.
  final String? photo;

  /// [socials] followed by a mailto link for [email].
  List<SocialLink> get contactLinks => [
    ...socials,
    SocialLink(label: 'Email', url: 'mailto:$email', icon: Icons.email),
  ];
}
