abstract class Failure {
  final String errorMessage;

  Failure({required this.errorMessage});
}

class FirebaseFailure extends Failure {
  FirebaseFailure({required super.errorMessage});
}

class StripeFailure extends Failure {
  StripeFailure({required super.errorMessage});
}

class APIFailure extends Failure {
  APIFailure({required super.errorMessage});
}

class LocalDBFailure extends Failure {
  LocalDBFailure({required super.errorMessage});
}
