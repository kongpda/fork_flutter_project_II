// To parse this JSON data, do
//
//     final eventParticipant = eventParticipantFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

EventParticipant eventParticipantFromJson(String str) => EventParticipant.fromJson(json.decode(str));

String eventParticipantToJson(EventParticipant data) => json.encode(data.toJson());

class EventParticipant {
    final String eventId;
    final String userId;
    final String status;
    final String participationType;
    final String ticketTypeId;
    final DateTime checkInTime;
    final DateTime joinedAt;

    EventParticipant({
        required this.eventId,
        required this.userId,
        required this.status,
        required this.participationType,
        required this.ticketTypeId,
        required this.checkInTime,
        required this.joinedAt,
    });

    factory EventParticipant.fromJson(Map<String, dynamic> json) => EventParticipant(
        eventId: json["event_id"],
        userId: json["user_id"],
        status: json["status"],
        participationType: json["participation_type"],
        ticketTypeId: json["ticket_type_id"],
        checkInTime: DateTime.parse(json["check_in_time"]),
        joinedAt: DateTime.parse(json["joined_at"]),
    );

    Map<String, dynamic> toJson() => {
        "event_id": eventId,
        "user_id": userId,
        "status": status,
        "participation_type": participationType,
        "ticket_type_id": ticketTypeId,
        "check_in_time": checkInTime.toIso8601String(),
        "joined_at": joinedAt.toIso8601String(),
    };
}
