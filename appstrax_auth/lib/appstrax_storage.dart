part of appstrax_auth;

class StorageService {
  static final StorageService _instance = StorageService._internal();

  SharedPreferences? _prefs;
  final String _token = 'SWOP_SWOP_token';

  factory StorageService() {
    return _instance;
  }
  StorageService._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  _validateInit() {
    if (_prefs == null) {
      throw ('Please init first');
    }
  }

  String? getAuthToken() {
    _validateInit();
    return _prefs!.getString(this._token);
  }

  setAuthToken(String? token) {
    _validateInit();
    if (token != null) {
      _prefs!.setString(this._token, token);
    } else {
      clearAuthToken();
    }
  }

  clearAuthToken() {
    _validateInit();
    _prefs!.remove(this._token);
  }
}