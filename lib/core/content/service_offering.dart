import 'package:flutter/material.dart';

class ServiceOffering {
  const ServiceOffering({
    required this.title,
    required this.description,
    required this.deliverables,
    required this.icon,
  });

  final String title;
  final String description;
  final List<String> deliverables;
  final IconData icon;
}
