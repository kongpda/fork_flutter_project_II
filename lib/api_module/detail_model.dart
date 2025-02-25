// To parse this JSON data, do
//
//     final eventDetail = eventDetailFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

EventDetail eventDetailFromJson(String str) => EventDetail.fromJson(json.decode(str));

String eventDetailToJson(EventDetail data) => json.encode(data.toJson());

class EventDetail {
    final Data data;

    EventDetail({
        required this.data,
    });

    factory EventDetail.fromJson(Map<String, dynamic> json) => EventDetail(
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class Data {
    final String type;
    final String id;
    final DataAttributes attributes;
    final Relationships relationships;
    final DataLinks links;

    Data({
        required this.type,
        required this.id,
        required this.attributes,
        required this.relationships,
        required this.links,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        type: json["type"],
        id: json["id"],
        attributes: DataAttributes.fromJson(json["attributes"]),
        relationships: Relationships.fromJson(json["relationships"]),
        links: DataLinks.fromJson(json["links"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "attributes": attributes.toJson(),
        "relationships": relationships.toJson(),
        "links": links.toJson(),
    };
}

class DataAttributes {
    final String title;
    final String featureImage;
    final DateTime startDate;
    final DateTime endDate;
    final String slug;
    final String description;
    final String location;
    final String participationType;
    final String registrationStatus;
    final String eventType;
    final String status;
    final DateTime createdAt;
    final DateTime updatedAt;
    final int favoritesCount;
    final bool isFavorited;
    final bool isFeatured;

    DataAttributes({
        required this.title,
        required this.featureImage,
        required this.startDate,
        required this.endDate,
        required this.slug,
        required this.description,
        required this.location,
        required this.participationType,
        required this.registrationStatus,
        required this.eventType,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.favoritesCount,
        required this.isFavorited,
        required this.isFeatured,
    });

    factory DataAttributes.fromJson(Map<String, dynamic> json) => DataAttributes(
        title: json["title"],
        featureImage: json["feature_image"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        slug: json["slug"],
        description: json["description"],
        location: json["location"],
        participationType: json["participation_type"],
        registrationStatus: json["registration_status"],
        eventType: json["event_type"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        favoritesCount: json["favorites_count"],
        isFavorited: json["is_favorited"],
        isFeatured: json["is_featured"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "feature_image": featureImage,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "slug": slug,
        "description": description,
        "location": location,
        "participation_type": participationType,
        "registration_status": registrationStatus,
        "event_type": eventType,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "favorites_count": favoritesCount,
        "is_favorited": isFavorited,
        "is_featured": isFeatured,
    };
}

class DataLinks {
    final String self;
    final String toggleFavorite;

    DataLinks({
        required this.self,
        required this.toggleFavorite,
    });

    factory DataLinks.fromJson(Map<String, dynamic> json) => DataLinks(
        self: json["self"],
        toggleFavorite: json["toggleFavorite"],
    );

    Map<String, dynamic> toJson() => {
        "self": self,
        "toggleFavorite": toggleFavorite,
    };
}

class Relationships {
    final Category category;
    final User user;
    final Organizer organizer;

    Relationships({
        required this.category,
        required this.user,
        required this.organizer,
    });

    factory Relationships.fromJson(Map<String, dynamic> json) => Relationships(
        category: Category.fromJson(json["category"]),
        user: User.fromJson(json["user"]),
        organizer: Organizer.fromJson(json["organizer"]),
    );

    Map<String, dynamic> toJson() => {
        "category": category.toJson(),
        "user": user.toJson(),
        "organizer": organizer.toJson(),
    };
}

class Category {
    final String type;
    final int id;
    final CategoryAttributes attributes;
    final List<dynamic> relationships;
    final CategoryLinks links;

    Category({
        required this.type,
        required this.id,
        required this.attributes,
        required this.relationships,
        required this.links,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        type: json["type"],
        id: json["id"],
        attributes: CategoryAttributes.fromJson(json["attributes"]),
        relationships: List<dynamic>.from(json["relationships"].map((x) => x)),
        links: CategoryLinks.fromJson(json["links"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "attributes": attributes.toJson(),
        "relationships": List<dynamic>.from(relationships.map((x) => x)),
        "links": links.toJson(),
    };
}

class CategoryAttributes {
    final String name;
    final String slug;

    CategoryAttributes({
        required this.name,
        required this.slug,
    });

    factory CategoryAttributes.fromJson(Map<String, dynamic> json) => CategoryAttributes(
        name: json["name"],
        slug: json["slug"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
    };
}

class CategoryLinks {
    final String self;

    CategoryLinks({
        required this.self,
    });

    factory CategoryLinks.fromJson(Map<String, dynamic> json) => CategoryLinks(
        self: json["self"],
    );

    Map<String, dynamic> toJson() => {
        "self": self,
    };
}

class Organizer {
    final String type;
    final String id;
    final OrganizerAttributes attributes;
    final OrganizerLinks links;

    Organizer({
        required this.type,
        required this.id,
        required this.attributes,
        required this.links,
    });

    factory Organizer.fromJson(Map<String, dynamic> json) => Organizer(
        type: json["type"],
        id: json["id"],
        attributes: OrganizerAttributes.fromJson(json["attributes"]),
        links: OrganizerLinks.fromJson(json["links"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "attributes": attributes.toJson(),
        "links": links.toJson(),
    };
}

class OrganizerAttributes {
    final String name;
    final String slug;
    final String email;
    final String phone;

    OrganizerAttributes({
        required this.name,
        required this.slug,
        required this.email,
        required this.phone,
    });

    factory OrganizerAttributes.fromJson(Map<String, dynamic> json) => OrganizerAttributes(
        name: json["name"],
        slug: json["slug"],
        email: json["email"],
        phone: json["phone"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
        "email": email,
        "phone": phone,
    };
}

class OrganizerLinks {
    final String self;
    final String events;

    OrganizerLinks({
        required this.self,
        required this.events,
    });

    factory OrganizerLinks.fromJson(Map<String, dynamic> json) => OrganizerLinks(
        self: json["self"],
        events: json["events"],
    );

    Map<String, dynamic> toJson() => {
        "self": self,
        "events": events,
    };
}

class User {
    final String id;
    final String name;
    final String email;
    final Profile profile;

    User({
        required this.id,
        required this.name,
        required this.email,
        required this.profile,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        profile: Profile.fromJson(json["profile"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "profile": profile.toJson(),
    };
}

class Profile {
    final String firstName;
    final String lastName;
    final String avatar;

    Profile({
        required this.firstName,
        required this.lastName,
        required this.avatar,
    });

    factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        firstName: json["first_name"],
        lastName: json["last_name"],
        avatar: json["avatar"],
    );

    Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "avatar": avatar,
    };
}
