import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

enum BiometricStatus { initial, authenticating, authenticated, failed }

class BiometricState {
  final BiometricStatus status;
  final String message;

  BiometricState({required this.status, required this.message});

  factory BiometricState.initial() =>
      BiometricState(status: BiometricStatus.initial, message: '');

  BiometricState copyWith({BiometricStatus? status, String? message}) {
    return BiometricState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}

class BiometricCubit extends Cubit<BiometricState> {
  final LocalAuthentication auth;

  BiometricCubit(this.auth) : super(BiometricState.initial());

  Future<void> authenticate() async {
    emit(
      state.copyWith(
        status: BiometricStatus.authenticating,
        message: 'Waiting for biometric authentication...',
      ),
    );

    try {
      final isAvailable = await auth.canCheckBiometrics;
      if (!isAvailable) {
        emit(
          state.copyWith(
            status: BiometricStatus.failed,
            message: 'Biometric authentication not available.',
          ),
        );
        return;
      }

      final didAuthenticate = await auth.authenticate(
        localizedReason: 'Authenticate using fingerprint',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        emit(
          state.copyWith(
            status: BiometricStatus.authenticated,
            message: 'Authentication successful!',
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: BiometricStatus.failed,
            message: 'Authentication cancelled.',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(status: BiometricStatus.failed, message: 'Error: $e'),
      );
    }
  }
}
