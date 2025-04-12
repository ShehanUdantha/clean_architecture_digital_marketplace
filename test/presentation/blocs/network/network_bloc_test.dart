import 'dart:async';

import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/presentation/blocs/network/network_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_bloc_test.mocks.dart';

@GenerateMocks([Connectivity])
void main() {
  late NetworkBloc networkBloc;
  late MockConnectivity mockConnectivity;
  late StreamController<List<ConnectivityResult>> connectivityStreamController;

  setUp(() {
    mockConnectivity = MockConnectivity();
    connectivityStreamController = StreamController<List<ConnectivityResult>>();
    when(mockConnectivity.onConnectivityChanged)
        .thenAnswer((_) => connectivityStreamController.stream);

    networkBloc = NetworkBloc(mockConnectivity);
  });

  tearDown(() {
    connectivityStreamController.close();
    networkBloc.close();
  });

  blocTest<NetworkBloc, NetworkState>(
    'emits NetworkTypes.connected when connectivity is mobile',
    build: () => networkBloc,
    act: (bloc) async {
      connectivityStreamController.add([ConnectivityResult.mobile]);
    },
    expect: () => [
      NetworkState(networkTypes: NetworkTypes.connected),
    ],
  );

  blocTest<NetworkBloc, NetworkState>(
    'emits NetworkTypes.notConnected when connectivity is none',
    build: () => networkBloc,
    act: (bloc) async {
      connectivityStreamController.add([ConnectivityResult.none]);
    },
    expect: () => [
      const NetworkState(networkTypes: NetworkTypes.notConnected),
    ],
  );
}
