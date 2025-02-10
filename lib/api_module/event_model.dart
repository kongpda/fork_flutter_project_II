import 'dart:convert';

EventModel eventModelFromJson(String str) => EventModel.fromJson(json.decode(str));

String eventModelToJson(EventModel data) => json.encode(data.toJson());

class EventModel {
    final List<Event> data;

    EventModel({
        required this.data,
    });

    factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        data: List<Event>.from(json["data"].map((x) => Event.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Event {
    final int id;
    final String title;
    final String slug;
    final String description;
    final String address;
    final String featureImage;
    final String startDate;
    final String endDate;
    final String status;
    final String userId;
    final List<Category> categories;
    final List<Category> tags;
    final String createdAt;
    final String updatedAt;

    Event({
        required this.id,
        required this.title,
        required this.slug,
        required this.description,
        required this.address,
        required this.featureImage,
        required this.startDate,
        required this.endDate,
        required this.status,
        required this.userId,
        required this.categories,
        required this.tags,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["id"],
        title: json["title"],
        slug: json["slug"],
        description: json["description"],
        address: json["address"],
        featureImage: json["feature_image"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        status: json["status"],
        userId: json["user_id"],
        categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
        tags: List<Category>.from(json["tags"].map((x) => Category.fromJson(x))),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "slug": slug,
        "description": description,
        "address": address,
        "feature_image": featureImage,
        "start_date": startDate,
        "end_date": endDate,
        "status": status,
        "user_id": userId,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "tags": List<dynamic>.from(tags.map((x) => x.toJson())),
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}

class Category {
    final int id;
    final String name;
    final String slug;
    final String createdAt;
    final String updatedAt;

    Category({
        required this.id,
        required this.name,
        required this.slug,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
