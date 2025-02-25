// To parse this JSON data, do
//
//     final eventDetail = eventDetailFromJson(jsonString);

import 'dart:convert';

EventDetail eventDetailFromJson(String str) => EventDetail.fromJson(json.decode(str));

String eventDetailToJson(EventDetail data) => json.encode(data.toJson());

class EventDetail {
    Data? data;

    EventDetail({
        this.data,
    });

    factory EventDetail.fromJson(Map<String, dynamic> json) => EventDetail(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
    };
}

class Data {
    String? type;
    String? id;
    DataAttributes? attributes;
    Relationships? relationships;
    DataLinks? links;

    Data({
        this.type,
        this.id,
        this.attributes,
        this.relationships,
        this.links,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        type: json["type"],
        id: json["id"],
        attributes: json["attributes"] == null ? null : DataAttributes.fromJson(json["attributes"]),
        relationships: json["relationships"] == null ? null : Relationships.fromJson(json["relationships"]),
        links: json["links"] == null ? null : DataLinks.fromJson(json["links"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "attributes": attributes?.toJson(),
        "relationships": relationships?.toJson(),
        "links": links?.toJson(),
    };
}

class DataAttributes {
    String? title;
    String? featureImage;
    DateTime? startDate;
    DateTime? endDate;
    String? slug;
    String? description;
    String? location;
    String? participationType;
    String? registrationStatus;
    String? eventType;
    String? status;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? favoritesCount;
    bool? isFavorited;
    bool? isFeatured;

    DataAttributes({
        this.title,
        this.featureImage,
        this.startDate,
        this.endDate,
        this.slug,
        this.description,
        this.location,
        this.participationType,
        this.registrationStatus,
        this.eventType,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.favoritesCount,
        this.isFavorited,
        this.isFeatured,
    });

    factory DataAttributes.fromJson(Map<String, dynamic> json) => DataAttributes(
        title: json["title"],
        featureImage: json["feature_image"],
        startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
        endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        slug: json["slug"],
        description: json["description"],
        location: json["location"],
        participationType: json["participation_type"],
        registrationStatus: json["registration_status"],
        eventType: json["event_type"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        favoritesCount: json["favorites_count"],
        isFavorited: json["is_favorited"],
        isFeatured: json["is_featured"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "feature_image": featureImage,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "slug": slug,
        "description": description,
        "location": location,
        "participation_type": participationType,
        "registration_status": registrationStatus,
        "event_type": eventType,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "favorites_count": favoritesCount,
        "is_favorited": isFavorited,
        "is_featured": isFeatured,
    };
}

class DataLinks {
    String? self;
    String? toggleFavorite;

    DataLinks({
        this.self,
        this.toggleFavorite,
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
    Category? category;
    User? user;
    Organizer? organizer;
    List<dynamic>? tags;

    Relationships({
        this.category,
        this.user,
        this.organizer,
        this.tags,
    });

    factory Relationships.fromJson(Map<String, dynamic> json) => Relationships(
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        organizer: json["organizer"] == null ? null : Organizer.fromJson(json["organizer"]),
        tags: json["tags"] == null ? [] : List<dynamic>.from(json["tags"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "category": category?.toJson(),
        "user": user?.toJson(),
        "organizer": organizer?.toJson(),
        "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
    };
}

class Category {
    String? type;
    int? id;
    CategoryAttributes? attributes;
    List<dynamic>? relationships;
    CategoryLinks? links;

    Category({
        this.type,
        this.id,
        this.attributes,
        this.relationships,
        this.links,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        type: json["type"],
        id: json["id"],
        attributes: json["attributes"] == null ? null : CategoryAttributes.fromJson(json["attributes"]),
        relationships: json["relationships"] == null ? [] : List<dynamic>.from(json["relationships"]!.map((x) => x)),
        links: json["links"] == null ? null : CategoryLinks.fromJson(json["links"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "attributes": attributes?.toJson(),
        "relationships": relationships == null ? [] : List<dynamic>.from(relationships!.map((x) => x)),
        "links": links?.toJson(),
    };
}

class CategoryAttributes {
    String? name;
    String? slug;

    CategoryAttributes({
        this.name,
        this.slug,
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
    String? self;

    CategoryLinks({
        this.self,
    });

    factory CategoryLinks.fromJson(Map<String, dynamic> json) => CategoryLinks(
        self: json["self"],
    );

    Map<String, dynamic> toJson() => {
        "self": self,
    };
}

class Organizer {
    String? type;
    String? id;
    OrganizerAttributes? attributes;
    List<dynamic>? relationships;
    OrganizerLinks? links;

    Organizer({
        this.type,
        this.id,
        this.attributes,
        this.relationships,
        this.links,
    });

    factory Organizer.fromJson(Map<String, dynamic> json) => Organizer(
        type: json["type"],
        id: json["id"],
        attributes: json["attributes"] == null ? null : OrganizerAttributes.fromJson(json["attributes"]),
        relationships: json["relationships"] == null ? [] : List<dynamic>.from(json["relationships"]!.map((x) => x)),
        links: json["links"] == null ? null : OrganizerLinks.fromJson(json["links"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "attributes": attributes?.toJson(),
        "relationships": relationships == null ? [] : List<dynamic>.from(relationships!.map((x) => x)),
        "links": links?.toJson(),
    };
}

class OrganizerAttributes {
    String? name;
    String? slug;
    String? email;
    String? phone;

    OrganizerAttributes({
        this.name,
        this.slug,
        this.email,
        this.phone,
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
    String? self;
    String? events;

    OrganizerLinks({
        this.self,
        this.events,
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
    String? id;
    String? name;
    String? email;
    Profile? profile;

    User({
        this.id,
        this.name,
        this.email,
        this.profile,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        profile: json["profile"] == null ? null : Profile.fromJson(json["profile"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "profile": profile?.toJson(),
    };
}

class Profile {
    String? firstName;
    String? lastName;
    String? avatar;

    Profile({
        this.firstName,
        this.lastName,
        this.avatar,
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
