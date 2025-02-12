import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_project_ii/services/api_constants.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kDebugMode;

class AuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        '459272499632-23o317mfmb3ohi3vfigois805luoaaet.apps.googleusercontent.com', // Optional: needed for backend auth
  );

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

  static Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      // Check if running in debug mode on iOS
      if (kDebugMode && Platform.isIOS) {
        print('Running on iOS in Debug Mode');
        try {
          if (await _googleSignIn.isSignedIn()) {
            await _googleSignIn.signOut();
          }

          final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
          if (googleUser != null) {
            final GoogleSignInAuthentication googleAuth =
                await googleUser.authentication;

            final headers = {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
            };

            final body = {
              'access_token': googleAuth.accessToken,
              'device_name': Platform.isIOS ? 'ios_device' : 'android_device',
            };

            // Debug logging
            print('Making request to: ${ApiConstants.googleLogin}');
            print('Method: POST');
            print('Headers: $headers');
            print('Body: ${json.encode(body)}');

            // Updated HTTP request
            final response = await http.post(
              Uri.parse(ApiConstants.googleLogin),
              headers: headers,
              body: json.encode(body),
            );

            print('Server response status: ${response.statusCode}');
            print('Server response body: ${response.body}');

            if (response.statusCode == 200) {
              final responseData = json.decode(response.body);
              return {'success': true, 'data': responseData};
            }

            // Try to parse error message from response
            Map<String, dynamic> errorData = {};
            try {
              errorData = json.decode(response.body);
            } catch (e) {
              print('Failed to parse error response: $e');
            }

            return {
              'success': false,
              'message':
                  errorData['message'] ?? 'Failed to authenticate with server',
              'error': errorData['error']
            };
          }
          return {'success': false, 'message': 'Google sign in cancelled'};
        } catch (e) {
          print('Google Sign In failed in iOS Debug Mode: $e');
          // Debug mode mock data
          return {
            'success': true,
            'data': {
              'token': 'mock_token_for_debug',
              'user': {
                'email': 'test@example.com',
                'name': 'Test User',
                'photoUrl': 'https://example.com/photo.jpg',
              }
            }
          };
        }
      }

      // Non-debug mode flow
      print('Initializing Google Sign In...');
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print('Google User: ${googleUser?.email}');

      if (googleUser == null) {
        return {'success': false, 'message': 'Sign in aborted by user'};
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print('Got Google Auth');

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      };

      final body = {
        'access_token': googleAuth.accessToken,
        'device_name': Platform.isIOS ? 'ios_device' : 'android_device',
      };

      // Debug logging
      print('Making request to: ${ApiConstants.googleLogin}');
      print('Method: POST');
      print('Headers: $headers');
      print('Body: ${json.encode(body)}');

      // Updated HTTP request for non-debug mode
      final response = await http.post(
        Uri.parse(ApiConstants.googleLogin),
        headers: headers,
        body: json.encode(body),
      );

      print('Server response status: ${response.statusCode}');
      print('Server response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return {'success': true, 'data': responseData};
      }

      // Try to parse error message from response
      Map<String, dynamic> errorData = {};
      try {
        errorData = json.decode(response.body);
      } catch (e) {
        print('Failed to parse error response: $e');
      }

      return {
        'success': false,
        'message': errorData['message'] ?? 'Failed to authenticate with server',
        'error': errorData['error']
      };
    } catch (e, stackTrace) {
      print('Error in signInWithGoogle: $e');
      print('Stack trace: $stackTrace');

      String errorMessage = 'Google sign in failed';

      if (e.toString().contains('network_error')) {
        errorMessage = 'No internet connection';
      } else if (e.toString().contains('sign_in_failed')) {
        errorMessage = 'Sign in failed - please try again';
      } else if (e.toString().contains('sign_in_canceled')) {
        errorMessage = 'Sign in was canceled';
      }

      return {'success': false, 'message': errorMessage, 'error': e.toString()};
    }
  }
}
