import 'package:flutter/material.dart';

/// A way to work together. [price] stays null unless you publish one.
class EngagementModel {
  const EngagementModel({
    required this.title,
    required this.description,
    required this.bestFor,
    required this.icon,
    this.price,
  });

  final String title;
  final String description;
  final String bestFor;
  final IconData icon;
  final String? price;
}
