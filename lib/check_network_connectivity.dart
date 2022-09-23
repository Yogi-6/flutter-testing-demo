import 'dart:async';

abstract class INetworkConnectivity {
  Future<bool> get hasConnection;

  Stream<StreamSubscription> onConnectionChanges({bool hasConnection});
}
