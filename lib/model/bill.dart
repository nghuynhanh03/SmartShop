class Bill {
  String id;
  String fullName;
  String dateCreated;
  int total;

  Bill({
    required this.id,
    required this.fullName,
    required this.dateCreated,
    required this.total,
  });

  factory Bill.fromJson(Map<String, dynamic> json) => Bill(
        id: json["id"],
        fullName: json["fullName"],
        dateCreated: json["dateCreated"],
        total: json["total"],
      );
}

class BillDetail {
  int productId;
  String productName;
  dynamic imageUrl;
  int price;
  int count;
  int total;

  BillDetail({
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.price,
    required this.count,
    required this.total,
  });

  factory BillDetail.fromJson(Map<String, dynamic> json) =>
      BillDetail(
        productId: json["productID"] ?? 0,
        productName: json["productName"] ?? "",
        imageUrl: json["imageURL"] ?? "",
        price: json["price"] ?? 0,
        count: json["count"] ?? 0,
        total: json["total"] ?? 0,
      );
}
