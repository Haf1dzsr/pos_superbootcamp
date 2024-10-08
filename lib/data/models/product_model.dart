import 'dart:convert';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(
    json.decode(str).map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  String? id;
  String? name;
  int? price;
  int? stock;
  String? imageName;
  String? imageUrl;
  String? userId;

  ProductModel({
    this.id,
    this.name,
    this.price,
    this.stock,
    this.imageName,
    this.imageUrl,
    this.userId,
  });

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    int? price,
    int? stock,
    String? imageName,
    String? imageUrl,
    String? userId,
  }) =>
      ProductModel(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
        stock: stock ?? this.stock,
        imageName: imageName ?? this.imageName,
        imageUrl: imageUrl ?? this.imageUrl,
        userId: userId ?? this.userId,
      );

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        stock: json["stock"],
        imageName: json["imageName"],
        imageUrl: json["imageUrl"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "stock": stock,
        "imageName": imageName,
        "imageUrl": imageUrl,
        "userId": userId,
      };
}
