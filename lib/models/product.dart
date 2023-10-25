import 'package:flutter/material.dart';

class Product {
  int id;
  String name;
  String description;
  String image;
  int statusId;
  int price;
  int restaurantId;
  String createdAt;
  String updatedAt;
  Map<String, dynamic> json;

  Product(
      {required this.id,
      required this.name,
      required this.description,
      required this.image,
      required this.statusId,
      required this.price,
      required this.restaurantId,
      required this.createdAt,
      required this.updatedAt,
      required this.json});

  factory Product.fromJson(Map<String, dynamic> json) {
    Product? product;

    try {
      product = Product(
          id: json['id'] ?? (throw Exception("id is required")),
          name: json['name'] ?? (throw Exception("name is required")),
          description: json['description'] ??
              (throw Exception("description is required")),
          image: json['image'] ?? (throw Exception("image is required")),
          statusId:
              json['status_id'] ?? (throw Exception("status_id is required")),
          price: json['price'] ?? (throw Exception("price is required")),
          restaurantId: json['restaurant_id'] ??
              (throw Exception("restaurant_id is required")),
          createdAt:
              json['created_at'] ?? (throw Exception("created_at is required")),
          updatedAt:
              json['updated_at'] ?? (throw Exception("updated_at is required")),
          json: json);
    } on Exception catch (e) {
      debugPrint('$e');
      throw Exception("Erro ao ler Product");
    }

    return product;
  }
}
