import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const AUTH0_DOMAIN = 'a3cle-publisher.eu.auth0.com';
const AUTH0_CLIENT_ID = 'UTZerACI9CyAKWFp98gfJh8XZOJE54fy';
const AUTH0_REDIRECT_URI = 'com.auth0.publisherflutter://login-callback';
const AUTH0_ISSUER = 'https://$AUTH0_DOMAIN';

class Auth extends ChangeNotifier {
  static FlutterAppAuth _appAuth;
  static FlutterSecureStorage _secureStorage;

  bool _isLoggedIn;

  String _accessToken;
  // String _idToken;
  String _refreshToken;

  Auth._privateConstructor() {
    _appAuth = FlutterAppAuth();
    _secureStorage = const FlutterSecureStorage();

    this._isLoggedIn = false;

    this._accessToken = null;
    this._refreshToken = null;
  }

  static final Auth _instance = Auth._privateConstructor();

  factory Auth() {
    return _instance;
  }

  void renewRefreshToken() async {
    final storedRefreshToken = await _secureStorage.read(key: 'refresh_token');
    if (storedRefreshToken == null) {
      return;
    }

    try {
      final response = await _appAuth.token(
        TokenRequest(
          AUTH0_CLIENT_ID,
          AUTH0_REDIRECT_URI,
          issuer: AUTH0_ISSUER,
          refreshToken: storedRefreshToken,
          additionalParameters: {'audience': 'https://publisher/api'},
        ),
      );

      this._isLoggedIn = true;
      this._accessToken = response.accessToken;
      this._refreshToken = response.refreshToken;

      _secureStorage.write(key: 'refresh_token', value: response.refreshToken);
      notifyListeners();
    } catch (e, s) {
      print('error on refresh token: $e - stack: $s');
      _secureStorage.delete(key: 'refresh_token');
    }
  }

  Map<String, dynamic> parseIdToken(String idToken) {
    final parts = idToken.split(r'.');
    assert(parts.length == 3);

    return jsonDecode(
      utf8.decode(
        base64Url.decode(
          base64Url.normalize(parts[1]),
        ),
      ),
    );
  }

  void loginAction() async {
    if (this._isLoggedIn) {
      return;
    }

    try {
      final AuthorizationTokenResponse result =
          await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          AUTH0_CLIENT_ID,
          AUTH0_REDIRECT_URI,
          issuer: 'https://$AUTH0_DOMAIN',
          scopes: ['openid', 'profile', 'offline_access'],
          additionalParameters: {'audience': 'https://publisher/api'},
        ),
      );

      this._accessToken = result.accessToken;
      // this._idToken = parseIdToken(result.idToken) as String;
      this._refreshToken = result.refreshToken;

      log('${result.idToken}');
      log('${result.refreshToken}');

      await _secureStorage.write(
          key: 'refresh_token', value: result.refreshToken);

      this._isLoggedIn = true;
      notifyListeners();
    } catch (e, s) {
      print('login error: $e - stack: $s');
      this._isLoggedIn = false;
    }
  }

  void logoutAction() async {
    await _secureStorage.delete(key: 'refresh_token');
    _isLoggedIn = false;
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }

  String getAccessToken() {
    return this._accessToken;
  }

  String getRefreshToken() {
    return this._refreshToken;
  }

  void setLoginStatus(bool loginStatus) {
    _isLoggedIn = loginStatus;
  }

  bool getLoginStatus() {
    return _isLoggedIn;
  }
}
