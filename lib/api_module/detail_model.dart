
class EventDetailModel {
    final Data data;

    EventDetailModel({
        required this.data,
    });

    factory EventDetailModel.fromJson(Map<String, dynamic> json) => EventDetailModel(
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
    final DataRelationships relationships;
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
        relationships: DataRelationships.fromJson(json["relationships"]),
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
    final String address;
    final String participationType;
    final int capacity;
    final DateTime registrationDeadline;
    final String registrationStatus;
    final String eventType;
    final String onlineUrl;
    final DateTime createdAt;
    final DateTime updatedAt;
    final int favoritesCount;
    final bool isFavorited;

    DataAttributes({
        required this.title,
        required this.featureImage,
        required this.startDate,
        required this.endDate,
        required this.slug,
        required this.description,
        required this.address,
        required this.participationType,
        required this.capacity,
        required this.registrationDeadline,
        required this.registrationStatus,
        required this.eventType,
        required this.onlineUrl,
        required this.createdAt,
        required this.updatedAt,
        required this.favoritesCount,
        required this.isFavorited,
    });

    factory DataAttributes.fromJson(Map<String, dynamic> json) => DataAttributes(
        title: json["title"],
        featureImage: json["feature_image"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        slug: json["slug"],
        description: json["description"],
        address: json["address"],
        participationType: json["participation_type"],
        capacity: json["capacity"],
        registrationDeadline: DateTime.parse(json["registration_deadline"]),
        registrationStatus: json["registration_status"],
        eventType: json["event_type"],
        onlineUrl: json["online_url"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        favoritesCount: json["favorites_count"],
        isFavorited: json["is_favorited"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "feature_image": featureImage,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "slug": slug,
        "description": description,
        "address": address,
        "participation_type": participationType,
        "capacity": capacity,
        "registration_deadline": registrationDeadline.toIso8601String(),
        "registration_status": registrationStatus,
        "event_type": eventType,
        "online_url": onlineUrl,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "favorites_count": favoritesCount,
        "is_favorited": isFavorited,
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

class DataRelationships {
    final Category category;
    final User user;
    final Organizer organizer;
    final List<Tag> tags;

    DataRelationships({
        required this.category,
        required this.user,
        required this.organizer,
        required this.tags,
    });

    factory DataRelationships.fromJson(Map<String, dynamic> json) => DataRelationships(
        category: Category.fromJson(json["category"]),
        user: User.fromJson(json["user"]),
        organizer: Organizer.fromJson(json["organizer"]),
        tags: List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "category": category.toJson(),
        "user": user.toJson(),
        "organizer": organizer.toJson(),
        "tags": List<dynamic>.from(tags.map((x) => x.toJson())),
    };
}

class Category {
    final String type;
    final int id;
    final CategoryAttributes attributes;
    final List<dynamic> relationship;
    final CategoryLinks links;

    Category({
        required this.type,
        required this.id,
        required this.attributes,
        required this.relationship,
        required this.links,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        type: json["type"],
        id: json["id"],
        attributes: CategoryAttributes.fromJson(json["attributes"]),
        relationship: List<dynamic>.from(json["relationship"].map((x) => x)),
        links: CategoryLinks.fromJson(json["links"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "attributes": attributes.toJson(),
        "relationship": List<dynamic>.from(relationship.map((x) => x)),
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
    final List<dynamic> relationships;
    final OrganizerLinks links;

    Organizer({
        required this.type,
        required this.id,
        required this.attributes,
        required this.relationships,
        required this.links,
    });

    factory Organizer.fromJson(Map<String, dynamic> json) => Organizer(
        type: json["type"],
        id: json["id"],
        attributes: OrganizerAttributes.fromJson(json["attributes"]),
        relationships: List<dynamic>.from(json["relationships"].map((x) => x)),
        links: OrganizerLinks.fromJson(json["links"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "attributes": attributes.toJson(),
        "relationships": List<dynamic>.from(relationships.map((x) => x)),
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

class Tag {
    final String type;
    final String id;
    final TagAttributes attributes;
    final TagRelationships relationships;
    final CategoryLinks links;

    Tag({
        required this.type,
        required this.id,
        required this.attributes,
        required this.relationships,
        required this.links,
    });

    factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        type: json["type"],
        id: json["id"],
        attributes: TagAttributes.fromJson(json["attributes"]),
        relationships: TagRelationships.fromJson(json["relationships"]),
        links: CategoryLinks.fromJson(json["links"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "attributes": attributes.toJson(),
        "relationships": relationships.toJson(),
        "links": links.toJson(),
    };
}

class TagAttributes {
    final String name;
    final String slug;
    final String description;
    final bool isActive;
    final int position;
    final DateTime createdAt;
    final DateTime updatedAt;

    TagAttributes({
        required this.name,
        required this.slug,
        required this.description,
        required this.isActive,
        required this.position,
        required this.createdAt,
        required this.updatedAt,
    });

    factory TagAttributes.fromJson(Map<String, dynamic> json) => TagAttributes(
        name: json["name"],
        slug: json["slug"],
        description: json["description"],
        isActive: json["is_active"],
        position: json["position"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
        "description": description,
        "is_active": isActive,
        "position": position,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class TagRelationships {
    final List<dynamic> events;

    TagRelationships({
        required this.events,
    });

    factory TagRelationships.fromJson(Map<String, dynamic> json) => TagRelationships(
        events: List<dynamic>.from(json["events"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "events": List<dynamic>.from(events.map((x) => x)),
    };
}

class User {
    final String type;
    final String id;
    final UserAttributes attributes;
    final TagRelationships relationships;
    final CategoryLinks links;

    User({
        required this.type,
        required this.id,
        required this.attributes,
        required this.relationships,
        required this.links,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        type: json["type"],
        id: json["id"],
        attributes: UserAttributes.fromJson(json["attributes"]),
        relationships: TagRelationships.fromJson(json["relationships"]),
        links: CategoryLinks.fromJson(json["links"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "attributes": attributes.toJson(),
        "relationships": relationships.toJson(),
        "links": links.toJson(),
    };
}

class UserAttributes {
    final String name;
    final String email;
    final DateTime createdAt;
    final DateTime updatedAt;

    UserAttributes({
        required this.name,
        required this.email,
        required this.createdAt,
        required this.updatedAt,
    });

    factory UserAttributes.fromJson(Map<String, dynamic> json) => UserAttributes(
        name: json["name"],
        email: json["email"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
