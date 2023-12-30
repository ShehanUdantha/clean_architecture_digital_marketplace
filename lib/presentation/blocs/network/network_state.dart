part of 'network_bloc.dart';

class NetworkState extends Equatable {
  final NetworkTypes networkTypes;

  const NetworkState({
    this.networkTypes = NetworkTypes.notConnected,
  });

  @override
  List<Object> get props => [networkTypes];
}
