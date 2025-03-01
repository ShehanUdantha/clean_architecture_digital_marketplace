abstract class Failure {
  final String errorMessage;
  final StackTrace? stackTrace;

  Failure({
    required this.errorMessage,
    this.stackTrace,
  });
}

class FirebaseFailure extends Failure {
  FirebaseFailure({
    required super.errorMessage,
    super.stackTrace,
  });
}

class StripeFailure extends Failure {
  StripeFailure({
    required super.errorMessage,
    super.stackTrace,
  });
}

class APIFailure extends Failure {
  APIFailure({
    required super.errorMessage,
    super.stackTrace,
  });
}

class LocalDBFailure extends Failure {
  LocalDBFailure({
    required super.errorMessage,
    super.stackTrace,
  });
}
