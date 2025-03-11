class AuthEntity {
  final bool success;
  final String? token;
  final String message;

  const AuthEntity({this.token, required this.message,required this.success});
}