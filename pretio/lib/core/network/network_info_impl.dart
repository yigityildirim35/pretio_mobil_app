import 'package:connectivity_plus/connectivity_plus.dart';
import 'network_info.dart';

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl([Connectivity? connectivity])
      : connectivity = connectivity ?? Connectivity();

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}
