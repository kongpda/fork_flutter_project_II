// To parse this JSON data, do
//
//     final eventParticipant = eventParticipantFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

EventParticipant eventParticipantFromJson(String str) => EventParticipant.fromJson(json.decode(str));

String eventParticipantToJson(EventParticipant data) => json.encode(data.toJson());

class EventParticipant {
    final String status;
    final String participationType;
    final String ticketTypeId;

    EventParticipant({
        required this.status,
        required this.participationType,
        required this.ticketTypeId,
    });

    factory EventParticipant.fromJson(Map<String, dynamic> json) => EventParticipant(
        status: json["status"],
        participationType: json["participation_type"],
        ticketTypeId: json["ticket_type_id"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "participation_type": participationType,
        "ticket_type_id": ticketTypeId,
    };
}
