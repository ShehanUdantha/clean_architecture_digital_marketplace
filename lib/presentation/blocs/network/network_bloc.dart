import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

import '../../../core/utils/enum.dart';

part 'network_event.dart';
part 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  Connectivity connectivity = Connectivity();
  StreamSubscription? connectivitySubscription;

  NetworkBloc() : super(const NetworkState()) {
    on<CheckNetworkConnectivity>(onCheckNetworkConnectivity);

    connectivitySubscription = connectivity.onConnectivityChanged.listen(
      (result) {
        add(CheckNetworkConnectivity(result: result));
      },
    );
  }

  FutureOr<void> onCheckNetworkConnectivity(
    CheckNetworkConnectivity event,
    Emitter<NetworkState> emit,
  ) async {
    if (event.result == ConnectivityResult.mobile ||
        event.result == ConnectivityResult.wifi) {
      emit(const NetworkState(networkTypes: NetworkTypes.connected));
    } else {
      emit(const NetworkState(networkTypes: NetworkTypes.notConnected));
    }
  }

  @override
  Future<void> close() {
    connectivitySubscription?.cancel();
    return super.close();
  }
}
