import 'dart:convert';

class Favorite {
  int productID;
  String name;
  dynamic price;
  String img;
  String des;
  
  Favorite(
      {required this.name,
      required this.price,
      required this.img,
      required this.des,
      required this.productID});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'img': img,
      'des': des,
      'productID': productID
    };
  }

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
        productID: map['productID'] ?? 0,
        name: map['name'] ?? '',
        price: map['price'] ?? '',
        img: map['img'] ?? '',
        des: map['des'] ?? '',);
  }

  String toJson() => json.encode(toMap());

  factory Favorite.fromJson(String source) => Favorite.fromMap(json.decode(source));

  @override
  String toString() =>
      'Product(productID: $productID, name: $name, price: $price, img: $img, des: $des)';
}
