import 'package:flutter/material.dart';
import 'app_icons.dart'; // Using your previously created icons

class NavigationItem {
  final String label;
  final String route;
  final IconData icon;

  const NavigationItem({
    required this.label,
    required this.route,
    required this.icon,
  });
}

class AppNavigation {
  AppNavigation._();

  static const List<NavigationItem> primaryItems = [
    NavigationItem(label: 'Home', route: '/dashboard', icon: AppIcons.navDashboard),
    NavigationItem(label: 'Routines', route: '/routines', icon: AppIcons.navRoutines),
    NavigationItem(label: 'Tasks', route: '/tasks', icon: AppIcons.navTasks),
    NavigationItem(label: 'Calendar', route: '/calendar', icon: AppIcons.navCalendar),
  ];
}