import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/check_auth_usecase.dart';
import '../../domain/usecases/forget_password.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/signup_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckAuthStatusUseCase checkAuthStatus;
  final LoginUseCase login;
  final SignupUseCase signup;
  final LogoutUseCase logout;
  final ForgotPasswordUseCase forgotPassword;

  AuthBloc({
    required this.checkAuthStatus,
    required this.login,
    required this.signup,
    required this.logout,
    required this.forgotPassword,
  }) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginEvent>(_onLogin);
    on<SignupEvent>(_onSignup);
    on<LogoutEvent>(_onLogout);
    on<ForgotPasswordEvent>(_onForgotPassword);
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
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogin(
      LoginEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      await login(event.email, event.password);
      emit(Authenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignup(
      SignupEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      await signup(event.user, event.password);
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
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
      emit(AuthError(e.toString()));
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
      emit(AuthError(e.toString()));
    }
  }
}