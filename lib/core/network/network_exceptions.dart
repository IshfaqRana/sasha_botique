class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
}

class CartException implements Exception {
  final String message;
  CartException(this.message);
}