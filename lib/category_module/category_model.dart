
class CategoryModel {
    final List<Categories> data;

    CategoryModel({
        required this.data,
    });

    factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        data: List<Categories>.from(json["data"].map((x) => Categories.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Categories {
    final int id;
    final String name;
    final String slug;
    final DateTime createdAt;
    final DateTime updatedAt;

    Categories({
        required this.id,
        required this.name,
        required this.slug,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
