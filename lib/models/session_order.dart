import 'package:flutter/material.dart';
import 'package:smart_menu_app/models/product.dart';
import 'package:smart_menu_app/models/session_order_user.dart';

class SessionOrder {
  int id;
  int statusId;
  int sessionId;
  int productId;
  int quantity;
  int amount;
  int amountLeft;
  String createdAt;
  String updatedAt;
  Map<String, dynamic> json;
  List<SessionOrderUser> sessionOrderUsers = [];
  Product? product;

  SessionOrder(
      {required this.id,
      required this.statusId,
      required this.sessionId,
      required this.productId,
      required this.quantity,
      required this.amount,
      required this.amountLeft,
      required this.createdAt,
      required this.updatedAt,
      required this.json}) {
    if (json['product'] != null) {
      product = Product.fromJson(json['product']);
    }

    if (json['sessionOrderUser'] != null) {
      for (int i = 0; i < (json['sessionOrderUser'] as List).length; i++) {
        sessionOrderUsers.add(
            SessionOrderUser.fromJson((json['sessionOrderUser'] as List)[i]));
      }
    }
  }

  factory SessionOrder.fromJson(Map<String, dynamic> json) {
    SessionOrder? sessionOrder;

    try {
      sessionOrder = SessionOrder(
          id: json['id'] ?? (throw Exception("id is required")),
          sessionId:
              json['session_id'] ?? (throw Exception("session_id is required")),
          productId:
              json['product_id'] ?? (throw Exception("product_id is required")),
          amount: json['amount'] ?? (throw Exception("amount is required")),
          amountLeft: json['amount_left'] ??
              (throw Exception("amount_left is required")),
          quantity:
              json['quantity'] ?? (throw Exception("quantity is required")),
          statusId:
              json['status_id'] ?? (throw Exception("status_id is required")),
          createdAt:
              json['created_at'] ?? (throw Exception("created_at is required")),
          updatedAt:
              json['updated_at'] ?? (throw Exception("updated_at is required")),
          json: json);
    } on Exception catch (e) {
      debugPrint('$e');
      throw Exception("Erro ao ler SessionOrder");
    }

    return sessionOrder;
  }
}
