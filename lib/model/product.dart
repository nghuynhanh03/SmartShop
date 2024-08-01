class Product {
  int id;
  String name;
  String description;
  String imageUrl;
  dynamic price;
  int categoryId;
  String categoryName;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.categoryId,
    required this.categoryName,
  });
  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        description: json["description"] ?? '',
        imageUrl: json["imageURL"] ?? '',
        price: json["price"] ?? 0,
        categoryId: json["categoryID"] ?? 0,
        categoryName: json["categoryName"] ?? '',
      );
  Map<String, dynamic> toMap() => {
        "productID": id,
        "name": name,
        "description": description,
        "imageURL": imageUrl,
        "price": price,
        "categoryID": categoryId,
        "categoryName": categoryName,
      };
}
