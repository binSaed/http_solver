import 'package:connectivity/connectivity.dart';

Future<bool> hasInternet() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) return true;
  return false;
}
