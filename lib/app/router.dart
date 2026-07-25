import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:steps/features/calender/presentation/pages/calendar_page.dart';

// Correct imports mapping to our new architecture
import '../shared/widgets/adaptive_scaffold.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/tasks/presentation/pages/tasks_page.dart';
import '../features/routines/presentation/pages/routines_page.dart';


// Create global keys for the root navigator
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

// Riverpod Provider for the Router
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/dashboard',
    routes: [
      // 1. MUST use ShellRoute here
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          // 2. Return the new AdaptiveScaffold, passing the active page as the child
          return AdaptiveScaffold(
            currentPath: state.uri.path, // Pass the current
            child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            // 3. Replaced Placeholder with the real Mission Control Dashboard
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: '/routines',
            name: 'routines',
            builder: (context, state) => const RoutinesPage(),
          ),
          GoRoute(
            path: '/tasks',
            name: 'tasks',
            builder: (context, state) => const TasksPage(),
          ),
          GoRoute(
            path: '/calendar',
            name: 'calendar',
            builder: (context, state) => const CalendarPage(),
          ),
        ],
      ),
      
      // Routes outside the ShellRoute (e.g., Settings, Full-screen modals)
      GoRoute(
        path: '/settings',
        name: 'settings',
        parentNavigatorKey: _rootNavigatorKey, // Takes up the whole screen, hiding bottom nav
        builder: (context, state) => const PlaceholderPage(title: 'Settings', hasBack: true),
      ),
    ],
  );
});

// ============================================================================
// TEMPORARY WIDGETS 
// (MainScaffold has been completely deleted. Only Placeholder remains.)
// ============================================================================

class PlaceholderPage extends StatelessWidget {
  final String title;
  final bool hasBack;
  const PlaceholderPage({super.key, required this.title, this.hasBack = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: hasBack 
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ) 
          : null,
        actions: [
          if (!hasBack) 
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => context.push('/settings'),
            )
        ],
      ),
      body: Center(
        child: Text(
          '$title Feature\nBuilding in Progress...',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}