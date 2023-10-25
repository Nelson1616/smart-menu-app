import 'package:flutter/material.dart';
import 'package:smart_menu_app/api/smert_menu_api.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SmartMenuSocketApi {
  Socket socket;

  Function? onSocketErrorListener;
  Function? onSocketUsersListener;
  Function? onSocketOrdersListener;

  SmartMenuSocketApi({required this.socket}) {
    socket.on('error', (data) {
      // debugPrint('$data');
      if (onSocketErrorListener != null) {
        onSocketErrorListener!(data);
      }
    });

    socket.on('message', (data) => debugPrint('$data'));

    socket.on('users', (data) {
      // debugPrint('$data');
      if (onSocketUsersListener != null) {
        onSocketUsersListener!(data);
      }
    });

    socket.on('orders', (data) {
      // debugPrint('$data');
      if (onSocketOrdersListener != null) {
        onSocketOrdersListener!(data);
      }
    });

    socket.connect();
  }

  static SmartMenuSocketApi getSocketByTableCode(String tableCode) {
    debugPrint("trying to connect to socket");

    Socket newSocket = io('${SmartMenuApi.mainIp}:3016/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    newSocket.io.options?['extraHeaders'] = {'table_code': tableCode};

    return SmartMenuSocketApi(socket: newSocket);
  }
}
