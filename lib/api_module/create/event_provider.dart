import 'package:flutter/material.dart';
import 'package:flutter_project_ii/auth/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter_project_ii/api_module/create/event_model.dart';
import 'package:provider/provider.dart';

class EventProvider with ChangeNotifier {
  final String _baseUrl = 'https://events.iink.dev/api/events'; // Replace with your API URL

  Future<bool> createEvent(BuildContext context,Event event) async {
    try {
      // First, upload the image if it exists
      String? imageUrl;
      if (event.imageFile != null) {
        imageUrl = await _uploadImage(event.imageFile!);
      }

      // Create the event with the image URL
      final token = context.read<AuthProvider>().token;
      final response = await http.post(
        Uri.parse('$_baseUrl/events'),
        headers: {
          'Content-Type': 'application/json',
          // Add any authentication headers if needed
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          ...event.toJson(),
          'imageUrl': imageUrl,
        }),
      );

      if (response.statusCode == 201) {
        notifyListeners();
        return true;
      } else {
        throw Exception('Failed to create event');
      }
    } catch (e) {
      print('Error creating event: $e');
      return false;
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/upload'),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      
      if (response.statusCode == 200) {
        var data = json.decode(responseString);
        return data['imageUrl'];
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }
}