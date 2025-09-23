import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mybudget/features/routing/app_routes.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151822),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Center(
              child: Image.asset(
                'assets/icons/logo.png',
                width: 250,
                height: 250,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 42.0,
                vertical: 24,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  onPressed: () {
                    context.go(AppRoutes.biometrics);
                  },

                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFF151822),
                    side: const BorderSide(
                      color: const Color(0xFF70A0F8),
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 3,
                    shadowColor: Colors.black.withOpacity(0.3),
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF71A1F8),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward,
                        color: const Color(0xFF70A0F8),
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
