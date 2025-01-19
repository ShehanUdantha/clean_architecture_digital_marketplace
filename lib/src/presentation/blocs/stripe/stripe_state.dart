part of 'stripe_bloc.dart';

class StripeState extends Equatable {
  final BlocStatus status;
  final String message;

  const StripeState({
    this.status = BlocStatus.initial,
    this.message = '',
  });

  StripeState copyWith({
    BlocStatus? status,
    String? message,
  }) =>
      StripeState(
        status: status ?? this.status,
        message: message ?? this.message,
      );

  @override
  List<Object> get props => [
        status,
        message,
      ];
}
