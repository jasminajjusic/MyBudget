import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybudget/features/settings/cubit/budget_settings_cubit.dart';
import 'package:mybudget/features/routing/app_routes.dart';
import 'package:mybudget/features/settings/widgets/budget_bottom_sheet.dart';
import 'package:mybudget/features/settings/widgets/categories_bottom_sheet.dart';
import 'package:mybudget/features/settings/widgets/repeating_payments_bottom_sheet.dart';
import 'package:mybudget/features/settings/widgets/limits_bottom_sheet.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'package:mybudget/features/settings/widgets/logout_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static Widget withProvider() {
    return BlocProvider(
      create: (_) => BudgetSettingsCubit(),
      child: const SettingsScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder:
              (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: const Color(0xFFF3F5F9),
                  elevation: 0,
                  leading: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => context.go(AppRoutes.home),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 12),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                        color: Color(0xFF03225C),
                      ),
                    ),
                  ),
                  centerTitle: true,
                  title: const Text(
                    'Data and personalization',
                    style: TextStyle(
                      color: Color(0xFF151822),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
          body: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            children: [
              const Text(
                'PERSONAL FINANCE SETTINGS ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF151822),
                ),
              ),
              const SizedBox(height: 8),
              _buildSettingsBox(
                context,
                children: [
                  _buildSettingsItem(
                    context,
                    title: 'Budget',
                    subtitle: 'Manage your budget settings',
                    onTap: () => showBudgetBottomSheet(context),
                  ),
                  _buildSettingsItem(
                    context,
                    title: 'Categories',
                    subtitle: 'Edit expense and income categories',
                    onTap: () => showCategoriesBottomSheet(context),
                  ),
                  _buildSettingsItem(
                    context,
                    title: 'Repeating payments',
                    subtitle: 'Manage your recurring payments',
                    onTap: () => showRepeatingPaymentsBottomSheet(context),
                  ),
                  _buildSettingsItem(
                    context,
                    title: 'Limits',
                    subtitle: 'Set up your limits',
                    onTap: () => showLimitsBottomSheet(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'PRIVACY',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF151822),
                ),
              ),
              const SizedBox(height: 8),
              _buildSettingsBox(
                context,
                children: [
                  _buildSettingsItem(
                    context,
                    title: 'Privacy information',
                    subtitle: 'Learn about our privacy policies',
                    onTap: () => context.go(AppRoutes.privacy),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'ACCOUNT',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF151822),
                ),
              ),
              const SizedBox(height: 8),
              _buildSettingsBox(
                context,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel:
                              MaterialLocalizations.of(
                                context,
                              ).modalBarrierDismissLabel,
                          barrierColor: Colors.transparent,
                          pageBuilder: (context, anim1, anim2) {
                            return const LogoutDialog();
                          },
                        );
                      },
                      child: Text(
                        'Log out',
                        style: TextStyle(fontSize: 16, color: Colors.red[600]),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsBox(
    BuildContext context, {
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 15,
          color: Colors.black87,
          letterSpacing: 0,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.black54,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Color(0xFF03225C),
      ),
      onTap: onTap,
    );
  }
}
