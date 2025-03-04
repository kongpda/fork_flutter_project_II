import 'dart:convert';
import 'dart:io';
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
        // Silently handle disconnect errors
      }
      try {
        await _googleSignIn.signOut();
      } catch (e) {
        // Silently handle signout errors
      }

      // Wait a brief moment to ensure cleanup is complete
      await Future.delayed(const Duration(milliseconds: 500));

      // Attempt to sign in and catch specific errors
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return {'success': false, 'message': 'Sign in aborted by user'};
      }

      try {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        if (googleAuth.accessToken == null) {
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

  static Future<Map<String, dynamic>> getUserProfile(String token) async {
    try {
      print('Fetching user profile from: ${ApiConstants.baseUrl}/user/profile');
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/user/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('User profile API response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('User profile data received: ${responseData['message']}');
        return {
          'success': true,
          'data': responseData,
        };
      }

      print(
          'Failed to get user profile. Status: ${response.statusCode}, Body: ${response.body}');
      return {
        'success': false,
        'message': 'Failed to get user profile. Status: ${response.statusCode}',
      };
    } catch (e) {
      print('Error fetching user profile: $e');
      return {
        'success': false,
        'message': 'Connection error: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> updateUserProfile(
    String token,
    String profileId,
    Map<String, dynamic> profileData,
  ) async {
    try {
      print('Updating profile at: ${ApiConstants.baseUrl}/profiles/$profileId');
      print('Update data: $profileData');

      // Send the profile data directly without wrapping it in a data object
      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/profiles/$profileId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        // Send the profile data directly as specified in the API documentation
        body: json.encode(profileData),
      );

      print('Profile update API response status: ${response.statusCode}');
      print('Profile update API response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        print('Profile updated successfully: $responseData');
        return {
          'success': true,
          'data': responseData,
        };
      }

      print(
          'Failed to update profile. Status: ${response.statusCode}, Body: ${response.body}');

      // Try to parse error message from response
      String errorMessage =
          'Failed to update profile. Status: ${response.statusCode}';
      try {
        final errorData = json.decode(response.body);
        if (errorData['message'] != null) {
          errorMessage = errorData['message'];
        } else if (errorData['errors'] != null &&
            errorData['errors'] is List &&
            errorData['errors'].isNotEmpty) {
          errorMessage = errorData['errors'][0]['detail'] ?? errorMessage;
        }

        print('Parsed error message: $errorMessage');
      } catch (e) {
        // If we can't parse the error, use the default message
        print('Could not parse error response: $e');
      }

      return {
        'success': false,
        'message': errorMessage,
      };
    } catch (e) {
      print('Error updating profile: $e');
      return {
        'success': false,
        'message': 'Connection error: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> uploadAvatar(
    String token,
    File avatarFile,
  ) async {
    try {
      print('Uploading avatar to: ${ApiConstants.baseUrl}/profile/avatar');

      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConstants.baseUrl}/profile/avatar'),
      );

      // Add authorization header
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // Add file to request
      request.files.add(await http.MultipartFile.fromPath(
        'avatar',
        avatarFile.path,
      ));

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('Avatar upload API response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Avatar uploaded successfully: ${responseData['message']}');
        return {
          'success': true,
          'data': responseData,
        };
      }

      print(
          'Failed to upload avatar. Status: ${response.statusCode}, Body: ${response.body}');
      return {
        'success': false,
        'message': 'Failed to upload avatar. Status: ${response.statusCode}',
      };
    } catch (e) {
      print('Error uploading avatar: $e');
      return {
        'success': false,
        'message': 'Connection error: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> removeAvatar(String token) async {
    try {
      print('Removing avatar at: ${ApiConstants.baseUrl}/profile/avatar');

      final response = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}/profile/avatar'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Avatar removal API response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Avatar removed successfully: ${responseData['message']}');
        return {
          'success': true,
          'data': responseData,
        };
      }

      print(
          'Failed to remove avatar. Status: ${response.statusCode}, Body: ${response.body}');
      return {
        'success': false,
        'message': 'Failed to remove avatar. Status: ${response.statusCode}',
      };
    } catch (e) {
      print('Error removing avatar: $e');
      return {
        'success': false,
        'message': 'Connection error: $e',
      };
    }
  }
}
