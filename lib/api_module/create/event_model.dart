import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Events {
  final String name;
  final String description;
  final String startDate;
  final String endDate;
  final String location;
  final String category;
  final String participantsType;
  final String eventType;
  final String regStatus;
  final String? imageUrl;

  Events({
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.category,
    required this.participantsType,
    required this.eventType,
    required this.regStatus,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': name,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'location': location,
      'category_id': category,
      'participation_type': participantsType,
      'event_type': eventType,
      'registration_status': regStatus,
      'feature_image': imageUrl,
    };
  }
}