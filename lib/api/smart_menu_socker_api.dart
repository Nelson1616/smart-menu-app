import 'package:flutter/material.dart';
import 'package:smart_menu_app/api/smert_menu_api.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SmartMenuSocketApi {
  late Socket socket;

  SmartMenuSocketApi(String tableCode) {
    socket = io('${SmartMenuApi.mainIp}:3016/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.io.options?['extraHeaders'] = {'table_code': tableCode};

    socket.on('error', (data) => debugPrint('$data'));

    socket.on('message', (data) => debugPrint('$data'));

    socket.on('users', (data) => debugPrint('$data'));

    socket.on('orders', (data) => debugPrint('$data'));

    socket.connect();
  }
}
