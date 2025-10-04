part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  final List<String>? validationErrors;
  AuthError(this.message, {this.validationErrors});
}
class PasswordResetEmailSent extends AuthState {}
class ResetPasswordSuccess extends AuthState {}

