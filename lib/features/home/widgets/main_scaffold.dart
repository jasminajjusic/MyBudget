import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybudget/features/routing/app_routes.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getSelectedIndex(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Column(children: [Expanded(child: child)]),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Color.fromARGB(255, 252, 248, 248),
                width: 1,
              ),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) => _onItemTapped(context, index),
            backgroundColor: Colors.transparent,
            unselectedItemColor: Colors.grey,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(fontSize: 12, height: 1.5),
            unselectedLabelStyle: const TextStyle(fontSize: 12, height: 1.5),
            iconSize: 24,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: _customIconWithLabel(
                  'assets/icons/home.svg',
                  currentIndex == 0,
                  'assets/icons/home.svg',
                  'Home',
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _customIconWithLabel(
                  'assets/icons/statistics.svg',
                  currentIndex == 1,
                  'assets/icons/statistics.svg',
                  'Stats',
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _customIconWithLabel(
                  'assets/icons/goals.svg',
                  currentIndex == 2,
                  'assets/icons/goals.svg',
                  'Goals',
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _customIconWithLabel(
                  'assets/icons/settings.svg',
                  currentIndex == 3,
                  'assets/icons/settings.svg',
                  'Settings',
                ),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getSelectedIndex(BuildContext context) {
    final state = GoRouter.of(context).routerDelegate.currentConfiguration;

    if (state.uri.path.startsWith(AppRoutes.home) == true) return 0;
    if (state.uri.path.startsWith(AppRoutes.statistics) == true) return 1;
    if (state.uri.path.startsWith(AppRoutes.goals) == true) return 2;
    if (state.uri.path.startsWith(AppRoutes.settings) == true) return 3;

    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/statistics');
        break;
      case 2:
        context.go('/goals');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }

  Widget _customIconWithLabel(
    String assetPath,
    bool isSelected,
    String? selectedAssetPath,
    String label,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          isSelected && selectedAssetPath != null
              ? selectedAssetPath
              : assetPath,
          width: 20,
          height: 20,
          colorFilter: ColorFilter.mode(
            isSelected ? const Color(0xFF151822) : Colors.grey,
            BlendMode.srcIn,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? const Color(0xFF151822) : Colors.grey,
          ),
        ),
      ],
    );
  }
}
