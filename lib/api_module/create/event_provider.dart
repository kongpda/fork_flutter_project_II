import 'package:flutter/material.dart';
import 'package:flutter_project_ii/auth/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_project_ii/api_module/create/event_model.dart';
import 'package:provider/provider.dart';

class EventProvider with ChangeNotifier {

  Future<bool> createEvent(BuildContext context,Events event) async {
    print(event.toJson());
    try {
      final token = context.read<AuthProvider>().token;
      print(token);
      final response = await http.post(
        Uri.parse('https://events.iink.dev/api/events'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
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