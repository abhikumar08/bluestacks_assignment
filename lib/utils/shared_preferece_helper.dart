import 'package:bluestacks_assignment/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final String accessTokenKey = "accessToken";
  static final String refreshTokenKey = 'refreshToken';
  static final String userNameKey = "userName";
  static final String userIdKey = "userId";
  static final String userProfileUrlKey = "userProfileUrl";

  static SharedPreferences _prefs;

  static final SharedPreferencesHelper _singleton =
      SharedPreferencesHelper._internal();

  factory SharedPreferencesHelper() {
    return _singleton;
  }

  SharedPreferencesHelper._internal();

  Future<SharedPreferences> getPreferences() async {
    if (_prefs == null)
      return await SharedPreferences.getInstance();
    else
      return _prefs;
  }

//  set mUserId(String userId) => sp?.setString("userId", userId);

  Future<bool> isLoggedIn() async {
    _prefs = await getPreferences();
    String accessToken = _prefs.getString(accessTokenKey);
    return accessToken != null;
  }

  Future setAuthResponse(AuthResponse authResponse) async {
    _prefs = await getPreferences();
    _prefs.setString(accessTokenKey, authResponse.accessToken);
    _prefs.setString(refreshTokenKey, authResponse.refreshToken);
  }

  Future<String> getAccessToken() async {
    _prefs = await getPreferences();
    return _prefs.getString(accessTokenKey) ?? null;
  }

  Future<String> getRefreshToken() async {
    _prefs = await getPreferences();
    return _prefs.getString(refreshTokenKey) ?? null;
  }

  Future<bool> clearPreferences() async {
    _prefs = await getPreferences();
    return _prefs.clear();
  }
}
