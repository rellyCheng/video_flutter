// import 'package:local_notifications/local_notifications.dart';
import './../pages/call.dart';
import 'package:flutter/material.dart';
import './settings.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
class MessageUtils {
  static num _id = 0;
  IO.Socket socket;
    
      
  IO.Socket connect(userId) {
      socket = IO.io(SOCKET_IP+'?userId=$userId', <String, dynamic>{
          'transports': ['websocket'],
          'extraHeaders': {'userId': '123'},
      });
      socket.on('connect', (_) {
        print('connect');
      });
      // socket.on('news', (data) => _onSocketInfo(data));
      socket.on('disconnect', (_) => print('disconnect'));
      socket.on('fromServer', (_) => print(_));
      print("-----------");
      print(socket);
      print("-----------");
      return socket;
  }

  IO.Socket disConnect(){
    socket.disconnect();
  }

  static void  _onSocketInfo(dynamic data) {
      print("Socket info: " + data);
  }

  // 手机状态栏弹出推送的消息
  static void _createNotification(String title, String content) async {
    // await LocalNotifications.createNotification(
    //   id: _id,
    //   title: title,
    //   content: content,
    //   onNotificationClick: NotificationAction(
    //       actionText: "some action",
    //       callback: _onNotificationClick,
    //       payload: "接收成功！"),
    // );
  }

  static _onNotificationClick(String payload) {
    // LocalNotifications.removeNotification(_id);
  }
}
