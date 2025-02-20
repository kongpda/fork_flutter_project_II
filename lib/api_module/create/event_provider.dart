import 'package:flutter/material.dart';
import 'package:flutter_project_ii/auth/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_project_ii/api_module/create/event_model.dart';
import 'package:provider/provider.dart';

class EventProvider with ChangeNotifier {

  Future<bool> createEvent(BuildContext context,Event event) async {
    debugPrint('event: '+event.imageUrl.toString());
    try {
      final token = context.read<AuthProvider>().token;
      debugPrint('token: '+token.toString());
      final response = await http.post(
        Uri.parse('https://events.iink.dev/api/events'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
        body: json.encode({
          ...event.toJson(),
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

  
}