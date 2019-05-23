// import 'package:local_notifications/local_notifications.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import './../pages/call.dart';
import 'package:flutter/material.dart';
import './settings.dart';

class MessageUtils {
  static SocketIO socketIO;
  static num _id = 0;

  static void connect(userId) {
    socketIO = SocketIOManager().createSocketIO(SOCKET_IP, "/",query: "userId=${userId}");
    socketIO.init();
    print(socketIO.getId());
    // socketIO.subscribe("socket_info", _onSocketInfo);
    socketIO.connect();
  }

 static void  _onSocketInfo(dynamic data) {
    print("Socket info: " + data);
      // await for camera and mic permissions before pushing video page
      // push video page with given channel name
        // Navigator.pushNamed(null, "callPage");
  }
  static void _onReceiveChatMessage(dynamic message) {
    print("Message from UFO: " + message);
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
