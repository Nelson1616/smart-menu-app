import 'package:flutter/material.dart';
import 'package:smart_menu_app/models/session_user.dart';

class SessionOrderUser {
  int id;
  int statusId;
  int sessionOrderId;
  int sessionUserId;
  String createdAt;
  String updatedAt;
  Map<String, dynamic> json;
  SessionUser? sessionUser;

  SessionOrderUser(
      {required this.id,
      required this.statusId,
      required this.sessionOrderId,
      required this.sessionUserId,
      required this.createdAt,
      required this.updatedAt,
      required this.json}) {
    if (json['sessionUser'] != null) {
      sessionUser = SessionUser.fromJson(json['sessionUser']);
    }

    if (json['sessionOrderUserUser'] != null) {
      //product = Product.fromJson(json['sessionOrderUserUser']);
    }
  }

  factory SessionOrderUser.fromJson(Map<String, dynamic> json) {
    SessionOrderUser? sessionOrderUser;

    try {
      sessionOrderUser = SessionOrderUser(
          id: json['id'] ?? (throw Exception("id is required")),
          sessionOrderId: json['session_order_id'] ??
              (throw Exception("session_order_id is required")),
          sessionUserId: json['session_user_id'] ??
              (throw Exception("session_user_id is required")),
          statusId:
              json['status_id'] ?? (throw Exception("status_id is required")),
          createdAt:
              json['created_at'] ?? (throw Exception("created_at is required")),
          updatedAt:
              json['updated_at'] ?? (throw Exception("updated_at is required")),
          json: json);
    } on Exception catch (e) {
      debugPrint('$e');
      throw Exception("Erro ao ler SessionOrderUser");
    }

    return sessionOrderUser;
  }
}
