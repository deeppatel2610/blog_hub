import 'dart:async';
import 'package:blog_hub/%20core/utils/enums.dart';
import 'package:http/http.dart' as http;

class GlobalNetworkChecker {

  Future<NetworkStatus> checkSpeed() async {
    final stopwatch = Stopwatch()..start();

    try {
      final response = await http
          .get(Uri.parse("https://www.google.com/generate_204"))
          .timeout(const Duration(seconds: 5));

      stopwatch.stop();

      final time = stopwatch.elapsedMilliseconds;

      if (response.statusCode == 204) {
        if (time < 800) {
          return NetworkStatus.fast;
        } else if (time < 2000) {
          return NetworkStatus.medium;
        } else {
          return NetworkStatus.slow;
        }
      } else {
        return NetworkStatus.noInternet;
      }

    } on TimeoutException {
      return NetworkStatus.slow;
    } catch (_) {
      return NetworkStatus.noInternet;
    }
  }
}
