// To parse this JSON data, do
//
//     final eventCategory = eventCategoryFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

EventCategory eventCategoryFromJson(String str) => EventCategory.fromJson(json.decode(str));

String eventCategoryToJson(EventCategory data) => json.encode(data.toJson());

class EventCategory {
    final List<Category> data;
    final EventCategoryLinks links;
    final Meta meta;

    EventCategory({
        required this.data,
        required this.links,
        required this.meta,
    });

    factory EventCategory.fromJson(Map<String, dynamic> json) => EventCategory(
        data: List<Category>.from(json["data"].map((x) => Category.fromJson(x))),
        links: EventCategoryLinks.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "links": links.toJson(),
        "meta": meta.toJson(),
    };
}

class Category {
    final Type type;
    final int id;
    final Attributes attributes;
    final List<dynamic> relationships;
    final DatumLinks links;

    Category({
        required this.type,
        required this.id,
        required this.attributes,
        required this.relationships,
        required this.links,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        type: typeValues.map[json["type"]]!,
        id: json["id"],
        attributes: Attributes.fromJson(json["attributes"]),
        relationships: List<dynamic>.from(json["relationships"].map((x) => x)),
        links: DatumLinks.fromJson(json["links"]),
    );

    Map<String, dynamic> toJson() => {
        "type": typeValues.reverse[type],
        "id": id,
        "attributes": attributes.toJson(),
        "relationships": List<dynamic>.from(relationships.map((x) => x)),
        "links": links.toJson(),
    };
}

class Attributes {
    final String name;
    final String slug;

    Attributes({
        required this.name,
        required this.slug,
    });

    factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        name: json["name"],
        slug: json["slug"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
    };
}

class DatumLinks {
    final String self;

    DatumLinks({
        required this.self,
    });

    factory DatumLinks.fromJson(Map<String, dynamic> json) => DatumLinks(
        self: json["self"],
    );

    Map<String, dynamic> toJson() => {
        "self": self,
    };
}

enum Type {
    CATEGORIES
}

final typeValues = EnumValues({
    "categories": Type.CATEGORIES
});

class EventCategoryLinks {
    final String first;
    final String last;
    final dynamic prev;
    final dynamic next;

    EventCategoryLinks({
        required this.first,
        required this.last,
        required this.prev,
        required this.next,
    });

    factory EventCategoryLinks.fromJson(Map<String, dynamic> json) => EventCategoryLinks(
        first: json["first"],
        last: json["last"],
        prev: json["prev"],
        next: json["next"],
    );

    Map<String, dynamic> toJson() => {
        "first": first,
        "last": last,
        "prev": prev,
        "next": next,
    };
}

class Meta {
    final int currentPage;
    final int from;
    final int lastPage;
    final List<Link> links;
    final String path;
    final int perPage;
    final int to;
    final int total;

    Meta({
        required this.currentPage,
        required this.from,
        required this.lastPage,
        required this.links,
        required this.path,
        required this.perPage,
        required this.to,
        required this.total,
    });

    factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
    };
}

class Link {
    final String url;
    final String label;
    final bool active;

    Link({
        required this.url,
        required this.label,
        required this.active,
    });

    factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
    );

    Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
