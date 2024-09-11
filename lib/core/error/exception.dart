abstract class Exception {
  final String errorMessage;

  Exception({required this.errorMessage});
}

class AuthException extends Exception {
  AuthException({required super.errorMessage});
}

class DBException extends Exception {
  DBException({required super.errorMessage});
}

class StripeException extends Exception {
  StripeException({required super.errorMessage});
}

class APIException extends Exception {
  APIException({required super.errorMessage});
}
