import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_project_ii/services/api_constants.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(
      String email, String password, String deviceName) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.authToken),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
          'device_name': deviceName,
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': json.decode(response.body)};
      }
      return {'success': false, 'message': 'Login failed'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<bool> verifyToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.verifyToken),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> logout(String token) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/auth/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>> signup(
      String name, String email, String password, String deviceName) async {
    try {
      print('Attempting signup with email: $email and device: $deviceName');

      final response = await http.post(
        Uri.parse(ApiConstants.authRegister),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'device_name': deviceName,
        }),
      );

      print('Registration response status: ${response.statusCode}');
      print('Registration response body: ${response.body}');

      if (response.statusCode == 201) {
        return {'success': true, 'data': json.decode(response.body)};
      }

      // Parse error message from response if possible
      Map<String, dynamic> errorBody;
      try {
        errorBody = json.decode(response.body);
      } catch (e) {
        errorBody = {};
      }

      return {
        'success': false,
        'message': errorBody['message'] ??
            'Registration failed with status ${response.statusCode}',
        'status': response.statusCode
      };
    } catch (e) {
      print('Registration error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }
}
