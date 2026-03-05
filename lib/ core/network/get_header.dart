import 'package:blog_hub/%20core/storage/preference_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetHeader {
  Future<(String, String)> getTokens() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString(PreferenceKeys.assessToken) ?? "";
    String type = sharedPreferences.getString(PreferenceKeys.tokenType) ?? "";
    return (token, type);
  }

  Map<String, dynamic> getHeaders({
    required String token,
    required String type,
  }) {
    token.trim();
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "$type $token",
    };
  }
}
