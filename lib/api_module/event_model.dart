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
    final String type;
    final String id;
    final DatumAttributes attributes;
    final DatumRelationships relationships;
    final DatumLinks links;

    Event({
        required this.type,
        required this.id,
        required this.attributes,
        required this.relationships,
        required this.links,
    });

    factory Event.fromJson(Map<String, dynamic> json) => Event(
        type: json["type"],
        id: json["id"],
        attributes: DatumAttributes.fromJson(json["attributes"]),
        relationships: DatumRelationships.fromJson(json["relationships"]),
        links: DatumLinks.fromJson(json["links"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "attributes": attributes.toJson(),
        "relationships": relationships.toJson(),
        "links": links.toJson(),
    };
}

class DatumAttributes {
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
    final String favoritesCount;
    final bool isFavorited;

    DatumAttributes({
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

    factory DatumAttributes.fromJson(Map<String, dynamic> json) => DatumAttributes(
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

class DatumLinks {
    final String self;
    final String toggleFavorite;

    DatumLinks({
        required this.self,
        required this.toggleFavorite,
    });

    factory DatumLinks.fromJson(Map<String, dynamic> json) => DatumLinks(
        self: json["self"],
        toggleFavorite: json["toggleFavorite"],
    );

    Map<String, dynamic> toJson() => {
        "self": self,
        "toggleFavorite": toggleFavorite,
    };
}

class DatumRelationships {
    final Category category;
    final User user;
    final Organizer organizer;
    final List<Tag> tags;
    final List<Participant> participants;

    DatumRelationships({
        required this.category,
        required this.user,
        required this.organizer,
        required this.tags,
        required this.participants,
    });

    factory DatumRelationships.fromJson(Map<String, dynamic> json) => DatumRelationships(
        category: Category.fromJson(json["category"]),
        user: User.fromJson(json["user"]),
        organizer: Organizer.fromJson(json["organizer"]),
        tags: List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))),
        participants: List<Participant>.from(json["participants"].map((x) => Participant.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "category": category.toJson(),
        "user": user.toJson(),
        "organizer": organizer.toJson(),
        "tags": List<dynamic>.from(tags.map((x) => x.toJson())),
        "participants": List<dynamic>.from(participants.map((x) => x.toJson())),
    };
}

class Category {
    final String type;
    final int id;
    final CategoryAttributes attributes;
    final RelationshipsClass relationship;
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
        relationship: RelationshipsClass.fromJson(json["relationship"]),
        links: CategoryLinks.fromJson(json["links"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "attributes": attributes.toJson(),
        "relationship": relationship.toJson(),
        "links": links.toJson(),
    };
}

class CategoryAttributes {
    final String name;
    final String slug;
    final String description;
    final bool isActive;
    final int position;
    final String createdAt;
    final String updatedAt;

    CategoryAttributes({
        required this.name,
        required this.slug,
        required this.description,
        required this.isActive,
        required this.position,
        required this.createdAt,
        required this.updatedAt,
    });

    factory CategoryAttributes.fromJson(Map<String, dynamic> json) => CategoryAttributes(
        name: json["name"],
        slug: json["slug"],
        description: json["description"],
        isActive: json["is_active"],
        position: json["position"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
        "description": description,
        "is_active": isActive,
        "position": position,
        "created_at": createdAt,
        "updated_at": updatedAt,
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

class RelationshipsClass {
    final List<EventList> events;

    RelationshipsClass({
        required this.events,
    });

    factory RelationshipsClass.fromJson(Map<String, dynamic> json) => RelationshipsClass(
        events: List<EventList>.from(json["events"].map((x) => EventList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "events": List<dynamic>.from(events.map((x) => x.toJson())),
    };
}

class EventList {
    EventList();

    factory EventList.fromJson(Map<String, dynamic> json) => EventList(
    );

    Map<String, dynamic> toJson() => {
    };
}

class Organizer {
    final String type;
    final String id;
    final OrganizerAttributes attributes;
    final OrganizerRelationships relationships;
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
        relationships: OrganizerRelationships.fromJson(json["relationships"]),
        links: OrganizerLinks.fromJson(json["links"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "attributes": attributes.toJson(),
        "relationships": relationships.toJson(),
        "links": links.toJson(),
    };
}

class OrganizerAttributes {
    final String name;
    final String slug;
    final String email;
    final String phone;
    final String description;
    final String address;
    final String website;
    final String socialMedia;
    final String logo;
    final bool isVerified;
    final DateTime createdAt;
    final DateTime updatedAt;
    final String eventsCount;
    final String upcomingEventsCount;
    final String pastEventsCount;

    OrganizerAttributes({
        required this.name,
        required this.slug,
        required this.email,
        required this.phone,
        required this.description,
        required this.address,
        required this.website,
        required this.socialMedia,
        required this.logo,
        required this.isVerified,
        required this.createdAt,
        required this.updatedAt,
        required this.eventsCount,
        required this.upcomingEventsCount,
        required this.pastEventsCount,
    });

    factory OrganizerAttributes.fromJson(Map<String, dynamic> json) => OrganizerAttributes(
        name: json["name"],
        slug: json["slug"],
        email: json["email"],
        phone: json["phone"],
        description: json["description"],
        address: json["address"],
        website: json["website"],
        socialMedia: json["social_media"],
        logo: json["logo"],
        isVerified: json["is_verified"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        eventsCount: json["events_count"],
        upcomingEventsCount: json["upcoming_events_count"],
        pastEventsCount: json["past_events_count"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
        "email": email,
        "phone": phone,
        "description": description,
        "address": address,
        "website": website,
        "social_media": socialMedia,
        "logo": logo,
        "is_verified": isVerified,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "events_count": eventsCount,
        "upcoming_events_count": upcomingEventsCount,
        "past_events_count": pastEventsCount,
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

class OrganizerRelationships {
    final User user;
    final List<EventList> events;

    OrganizerRelationships({
        required this.user,
        required this.events,
    });

    factory OrganizerRelationships.fromJson(Map<String, dynamic> json) => OrganizerRelationships(
        user: User.fromJson(json["user"]),
        events: List<EventList>.from(json["events"].map((x) => EventList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "events": List<dynamic>.from(events.map((x) => x.toJson())),
    };
}

class User {
    final String type;
    final String id;
    final UserAttributes attributes;
    final RelationshipsClass relationships;
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
        relationships: RelationshipsClass.fromJson(json["relationships"]),
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

class Participant {
    final String type;
    final int id;
    final ParticipantAttributes attributes;
    final ParticipantRelationship relationship;

    Participant({
        required this.type,
        required this.id,
        required this.attributes,
        required this.relationship,
    });

    factory Participant.fromJson(Map<String, dynamic> json) => Participant(
        type: json["type"],
        id: json["id"],
        attributes: ParticipantAttributes.fromJson(json["attributes"]),
        relationship: ParticipantRelationship.fromJson(json["relationship"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "attributes": attributes.toJson(),
        "relationship": relationship.toJson(),
    };
}

class ParticipantAttributes {
    final String eventId;
    final String userId;
    final String status;
    final String participationType;
    final String ticketId;
    final DateTime checkInTime;
    final DateTime joinedAt;
    final DateTime createdAt;
    final DateTime updatedAt;

    ParticipantAttributes({
        required this.eventId,
        required this.userId,
        required this.status,
        required this.participationType,
        required this.ticketId,
        required this.checkInTime,
        required this.joinedAt,
        required this.createdAt,
        required this.updatedAt,
    });

    factory ParticipantAttributes.fromJson(Map<String, dynamic> json) => ParticipantAttributes(
        eventId: json["event_id"],
        userId: json["user_id"],
        status: json["status"],
        participationType: json["participation_type"],
        ticketId: json["ticket_id"],
        checkInTime: DateTime.parse(json["check_in_time"]),
        joinedAt: DateTime.parse(json["joined_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "event_id": eventId,
        "user_id": userId,
        "status": status,
        "participation_type": participationType,
        "ticket_id": ticketId,
        "check_in_time": checkInTime.toIso8601String(),
        "joined_at": joinedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class ParticipantRelationship {
    final EventList event;
    final User user;
    final Ticket ticket;

    ParticipantRelationship({
        required this.event,
        required this.user,
        required this.ticket,
    });

    factory ParticipantRelationship.fromJson(Map<String, dynamic> json) => ParticipantRelationship(
        event: EventList.fromJson(json["event"]),
        user: User.fromJson(json["user"]),
        ticket: Ticket.fromJson(json["ticket"]),
    );

    Map<String, dynamic> toJson() => {
        "event": event.toJson(),
        "user": user.toJson(),
        "ticket": ticket.toJson(),
    };
}

class Ticket {
    final String type;
    final String id;
    final TicketAttributes attributes;
    final TicketRelationships relationships;
    final String included;
    final TicketLinks links;

    Ticket({
        required this.type,
        required this.id,
        required this.attributes,
        required this.relationships,
        required this.included,
        required this.links,
    });

    factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        type: json["type"],
        id: json["id"],
        attributes: TicketAttributes.fromJson(json["attributes"]),
        relationships: TicketRelationships.fromJson(json["relationships"]),
        included: json["included"],
        links: TicketLinks.fromJson(json["links"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "attributes": attributes.toJson(),
        "relationships": relationships.toJson(),
        "included": included,
        "links": links.toJson(),
    };
}

class TicketAttributes {
    final String status;
    final String purchaseDate;
    final String price;
    final String createdAt;
    final String updatedAt;

    TicketAttributes({
        required this.status,
        required this.purchaseDate,
        required this.price,
        required this.createdAt,
        required this.updatedAt,
    });

    factory TicketAttributes.fromJson(Map<String, dynamic> json) => TicketAttributes(
        status: json["status"],
        purchaseDate: json["purchase_date"],
        price: json["price"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "purchase_date": purchaseDate,
        "price": price,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}

class TicketLinks {
    final String self;
    final String event;
    final String user;
    final String ticketType;

    TicketLinks({
        required this.self,
        required this.event,
        required this.user,
        required this.ticketType,
    });

    factory TicketLinks.fromJson(Map<String, dynamic> json) => TicketLinks(
        self: json["self"],
        event: json["event"],
        user: json["user"],
        ticketType: json["ticket_type"],
    );

    Map<String, dynamic> toJson() => {
        "self": self,
        "event": event,
        "user": user,
        "ticket_type": ticketType,
    };
}

class TicketRelationships {
    final Events events;
    final Events user;
    final Events ticketTypes;

    TicketRelationships({
        required this.events,
        required this.user,
        required this.ticketTypes,
    });

    factory TicketRelationships.fromJson(Map<String, dynamic> json) => TicketRelationships(
        events: Events.fromJson(json["events"]),
        user: Events.fromJson(json["user"]),
        ticketTypes: Events.fromJson(json["ticket_types"]),
    );

    Map<String, dynamic> toJson() => {
        "events": events.toJson(),
        "user": user.toJson(),
        "ticket_types": ticketTypes.toJson(),
    };
}

class Events {
    final Data data;

    Events({
        required this.data,
    });

    factory Events.fromJson(Map<String, dynamic> json) => Events(
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class Data {
    final String type;
    final String id;

    Data({
        required this.type,
        required this.id,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        type: json["type"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
    };
}

class Tag {
    final String type;
    final String id;
    final CategoryAttributes attributes;
    final RelationshipsClass relationships;
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
        attributes: CategoryAttributes.fromJson(json["attributes"]),
        relationships: RelationshipsClass.fromJson(json["relationships"]),
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
