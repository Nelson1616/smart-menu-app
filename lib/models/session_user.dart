import 'package:flutter/material.dart';
import 'package:smart_menu_app/models/user.dart';

class SessionUser {
  int id;
  int statusId;
  int sessionId;
  int userId;
  int amountToPay;
  String createdAt;
  String updatedAt;
  Map<String, dynamic> json;
  User? user;

  SessionUser(
      {required this.id,
      required this.statusId,
      required this.sessionId,
      required this.userId,
      required this.amountToPay,
      required this.createdAt,
      required this.updatedAt,
      required this.json}) {
    if (json['user'] != null) {
      user = User.fromJson(json['user']);
    }
  }

  factory SessionUser.fromJson(Map<String, dynamic> json) {
    SessionUser? sessionuser;

    try {
      sessionuser = SessionUser(
          id: json['id'] ?? (throw Exception("id is required")),
          sessionId:
              json['session_id'] ?? (throw Exception("session_id is required")),
          userId: json['user_id'] ?? (throw Exception("user_id is required")),
          amountToPay: json['amount_to_pay'] ??
              (throw Exception("amount_to_pay is required")),
          statusId:
              json['status_id'] ?? (throw Exception("status_id is required")),
          createdAt:
              json['created_at'] ?? (throw Exception("created_at is required")),
          updatedAt:
              json['updated_at'] ?? (throw Exception("updated_at is required")),
          json: json);
    } on Exception catch (e) {
      debugPrint('$e');
      throw Exception("Erro ao ler SessionUser");
    }

    return sessionuser;
  }
}
