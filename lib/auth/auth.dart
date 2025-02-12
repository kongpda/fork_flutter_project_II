import 'dart:io';

import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_project_ii/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _token;
  bool isFirstTime = true;
  final _storage = const FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
  static const _firstTimeKey = 'is_first_time';

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;

  // Initialize auth state
  Future<void> init() async {
    _token = await _storage.read(key: _tokenKey);
    _isAuthenticated = _token != null;

    final prefs = await SharedPreferences.getInstance();
    isFirstTime = prefs.getBool(_firstTimeKey) ?? true;

    notifyListeners();
  }

  Future<String> _getDeviceName() async {
    final deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return '${iosInfo.name} (${iosInfo.model})';
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return '${androidInfo.brand} ${androidInfo.model}';
      } else {
        final webInfo = await deviceInfo.webBrowserInfo;
        return webInfo.userAgent ?? 'Web Browser';
      }
    } catch (e) {
      print('Error getting device info: $e');
      return 'Unknown Device';
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final deviceName = await _getDeviceName();
      final result = await AuthService.login(email, password, deviceName);

      if (result['success']) {
        _token = result['data']['token'];
        await _storage.write(key: _tokenKey, value: _token);
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      if (_token != null) {
        await AuthService.logout(_token!);
      }
    } catch (e) {
      print('Logout error: $e');
    } finally {
      _isAuthenticated = false;
      _token = null;
      await _storage.delete(key: _tokenKey);
      notifyListeners();
    }
  }

  Future<bool> isTokenValid() async {
    if (_token == null) return false;
    return await AuthService.verifyToken(_token!);
  }

  Future<void> setToken(String token) async {
    _token = token;
    await _storage.write(key: _tokenKey, value: token);
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    isFirstTime = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstTimeKey, false);
    notifyListeners();
  }
}
