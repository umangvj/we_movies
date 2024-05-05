import 'package:shared_preferences/shared_preferences.dart';

const String _accessToken = 'accessToken';

class SharedPrefs {
  factory SharedPrefs() => SharedPrefs._internal();

  SharedPrefs._internal();

  static SharedPreferences? _sharedPrefs;

  static Future<void> init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> setAccessToken({
    required String accessToken,
  }) async {
    if (_sharedPrefs != null) {
      await _sharedPrefs?.setString(
        _accessToken,
        accessToken,
      );
    }
  }

  static String? get getAccessToken {
    final accessToken = _sharedPrefs?.getString(_accessToken);

    if (accessToken != null && accessToken.isNotEmpty) {
      return accessToken;
    }
    return '';
  }
}
