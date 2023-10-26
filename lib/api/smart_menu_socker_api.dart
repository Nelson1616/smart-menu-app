import 'package:flutter/material.dart';
import 'package:smart_menu_app/api/smert_menu_api.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SmartMenuSocketApi {
  static final SmartMenuSocketApi _instance = SmartMenuSocketApi._internal();

  Socket? socket;
  String? tableCode;
  int? sessionUserId;

  Function? onSocketErrorListener;
  Function? onSocketUsersListener;
  Function? onSocketOrdersListener;

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
      });

      if (tableCode != null) {
        socket!.io.options?['extraHeaders'] = {'table_code': tableCode};
      }

      if (sessionUserId != null) {
        socket!.io.options?['extraHeaders'] = {
          'session_user_id': sessionUserId
        };
      }

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

      socket!.on('users', (data) {
        // debugPrint('$data');
        if (onSocketUsersListener != null) {
          onSocketUsersListener!(data);
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
