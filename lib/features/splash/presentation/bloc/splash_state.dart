abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoaded extends SplashState {
  final bool isAuthenticated;
  SplashLoaded(  {required this.isAuthenticated});
}