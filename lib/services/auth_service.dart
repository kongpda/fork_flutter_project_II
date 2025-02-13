import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_project_ii/services/api_constants.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        '459272499632-23o317mfmb3ohi3vfigois805luoaaet.apps.googleusercontent.com',
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

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': responseData};
      }

      String errorMessage = 'Login failed';
      if (response.statusCode == 422) {
        errorMessage = 'Invalid email or password';
      } else if (response.statusCode == 429) {
        errorMessage = 'Too many attempts. Please try again later';
      } else if (responseData['message'] != null) {
        errorMessage = responseData['message'];
      }

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      String errorMessage = 'Connection error';
      if (e.toString().contains('SocketException')) {
        errorMessage = 'No internet connection';
      }
      return {'success': false, 'message': errorMessage};
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

      if (response.statusCode != 200) {
        throw Exception('Logout failed');
      }
      return true;
    } catch (e) {
      throw Exception('Failed to logout');
    }
  }

  static Future<Map<String, dynamic>> signup(
      String name, String email, String password, String deviceName) async {
    try {
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

      if (response.statusCode == 201) {
        return {'success': true, 'data': json.decode(response.body)};
      }

      Map<String, dynamic> errorBody;
      try {
        errorBody = json.decode(response.body);

        if (response.statusCode == 422 && errorBody.containsKey('errors')) {
          final errors = errorBody['errors'] as Map<String, dynamic>;
          final messages = errors.values
              .expand((e) => (e as List).map((msg) => msg.toString()))
              .toList();
          return {
            'success': false,
            'message': messages.join('\n'),
            'status': response.statusCode
          };
        }

        switch (response.statusCode) {
          case 400:
            return {
              'success': false,
              'message': 'Invalid request. Please check your information.',
              'status': response.statusCode
            };
          case 401:
            return {
              'success': false,
              'message': 'Unauthorized. Please try again.',
              'status': response.statusCode
            };
          case 409:
            return {
              'success': false,
              'message': 'This email is already registered.',
              'status': response.statusCode
            };
          default:
            return {
              'success': false,
              'message': errorBody['message'] ??
                  'Something went wrong. Please try again later.',
              'status': response.statusCode
            };
        }
      } catch (e) {
        return {
          'success': false,
          'message': 'Unable to process your request. Please try again later.',
          'status': response.statusCode
        };
      }
    } catch (e) {
      String errorMessage = 'Unable to connect to the server.';

      if (e.toString().contains('SocketException')) {
        errorMessage = 'No internet connection. Please check your network.';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Request timed out. Please try again.';
      }

      return {'success': false, 'message': errorMessage};
    }
  }

  static Future<Map<String, dynamic>> signInWithGoogle(
      String deviceName) async {
    try {
      // Force disconnect and sign out to ensure clean state
      try {
        await _googleSignIn.disconnect();
      } catch (e) {
        print('Disconnect error (ignorable): $e');
      }
      try {
        await _googleSignIn.signOut();
      } catch (e) {
        print('SignOut error (ignorable): $e');
      }

      // Wait a brief moment to ensure cleanup is complete
      await Future.delayed(const Duration(milliseconds: 500));

      // Attempt to sign in and catch specific errors
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Google Sign In Error: User cancelled the sign-in flow');
        return {'success': false, 'message': 'Sign in aborted by user'};
      }

      try {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        if (googleAuth.accessToken == null) {
          print('Google Sign In Error: No access token received');
          return {
            'success': false,
            'message': 'Failed to get Google authentication token'
          };
        }

        final response = await http.post(
          Uri.parse(ApiConstants.socialLogin),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
          },
          body: json.encode({
            'access_token': googleAuth.accessToken,
            'device_name': deviceName,
            'email': googleUser.email,
            'name': googleUser.displayName,
            'photo_url': googleUser.photoUrl,
            'provider': 'google',
            'provider_user_id': googleUser.id,
          }),
        );

        print('Google Auth API Response Status: ${response.statusCode}');
        print('Google Auth API Response Body: ${response.body}');

        if (response.statusCode == 200) {
          return {'success': true, 'data': json.decode(response.body)};
        }

        Map<String, dynamic> errorData = {};
        try {
          errorData = json.decode(response.body);
        } catch (e) {
          return {'success': false, 'message': 'Authentication failed'};
        }

        return {
          'success': false,
          'message': errorData['message'] ?? 'Authentication failed'
        };
      } catch (e) {
        String errorMessage = 'Google sign in failed';

        if (e.toString().contains('network_error')) {
          errorMessage = 'No internet connection';
        } else if (e.toString().contains('sign_in_failed')) {
          errorMessage = 'Sign in failed - please try again';
        } else if (e.toString().contains('sign_in_canceled')) {
          errorMessage = 'Sign in was canceled';
        }

        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      String errorMessage = 'Google sign in failed';

      if (e.toString().contains('network_error')) {
        errorMessage = 'No internet connection';
      } else if (e.toString().contains('sign_in_failed')) {
        errorMessage = 'Sign in failed - please try again';
      } else if (e.toString().contains('sign_in_canceled')) {
        errorMessage = 'Sign in was canceled';
      }

      return {'success': false, 'message': errorMessage};
    }
  }
}
