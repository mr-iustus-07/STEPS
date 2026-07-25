import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/navigation_items.dart';
import '../../core/utils/responsive_helper.dart';
import '../../core/constants/app_colors.dart';

class AdaptiveScaffold extends StatelessWidget {
  final Widget child;
  final String currentPath; 
  
  const AdaptiveScaffold({
    super.key, 
    required this.child,
    required this.currentPath,
  });

  int _calculateSelectedIndex() {
    final index = AppNavigation.primaryItems.indexWhere((item) => currentPath.startsWith(item.route));
    return index >= 0 ? index : 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    context.go(AppNavigation.primaryItems[index].route);
  }

  @override
  Widget build(BuildContext context) {
    final int currentIndex = _calculateSelectedIndex();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final logoPath = isDark ? 'assets/logo_dark.png' : 'assets/logo_light.png';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveLayout(
        // --- MOBILE ---
        mobile: Column(
          children: [
            Expanded(child: child),
            Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border, width: 1)),
              ),
              child: BottomNavigationBar(
                currentIndex: currentIndex,
                backgroundColor: AppColors.background,
                selectedItemColor: AppColors.accent,
                unselectedItemColor: AppColors.textDisabled,
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                onTap: (index) => _onItemTapped(index, context),
                items: AppNavigation.primaryItems.map((item) => BottomNavigationBarItem(
                  icon: Icon(item.icon),
                  label: item.label,
                )).toList(),
              ),
            ),
          ],
        ),
        
        // --- TABLET ---
        tablet: Row(
          children: [
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected: (index) => _onItemTapped(index, context),
              backgroundColor: AppColors.background,
              selectedIconTheme: const IconThemeData(color: AppColors.accent),
              unselectedIconTheme: const IconThemeData(color: AppColors.textDisabled),
              labelType: NavigationRailLabelType.none,
              destinations: AppNavigation.primaryItems.map((item) => NavigationRailDestination(
                icon: Icon(item.icon),
                label: Text(item.label),
              )).toList(),
            ),
            const VerticalDivider(thickness: 1, width: 1, color: AppColors.border),
            Expanded(child: child),
          ],
        ),
        
        // --- DESKTOP: Sidebar ---
        desktop: Row(
          children: [
            Container(
              width: 240, // Slightly thinner for better content ratio
              color: AppColors.background,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔥 REDUCED LOGO SIZE & TIGHTENED SPACING
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, top: 32.0, bottom: 16.0),
                    child: Image.asset(
                      logoPath,
                      height: 100, // Reduced by ~15% to stop dominating the nav
                      fit: BoxFit.contain,
                      alignment: Alignment.centerLeft,
                      errorBuilder: (context, error, stackTrace) => Text(
                        'STEPS',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(AppNavigation.primaryItems.length, (index) {
                    final item = AppNavigation.primaryItems[index];
                    final isSelected = currentIndex == index;
                    return InkWell(
                      onTap: () => _onItemTapped(index, context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Tighter vertical grouping
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: isSelected ? AppColors.accent : Colors.transparent,
                              width: 3, // Slightly thinner indicator for elegance
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(item.icon, size: 20, color: isSelected ? AppColors.accent : AppColors.textDisabled),
                            const SizedBox(width: 16),
                            Text(
                              item.label,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isSelected ? AppColors.accent : AppColors.textDisabled,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const VerticalDivider(thickness: 1, width: 1, color: AppColors.border),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}