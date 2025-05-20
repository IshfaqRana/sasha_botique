import '../repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository authRepository;

  ResetPasswordUseCase(this.authRepository);

  Future<void> call(ResetPasswordParams params) async {
    return await authRepository.resetPassword(
        otp: params.otp,
        newPassword: params.newPassword,
        email: params.email,
    );
  }
}

class ResetPasswordParams {
  final String otp;
  final String newPassword;
  final String email;

  ResetPasswordParams({
    required this.otp,
    required this.newPassword,
    required this.email,
  });
}