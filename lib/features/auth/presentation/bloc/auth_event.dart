part of 'auth_bloc.dart';

abstract class AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}

class SignupEvent extends AuthEvent {
  final User user;
  final String password;

  SignupEvent(this.user, this.password);
}

class LogoutEvent extends AuthEvent {}
class ForgotPasswordEvent extends AuthEvent {
  final String email;

  ForgotPasswordEvent(this.email);
}
