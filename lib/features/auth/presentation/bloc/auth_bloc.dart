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
      emit(AuthError(_mapFailureToMessage(e)));
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
      emit(AuthError(_mapFailureToMessage(error)));
    }
  }

  Future<void> _onLogin(
      LoginEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
     AuthEntity entity = await login(event.email, event.password);
     print(entity.success);
     print(entity.success);
     if(entity.success) {
       emit(Authenticated());
     }else{
       emit(AuthError(entity.message));
     }
    } catch (e) {
      emit(AuthError(_mapFailureToMessage(e)));
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
      emit(AuthError(_mapFailureToMessage(e)));
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
      emit(AuthError(_mapFailureToMessage(e)));
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
      emit(AuthError(_mapFailureToMessage(e)));
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