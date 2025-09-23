import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mybudget/features/routing/app_routes.dart';
import '../../limits/widgets/limits_popup.dart';

class ActionIconsBox extends StatelessWidget {
  const ActionIconsBox({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _Action(
        iconPath: 'assets/icons/pay.svg',
        label: 'Goals',
        route: AppRoutes.setGoals,
      ),
      _Action(
        iconPath: 'assets/icons/top_up.svg',
        label: 'Limits',
        route: AppRoutes.limits,
      ),
      _Action(
        iconPath: 'assets/icons/add.svg',
        label: 'Add',
        route: AppRoutes.addTransaction,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16.0),
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              spreadRadius: 1.0,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(actions.length * 2 - 1, (index) {
            if (index.isEven) {
              final action = actions[index ~/ 2];
              return _buildActionIcon(
                context,
                action.iconPath,
                action.label,
                action.route,
              );
            } else {
              return Container(
                width: 1,
                height: 40,
                color: Colors.grey[300],
                margin: const EdgeInsets.symmetric(horizontal: 12),
              );
            }
          }),
        ),
      ),
    );
  }

  Widget _buildActionIcon(
    BuildContext context,
    String assetPath,
    String label,
    String route,
  ) {
    return InkWell(
      onTap: () {
        if (label == 'Limits') {
          showLimitsPopup(context);
        } else {
          context.go(route);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(assetPath, height: 30, color: Colors.black),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _Action {
  final String iconPath;
  final String label;
  final String route;
  _Action({required this.iconPath, required this.label, required this.route});
}
