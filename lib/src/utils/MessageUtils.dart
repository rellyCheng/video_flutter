// import 'package:local_notifications/local_notifications.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';

class MessageUtils {
  static SocketIO socketIO;
  static num _id = 0;

  static void connect() {
    socketIO = SocketIOManager().createSocketIO("http://192.168.101.26:9091", "/");
    socketIO.init();
    print(socketIO.getId());
    socketIO.subscribe("socket_info", _onSocketInfo);
    socketIO.connect();
  }

 static void  _onSocketInfo(dynamic data) {
    // print("Socket info: " + data);
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
