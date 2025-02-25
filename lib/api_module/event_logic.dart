import 'package:flutter/material.dart';
import 'package:flutter_project_ii/api_module/detail_model.dart';
import 'package:flutter_project_ii/api_module/event_model.dart';
import 'package:flutter_project_ii/auth/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class EventLogic with ChangeNotifier {
  List<Event> _events = [];
  bool _isLoading = false;
  String _error = '';

  List<Event> get records => _events;
  bool get isLoading => _isLoading;
  String get error => _error;

  bool _isFavorited = false;
  bool get isFavorited => _isFavorited;

  EventDetail? _eventDetail;
  EventDetail? get eventDetail => _eventDetail;

  List<Event> _eventsByOrganizer = [];
  List<Event> get eventsByOrganizer => _eventsByOrganizer;

  void setLoading(){
    _isLoading = true;
    notifyListeners();
  }
List<Event> get favoritedEvents => _events.where((event) => event.attributes.isFavorited).toList();




  Future<void> addFavorite(Event event, BuildContext context) async {
    try {
      final token = context.read<AuthProvider>().token;
      final eventId = event.id;
      final response = await http.post(
        Uri.parse('https://events.iink.dev/api/events/$eventId/toggle-favorite'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      debugPrint('Response: ' + response.body);

      if (response.statusCode == 200) {
        debugPrint('Favorite updated');
        notifyListeners();
      } else {
        _error = 'Failed to update favorite status';
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
Future<void> read(BuildContext context) async {
    _isLoading = true;
    _error = '';
    notifyListeners();
    try {
      final token = context.read<AuthProvider>().token;
      debugPrint('token: '+token.toString());
      final response = await http.get(
        Uri.parse('https://events.iink.dev/api/events'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          _events = (data['data'] as List)
              .map((json) => Event.fromJson(json))
              .toList();
        } else {
          _error = 'No event data found';
        }
      } else {
        _error = 'Failed to load events';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> getEventDetail(BuildContext context,String eventId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

      final token = context.read<AuthProvider>().token;
    try {
      final response = await http.get(
        Uri.parse('https://events.iink.dev/api/events/$eventId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('data: '+data['data'].toString());
        if (data['data'] != null) {
          _eventDetail = EventDetail.fromJson(data['data']);
          debugPrint('eventDetail: '+_eventDetail.toString());
        }
        else{
          _error = 'Failed to load event data';
        }
      } else {
        _error = 'Failed to load event data';
      }
    } catch (e) {
      _error = 'Error fetching event data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> readByOrganizer(BuildContext context) async {
    _isLoading = true;
    _error = '';
    notifyListeners();
    try {
      final token = context.read<AuthProvider>().token;
      final response = await http.get(
        Uri.parse('https://events.iink.dev/api/user/events'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          _eventsByOrganizer = (data['data'] as List)
              .map((event) => Event.fromJson(event))
              .toList();
        }
      } else {
        _error = 'Failed to load events';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}