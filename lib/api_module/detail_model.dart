class EventDetail {
  final String id;
  final String title;
  final String featureImage;
  final DateTime startDate;
  final DateTime endDate;
  final String slug;
  final String description;
  final String location;
  final String participationType;
  final int capacity;
  final DateTime registrationDeadline;
  final String registrationStatus;
  final String eventType;
  final String? onlineUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int favoritesCount;
  final bool isFavorited;
  final bool isFeatured;
  final Category category;
  final User user;
  final Organizer organizer;
  final List<dynamic> tags;

  EventDetail({
    required this.id,
    required this.title,
    required this.featureImage,
    required this.startDate,
    required this.endDate,
    required this.slug,
    required this.description,
    required this.location,
    required this.participationType,
    required this.capacity,
    required this.registrationDeadline,
    required this.registrationStatus,
    required this.eventType,
    this.onlineUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.favoritesCount,
    required this.isFavorited,
    required this.isFeatured,
    required this.category,
    required this.user,
    required this.organizer,
    required this.tags,
  });

  factory EventDetail.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'];
    final relationships = json['relationships'];
    
    return EventDetail(
      id: json['id'],
      title: attributes['title'],
      featureImage: attributes['feature_image'],
      startDate: DateTime.parse(attributes['start_date']),
      endDate: DateTime.parse(attributes['end_date']),
      slug: attributes['slug'],
      description: attributes['description'],
      location: attributes['location'],
      participationType: attributes['participation_type'],
      capacity: attributes['capacity'],
      registrationDeadline: DateTime.parse(attributes['registration_deadline']),
      registrationStatus: attributes['registration_status'],
      eventType: attributes['event_type'],
      onlineUrl: attributes['online_url'],
      createdAt: DateTime.parse(attributes['created_at']),
      updatedAt: DateTime.parse(attributes['updated_at']),
      favoritesCount: attributes['favorites_count'],
      isFavorited: attributes['is_favorited'],
      isFeatured: attributes['is_featured'],
      category: Category.fromJson(relationships['category']),
      user: User.fromJson(relationships['user']),
      organizer: Organizer.fromJson(relationships['organizer']),
      tags: relationships['tags'],
    );
  }
}

// Category model
class Category {
  final int id;
  final String name;
  final String slug;
  
  Category({
    required this.id,
    required this.name,
    required this.slug,
  });
  
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['attributes']['name'],
      slug: json['attributes']['slug'],
    );
  }
}

// User model
class User {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['attributes']['name'],
      email: json['attributes']['email'],
      createdAt: DateTime.parse(json['attributes']['created_at']),
      updatedAt: DateTime.parse(json['attributes']['updated_at']),
    );
  }
}

// Organizer model
class Organizer {
  final String id;
  final String name;
  final String slug;
  final String email;
  final String phone;
  
  Organizer({
    required this.id,
    required this.name,
    required this.slug,
    required this.email,
    required this.phone,
  });
  
  factory Organizer.fromJson(Map<String, dynamic> json) {
    return Organizer(
      id: json['id'],
      name: json['attributes']['name'],
      slug: json['attributes']['slug'],
      email: json['attributes']['email'],
      phone: json['attributes']['phone'],
    );
  }
}