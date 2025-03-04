import 'dart:io';

import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_project_ii/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_project_ii/models/user_profile.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _token;
  bool isFirstTime = true;
  UserProfile? _userProfile;
  final _storage = const FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
  static const _firstTimeKey = 'is_first_time';

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  UserProfile? get userProfile => _userProfile;

  // Initialize auth state
  Future<void> init() async {
    _token = await _storage.read(key: _tokenKey);
    _isAuthenticated = _token != null;

    final prefs = await SharedPreferences.getInstance();
    isFirstTime = prefs.getBool(_firstTimeKey) ?? true;

    if (_isAuthenticated && _token != null) {
      await fetchUserProfile();
    }

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

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final deviceName = await _getDeviceName();
      final result = await AuthService.login(email, password, deviceName);

      if (result['success']) {
        _token = result['data']['token'];
        await _storage.write(key: _tokenKey, value: _token);
        _isAuthenticated = true;
        await fetchUserProfile();
        notifyListeners();
      }
      return result;
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred'};
    }
  }

  Future<void> logout() async {
    try {
      if (_token != null) {
        final result = await AuthService.logout(_token!);
        if (!result) {
          throw Exception('Logout failed');
        }
      }
    } catch (e) {
      throw Exception('Failed to logout');
    } finally {
      _isAuthenticated = false;
      _token = null;
      _userProfile = null;
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
    await fetchUserProfile();
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    isFirstTime = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstTimeKey, false);
    notifyListeners();
  }

  Future<Map<String, dynamic>> signup(
    String name,
    String email,
    String password,
  ) async {
    try {
      final deviceName = await _getDeviceName();
      final result = await AuthService.signup(
        name,
        email,
        password,
        deviceName,
      );

      if (result['success']) {
        _token = result['data']['token'];
        await _storage.write(key: _tokenKey, value: _token);
        _isAuthenticated = true;
        await fetchUserProfile();
        notifyListeners();
      }
      return result;
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to create account. Please try again.',
      };
    }
  }

  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      final deviceName = await _getDeviceName();
      final result = await AuthService.signInWithGoogle(deviceName);

      if (result['success']) {
        _token = result['data']['token'];
        await _storage.write(key: _tokenKey, value: _token);
        _isAuthenticated = true;
        await fetchUserProfile();
        notifyListeners();
      }
      return result;
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to sign in with Google. Please try again.',
      };
    }
  }

  Future<bool> fetchUserProfile() async {
    if (_token == null) {
      print('Cannot fetch user profile: token is null');
      return false;
    }

    try {
      print('Fetching user profile with token: ${_token!.substring(0, 10)}...');
      final result = await AuthService.getUserProfile(_token!);

      if (result['success']) {
        print('User profile fetch successful, parsing data: ${result['data']}');

        try {
          _userProfile = UserProfile.fromJson(result['data']);
          print(
              'User profile parsed successfully with ID: ${_userProfile?.id}');
          print('User profile display name: ${_userProfile?.displayName}');
          print('User profile avatar URL: ${_userProfile?.avatarUrl}');

          notifyListeners();
          return true;
        } catch (parseError) {
          print('Error parsing user profile data: $parseError');
          print('Raw profile data: ${result['data']}');
          return false;
        }
      }

      print('Failed to fetch user profile: ${result['message']}');
      return false;
    } catch (e) {
      print('Error in fetchUserProfile: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> updateUserProfile({
    String? firstName,
    String? lastName,
    String? birthDate,
    String? phone,
    String? bio,
    String? address,
    List<String>? socialLinks,
  }) async {
    if (_token == null || _userProfile == null) {
      return {
        'success': false,
        'message': 'You must be logged in to update your profile',
      };
    }

    // Get profile ID from the user profile
    String profileId = '';

    // From the logs we can see that the API is using a numeric ID for profiles
    // We need to extract this from the profile data in relationships
    try {
      print('User profile details for profile ID extraction:');
      print('- ID: ${_userProfile!.id}');
      print('- Full Name: ${_userProfile!.fullName}');
      print(
          '- relationshipsProfileId: ${_userProfile?.relationshipsProfileId}');

      if (_userProfile!.relationshipsProfileId != null &&
          _userProfile!.relationshipsProfileId!.isNotEmpty) {
        // Use the profile ID from relationships section (this is what the API expects)
        profileId = _userProfile!.relationshipsProfileId!;
        print('Using profile ID from relationships: $profileId');
      } else {
        // Fallback to the user ID (this might not work with the API)
        profileId = _userProfile!.id;
        print(
            'Using fallback user ID: $profileId (this might not work correctly)');
      }
    } catch (e) {
      print('Error extracting profile ID: $e');
      profileId = _userProfile!.id;
    }

    if (profileId.isEmpty) {
      return {
        'success': false,
        'message': 'Profile ID not found',
      };
    }

    // Build the update data
    final Map<String, dynamic> updateData = {};

    if (firstName != null) updateData['first_name'] = firstName;
    if (lastName != null) updateData['last_name'] = lastName;
    if (birthDate != null) updateData['birth_date'] = birthDate;
    if (phone != null) updateData['phone'] = phone;
    if (bio != null) updateData['bio'] = bio;
    if (address != null) updateData['address'] = address;
    if (socialLinks != null) updateData['social_links'] = socialLinks;

    print('Profile update data being sent:');
    print('- Profile ID: $profileId');
    print('- First Name: ${updateData['first_name']}');
    print('- Last Name: ${updateData['last_name']}');
    print('- Phone: ${updateData['phone']}');
    print('- Bio: ${updateData['bio']}');

    try {
      final result = await AuthService.updateUserProfile(
        _token!,
        profileId,
        updateData,
      );

      print('Profile update service result: $result');

      if (result['success']) {
        // Refresh the user profile after update
        print('Update successful, refreshing user profile.');
        await fetchUserProfile();

        // Verify the updated data
        print('After update, profile data is:');
        print('- ID: ${_userProfile?.id}');
        print('- First Name: ${_userProfile?.firstName}');
        print('- Last Name: ${_userProfile?.lastName}');
        print('- Full Name: ${_userProfile?.fullName}');

        return {
          'success': true,
          'message': 'Profile updated successfully',
        };
      }

      return {
        'success': false,
        'message': result['message'] ?? 'Failed to update profile',
      };
    } catch (e) {
      print('Error in updateUserProfile: $e');
      return {
        'success': false,
        'message': 'An error occurred while updating your profile',
      };
    }
  }

  Future<Map<String, dynamic>> uploadAvatar(File avatarFile) async {
    if (_token == null || _userProfile == null) {
      return {
        'success': false,
        'message': 'You must be logged in to upload an avatar',
      };
    }

    try {
      final result = await AuthService.uploadAvatar(_token!, avatarFile);

      if (result['success']) {
        // Refresh the user profile after update to get the new avatar URL
        await fetchUserProfile();
        return {
          'success': true,
          'message': 'Avatar uploaded successfully',
        };
      }

      return {
        'success': false,
        'message': result['message'] ?? 'Failed to upload avatar',
      };
    } catch (e) {
      print('Error in uploadAvatar: $e');
      return {
        'success': false,
        'message': 'An error occurred while uploading your avatar',
      };
    }
  }

  Future<Map<String, dynamic>> removeAvatar() async {
    if (_token == null || _userProfile == null) {
      return {
        'success': false,
        'message': 'You must be logged in to remove your avatar',
      };
    }

    try {
      final result = await AuthService.removeAvatar(_token!);

      if (result['success']) {
        // Refresh the user profile after removal to update the avatar URL
        await fetchUserProfile();
        return {
          'success': true,
          'message': 'Avatar removed successfully',
        };
      }

      return {
        'success': false,
        'message': result['message'] ?? 'Failed to remove avatar',
      };
    } catch (e) {
      print('Error in removeAvatar: $e');
      return {
        'success': false,
        'message': 'An error occurred while removing your avatar',
      };
    }
  }
}
