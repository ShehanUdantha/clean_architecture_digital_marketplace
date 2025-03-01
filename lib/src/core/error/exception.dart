abstract class Exception {
  final String errorMessage;
  final StackTrace? stackTrace;

  Exception({
    required this.errorMessage,
    this.stackTrace,
  });
}

class AuthException extends Exception {
  AuthException({
    required super.errorMessage,
    super.stackTrace,
  });
}

class DBException extends Exception {
  DBException({
    required super.errorMessage,
    super.stackTrace,
  });
}

class StripeException extends Exception {
  StripeException({
    required super.errorMessage,
    super.stackTrace,
  });
}

class APIException extends Exception {
  APIException({
    required super.errorMessage,
    super.stackTrace,
  });
}
