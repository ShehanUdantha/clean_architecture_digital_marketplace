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
