import 'package:flutter/material.dart';
import 'package:smart_menu_app/api/smert_menu_api.dart';
import 'package:smart_menu_app/models/session_order.dart';
import 'package:smart_menu_app/models/session_user.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SmartMenuSocketApi {
  static final SmartMenuSocketApi _instance = SmartMenuSocketApi._internal();

  Socket? socket;
  String? tableCode;
  int? sessionUserId;

  Function? onSocketErrorListener;
  Function? onSocketUsersListener;
  Function? onSocketOrdersListener;

  void setOnSocketErrorListener(Function onSocketErrorListener) {
    debugPrint("setOnSocketErrorListener");
    this.onSocketErrorListener = onSocketErrorListener;
  }

  void setOnSocketUsersListener(Function onSocketUsersListener) {
    debugPrint("setOnSocketUsersListener = $onSocketUsersListener");
    this.onSocketUsersListener = onSocketUsersListener;
  }

  void setOnSocketOrdersListener(Function onSocketOrdersListener) {
    debugPrint("setOnSocketOrdersListener");
    this.onSocketOrdersListener = onSocketOrdersListener;
  }

  List<SessionUser> sessionUsers = [];

  List<SessionOrder> sessionOrders = [];

  SmartMenuSocketApi._internal();

  factory SmartMenuSocketApi() {
    return _instance;
  }

  void connect() {
    if (tableCode != null || sessionUserId != null) {
      if (socket != null) {
        if (socket!.connected) {
          return;
        }
      }

      socket = io('${SmartMenuApi.mainIp}:3016/', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'query': {'table_code': tableCode, 'session_user_id': sessionUserId}
      });

      setupSocket();
      socket!.connect();
    }
  }

  void disconnect() {
    onSocketErrorListener = null;
    onSocketOrdersListener = null;
    onSocketUsersListener = null;

    tableCode = null;
    sessionUserId = null;

    if (socket != null) {
      socket!.disconnect();
      socket = null;
    }
  }

  void cleanListeners() {
    onSocketErrorListener = null;
    onSocketOrdersListener = null;
    onSocketUsersListener = null;
  }

  void setupSocket() {
    if (socket != null) {
      socket!.on('error', (data) {
        // debugPrint('$data');
        if (onSocketErrorListener != null) {
          onSocketErrorListener!(data);
        }
      });

      socket!.on('message', (data) => debugPrint('$data'));

      socket!.on('connect_error', (data) => debugPrint('$data'));

      socket!.on('users', (data) {
        debugPrint('users atualizado');

        sessionUsers = [];

        for (int i = 0; i < (data as List<dynamic>).length; i++) {
          SessionUser sessionUser = SessionUser.fromJson(data[i]);

          if (sessionUser.user != null) {
            sessionUsers.add(sessionUser);
          }
        }

        if (onSocketUsersListener != null) {
          onSocketUsersListener!();
        }
      });

      socket!.on('orders', (data) {
        try {
          debugPrint('orders atualizado');

          sessionOrders = [];

          for (int i = 0; i < (data as List<dynamic>).length; i++) {
            SessionOrder sessionOrder = SessionOrder.fromJson(data[i]);

            // if (sessionOrder.product != null) {
            sessionOrders.add(sessionOrder);
            // }
          }

          if (onSocketOrdersListener != null) {
            onSocketOrdersListener!();
          }
        } on Error catch (e) {
          debugPrint('$e');
        }
      });
    }
  }

  void join(int sessionUserId) {
    connect();

    socket!.emit("join", {
      "session_user_id": sessionUserId,
    });
  }

  void makeOrder(int sessionUserId, int productId, int quantity) {
    connect();

    socket!.emit("make_order", {
      "session_user_id": sessionUserId,
      "product_id": productId,
      "quantity": quantity
    });
  }
}
