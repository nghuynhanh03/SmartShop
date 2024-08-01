class Category {
  int id;
  String name;
  String imageUrl;
  String desc;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.desc,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        imageUrl: json["imageURL"] ?? "",
        desc: json["description"] ?? "",
      );
}
