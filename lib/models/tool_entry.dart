import 'package:flutter/material.dart';

enum ToolCategory {
  daily,
  query,
  calculator,
  text,
  image,
  device,
  file,
  thirdParty,
  other,
}

class ToolEntry {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final ToolCategory category;
  final WidgetBuilder? builder;
  final bool isPremium;
  final bool isOffline;
  final int sortOrder;

  const ToolEntry({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    this.builder,
    this.isPremium = false,
    this.isOffline = true,
    this.sortOrder = 0,
  });
}
