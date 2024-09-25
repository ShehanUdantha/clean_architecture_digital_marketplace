import 'package:dartz/dartz.dart';

import '../error/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}

class YearAndMonthParams {
  final int year;
  final int month;

  YearAndMonthParams({required this.year, required this.month});
}
