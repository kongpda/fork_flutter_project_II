import 'dart:io';

class Event {
  final String name;
  final String description;
  final String startDate;
  final String endDate;
  final String location;
  final String category;
  final String capacity;
  final String participantsType;
  final String eventType;
  final String status;
  final File? imageFile;

  Event({
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.category,
    required this.capacity,
    required this.participantsType,
    required this.eventType,
    required this.status,
    this.imageFile,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'location': location,
      'category': category,
      'capacity': capacity,
      'participantsType': participantsType,
      'eventType': eventType,
      'status': status,
    };
  }
}