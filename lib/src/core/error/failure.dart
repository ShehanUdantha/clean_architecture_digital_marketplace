import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String errorMessage;
  final StackTrace? stackTrace;

  const Failure({
    required this.errorMessage,
    this.stackTrace,
  });

  @override
  List<Object?> get props => [
        errorMessage,
        stackTrace,
      ];
}

class FirebaseFailure extends Failure {
  const FirebaseFailure({
    required super.errorMessage,
    super.stackTrace,
  });
}

class StripeFailure extends Failure {
  const StripeFailure({
    required super.errorMessage,
    super.stackTrace,
  });
}

class APIFailure extends Failure {
  const APIFailure({
    required super.errorMessage,
    super.stackTrace,
  });
}

class LocalDBFailure extends Failure {
  const LocalDBFailure({
    required super.errorMessage,
    super.stackTrace,
  });
}
