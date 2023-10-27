import 'package:flutter/material.dart';
import 'package:smart_menu_app/api/smert_menu_api.dart';
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

  List<SessionUser> sessionUsers = [];

  SmartMenuSocketApi._internal();

  factory SmartMenuSocketApi() {
    return _instance;
  }

  void connect() {
    onSocketErrorListener = null;
    onSocketOrdersListener = null;
    onSocketUsersListener = null;

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
        // debugPrint('$data');
        if (onSocketOrdersListener != null) {
          onSocketOrdersListener!(data);
        }
      });
    }
  }
}
