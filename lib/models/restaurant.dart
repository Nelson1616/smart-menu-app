import 'package:flutter/material.dart';
import 'package:smart_menu_app/models/product.dart';

class Restaurant {
  int id;
  String name;
  String description;
  String image;
  int statusId;
  String primaryColor;
  String secondaryColor;
  String tertiatyColor;
  String createdAt;
  String updatedAt;
  Map<String, dynamic> json;
  List<Product> products = [];

  Restaurant(
      {required this.id,
      required this.name,
      required this.description,
      required this.image,
      required this.statusId,
      required this.primaryColor,
      required this.secondaryColor,
      required this.tertiatyColor,
      required this.createdAt,
      required this.updatedAt,
      required this.json}) {
    if (json['products'] != null) {
      List<dynamic> listJsons = json['products'];

      for (int i = 0; i < listJsons.length; i++) {
        products.add(Product.fromJson(listJsons.elementAt(i)));
      }
    }
  }

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    Restaurant? restaurant;

    try {
      restaurant = Restaurant(
          id: json['id'] ?? (throw Exception("id is required")),
          name: json['name'] ?? (throw Exception("name is required")),
          description: json['description'] ??
              (throw Exception("description is required")),
          image: json['image'] ?? (throw Exception("image is required")),
          statusId:
              json['status_id'] ?? (throw Exception("status_id is required")),
          primaryColor: json['primary_color'] ??
              (throw Exception("primary_color is required")),
          secondaryColor: json['secondary_color'] ??
              (throw Exception("secondary_color is required")),
          tertiatyColor: json['tertiaty_color'] ??
              (throw Exception("tertiaty_color is required")),
          createdAt:
              json['created_at'] ?? (throw Exception("created_at is required")),
          updatedAt:
              json['updated_at'] ?? (throw Exception("updated_at is required")),
          json: json);
    } on Exception catch (e) {
      debugPrint('$e');
      throw Exception("Erro ao ler restaurante");
    }

    return restaurant;
  }
}
