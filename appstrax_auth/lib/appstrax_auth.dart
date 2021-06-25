library appstrax_auth;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import 'models/register-dto.dart';

part './appstrax_storage.dart';
part './appstrax_http.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() {
    return _instance;
  }
  AuthService._internal();

  User? _user;

  StorageService _storageService = StorageService();

  init() async {
    await _storageService.init();

    var token = _storageService.getAuthToken();
    onAuthStateChanged(token);
  }

  onAuthStateChanged(String? token) {
    if (token != null && !_isTokenExpired(token)) {
      _user = User.fromJson(_decodeToken(token));
    } else {
      _user = null;
    }

    StorageService().setAuthToken(token);
  }

  Future<User> register(RegisterDto registerDto, String authApiUrl) async {
    var token = await HttpService().post(
      authApiUrl + '/api/auth/register',
      {
        'email': registerDto.email,
        'password': registerDto.password,
        'admin': false,
        'data': registerDto.data
      },
    );

    onAuthStateChanged(token);
    return _user!;
  }

  Future<User> login(String email, String password, String authApiUrl) async {
    var token = await HttpService().post(
      authApiUrl + '/api/auth/login',
      {'email': email, 'password': password},
    );

    onAuthStateChanged(token);
    return _user!;
  }

  Future<String> forgotPassword(String email, String authApiUrl) async {
    return await HttpService().post(
      authApiUrl + '/api/auth/forgot-password',
      {'email': email},
    );
  }

  Future<String> resetPassword(String email, String code, String password, String authApiUrl) async {
    return await HttpService().post(
      authApiUrl + '/api/auth/reset-password',
      {'email': email, 'code': code, 'password': password},
    );
  }

  User? getUser() {
    return _user;
  }

  String? getUserId() {
    return _user?.id;
  }

  String? getAuthToken() {
    var token = _storageService.getAuthToken();
    return token;
  }

  bool isAuthenticated() {
    return _user != null;
  }

  logout() {
    this.onAuthStateChanged(null);
  }

  bool _isTokenExpired(token, [offsetSeconds = 0]) {
    DateTime expirey = _getTokenExpirationDate(token);

    var expireyMilis = expirey.millisecondsSinceEpoch;
    var nowMilis = DateTime.now().millisecondsSinceEpoch + (offsetSeconds * 1000);

    return expireyMilis < nowMilis;
  }

  DateTime _getTokenExpirationDate(token) {
    var json = _decodeToken(token);

    return DateTime.fromMillisecondsSinceEpoch(json['exp'] * 1000);
  }

  _decodeToken(token) {
    var parts = token.split('.');
    if (parts.length != 3) {
      throw new Error();
    }
    var decoded = _urlBase64Decode(parts[1]);
    if (decoded == null) {
      throw new Error();
    }
    return jsonDecode(decoded);
  }

  _urlBase64Decode(String str) {
    var output = str.replaceAll(RegExp('/-/g'), '+').replaceAll(RegExp('/_/g'), '/');
    switch (output.length % 4) {
      case 0:
        {
          break;
        }
      case 2:
        {
          output += '==';
          break;
        }
      case 3:
        {
          output += '=';
          break;
        }
      default:
        {
          throw 'Illegal base64url string!';
        }
    }

    return utf8.fuse(base64).decode(output);
  }
}
