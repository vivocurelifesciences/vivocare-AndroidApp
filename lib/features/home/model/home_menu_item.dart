import 'package:flutter/material.dart';

class HomeMenuItem {
  const HomeMenuItem({
    required this.label,
    required this.icon,
    this.isActive = false,
  });

  final String label;
  final IconData icon;
  final bool isActive;
}
