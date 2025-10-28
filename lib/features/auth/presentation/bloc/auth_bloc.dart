import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasha_botique/features/auth/data/api_services/auth_api_service.dart';
import 'package:sasha_botique/features/auth/domain/entities/auth_entity.dart';

import '../../../../core/network/network_exceptions.dart';
import '../../../profile/domain/entities/user.dart';
import '../../domain/usecases/check_auth_usecase.dart';
import '../../domain/usecases/forget_password.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckAuthStatusUseCase checkAuthStatus;
  final LoginUseCase login;
  final SignupUseCase signup;
  final LogoutUseCase logout;
  final ForgotPasswordUseCase forgotPassword;
  final ResetPasswordUseCase resetPasswordUseCase;


  AuthBloc({
    required this.checkAuthStatus,
    required this.login,
    required this.signup,
    required this.logout,
    required this.forgotPassword,required this.resetPasswordUseCase,
  }) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginEvent>(_onLogin);
    on<SignupEvent>(_onSignup);
    on<LogoutEvent>(_onLogout);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<ResetPasswordEvent>(_onResetPassword);
    on<ResendOTPEvent>(_onResendOTP);

  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatusEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      final isAuthenticated = await checkAuthStatus();
      emit(isAuthenticated ? Authenticated() : Unauthenticated());
    } catch (e) {
      final validationErrors = e is AuthException ? e.validationErrors : null;
      emit(AuthError(_mapFailureToMessage(e), validationErrors: validationErrors));
    }
  }
  Future<void> _onResetPassword(
      ResetPasswordEvent event,
      Emitter<AuthState> emit
      ) async {
    emit(AuthLoading());
    try {
      await resetPasswordUseCase(
          ResetPasswordParams(
              otp: event.otp,
              newPassword: event.newPassword,
              email: event.email,
          )
      );
      emit(ResetPasswordSuccess());
    } catch (error) {
      final validationErrors = error is AuthException ? error.validationErrors : null;
      emit(AuthError(_mapFailureToMessage(error), validationErrors: validationErrors));
    }
  }

  Future<void> _onLogin(
      LoginEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
     AuthEntity entity = await login(event.email, event.password);
     print('🔐 AuthBloc Debug: Login result - Success: ${entity.success}, Message: ${entity.message}, Token: ${entity.token?.substring(0, 20)}...');
     if(entity.success) {
       print('🔐 AuthBloc Debug: Login successful, verifying auth status...');

       // Double-check authentication status after login
       final isAuthenticated = await checkAuthStatus();
       if (isAuthenticated) {
         print('🔐 AuthBloc Debug: Auth verified, emitting Authenticated state');
         emit(Authenticated());
       } else {
         print('🔐 AuthBloc Debug: Auth verification failed, token might not be saved properly');
         emit(AuthError('Authentication failed after login'));
       }
     }else{
       print('🔐 AuthBloc Debug: Login failed, emitting error');
       emit(AuthError(entity.message));
     }
    } catch (e) {
      print('🔐 AuthBloc Debug: Login exception: $e');
      final validationErrors = e is AuthException ? e.validationErrors : null;
      emit(AuthError(_mapFailureToMessage(e), validationErrors: validationErrors));
    }
  }

  Future<void> _onSignup(
      SignupEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      AuthEntity entity = await signup(event.user, event.password);
      if(entity.success) {
        emit(Authenticated());
      }else{
        emit(AuthError(entity.message));
      }
    } catch (e) {
      final validationErrors = e is AuthException ? e.validationErrors : null;
      emit(AuthError(_mapFailureToMessage(e), validationErrors: validationErrors));
    }
  }

  Future<void> _onLogout(
      LogoutEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      await logout();
      emit(Unauthenticated());
    } catch (e) {
      final validationErrors = e is AuthException ? e.validationErrors : null;
      emit(AuthError(_mapFailureToMessage(e), validationErrors: validationErrors));
    }
  }

  Future<void> _onForgotPassword(
      ForgotPasswordEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      await forgotPassword(event.email);
      emit(PasswordResetEmailSent());
    } catch (e) {
      final validationErrors = e is AuthException ? e.validationErrors : null;
      emit(AuthError(_mapFailureToMessage(e), validationErrors: validationErrors));
    }
  }

  Future<void> _onResendOTP(
      ResendOTPEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      await forgotPassword(event.email);
      emit(OTPResentSuccessfully());
    } catch (e) {
      final validationErrors = e is AuthException ? e.validationErrors : null;
      emit(AuthError(_mapFailureToMessage(e), validationErrors: validationErrors));
    }
  }

  String _mapFailureToMessage( exception) {
    switch (exception) {
      case NotFoundException _:
        return exception.message;
      case BadRequestException _:
        return exception.message;
      case ForbiddenException _:
        return exception.message;
      case ServerException _:
        return 'Server Error: Please try again later';
      case NetworkException _:
        return 'Network Error: Please check your internet connection';
      case UnauthorizedException _:
        return exception.message;
      case AuthException _:
        return exception.message;
      default:
        return exception?.toString() ?? 'Something went wrong. Please try again';
    }
  }
}