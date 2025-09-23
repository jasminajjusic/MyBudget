import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mybudget/features/biometrics/cubit/biometrics_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:mybudget/features/routing/app_routes.dart';

class BiometricScreen extends StatelessWidget {
  const BiometricScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BiometricCubit(LocalAuthentication())..authenticate(),
      child: BlocConsumer<BiometricCubit, BiometricState>(
        listener: (context, state) {
          if (state.status == BiometricStatus.authenticated) {
            context.go(AppRoutes.home);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFF151822),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.fingerprint, size: 100, color: Colors.white),
                  const SizedBox(height: 24),
                  const Text(
                    'Biometric Authentication',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Use your fingerprint to securely access your MyBudget app quickly and safely.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 80),
                  ElevatedButton(
                    onPressed:
                        state.status == BiometricStatus.authenticating
                            ? null
                            : () =>
                                context.read<BiometricCubit>().authenticate(),
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                      padding: const MaterialStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                    child: const Text('Try again'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
