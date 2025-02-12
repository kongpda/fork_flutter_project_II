import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_project_ii/models/user_profile.dart';

class ApiService {
  static Future<UserProfile> getUserProfile() async {
    // Replace with your actual API endpoint and implementation
    final response = await http.get(Uri.parse('YOUR_API_ENDPOINT/profile'));

    if (response.statusCode == 200) {
      return UserProfile.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  static Future<void> updateUserProfile({
    required String username,
    required String email,
  }) async {
    // Replace with your actual API endpoint and implementation
    final response = await http.put(
      Uri.parse('YOUR_API_ENDPOINT/profile'),
      body: {
        'username': username,
        'email': email,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile');
    }
  }
}
