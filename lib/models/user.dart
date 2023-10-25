import 'package:flutter/material.dart';

class User {
  int id;
  String name;
  String? email;
  String? password;
  int statusId;
  int imageId;
  String createdAt;
  String updatedAt;
  Map<String, dynamic> json;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.password,
      required this.statusId,
      required this.imageId,
      required this.createdAt,
      required this.updatedAt,
      required this.json});

  factory User.fromJson(Map<String, dynamic> json) {
    User? user;

    try {
      user = User(
          id: json['id'] ?? (throw Exception("id is required")),
          name: json['name'] ?? (throw Exception("name is required")),
          email: json['email'],
          password: json['password'],
          statusId:
              json['status_id'] ?? (throw Exception("status_id is required")),
          imageId:
              json['image_id'] ?? (throw Exception("image_id is required")),
          createdAt:
              json['created_at'] ?? (throw Exception("created_at is required")),
          updatedAt:
              json['updated_at'] ?? (throw Exception("updated_at is required")),
          json: json);
    } on Exception catch (e) {
      debugPrint('$e');
      throw Exception("Erro ao ler User");
    }

    return user;
  }
}
