import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import './call.dart';
import '../utils/HttpUtils.dart';
import '../utils/MessageUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './historyMatch.dart';
import 'package:flutter/gestures.dart';
import './login.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import './homeDrawer.dart';
import '../utils/settings.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return IndexState();
  }
}

class IndexState extends State<IndexPage> {
  /// create a channelController to retrieve text value
  final _channelController = TextEditingController();
  bool _toCallPage;
  var _buttonText = '匹配';
  IO.Socket socket;

  @override
  void initState() {
    _toCallPage = true;
    getUserAndConnectSocket();

    super.initState();
  }

  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    print('deactivate');
    _buttonText = '匹配';
    _toCallPage = !_toCallPage;
    super.deactivate();
  }

  Widget matchButton() {
    return Padding(
      // height: 200,
      padding: EdgeInsets.symmetric(vertical: 20),
      child: RaisedButton(
        padding: EdgeInsets.symmetric(horizontal: 100),
        shape: CircleBorder(),
        onPressed: () => onJoin(),
        child: Text(
          _buttonText,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      drawer: new Drawer(
        child: HomeBuilder.homeDrawer(),
      ),
      body: Container(
          decoration: _buttonText == "匹配中..."
              ? BoxDecoration(
                  image: DecorationImage(
                  image: AssetImage('assets/images/match.gif'),
                  fit: BoxFit.cover,
                  
                ))
              : BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Colors.lime, Colors.cyan, Colors.grey]),
                // border: Border.all(width: 5.0,color: Colors.green)

              ),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 200,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 200.0,
                          child: new Offstage(
                            offstage: _buttonText == "匹配中..." ? true : false,
                            child: RaisedButton(
                              onPressed: () => onJoin(),
                              child: Text(_buttonText,style: TextStyle(fontSize:20),),
                              color: Colors.teal,
                              textColor: Colors.white,
                              shape: CircleBorder(),
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          width: 200.0,
                          child: Align(
                            alignment: Alignment.center,
                            child: new Offstage(
                              offstage: _buttonText == "匹配中..." ? true : false,
                              child: RichText(
                                text: TextSpan(
                                    text: '历史匹配记录',
                                    style: TextStyle(
                                        fontSize: 17.0, color: Colors.tealAccent),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        //导航到历史匹配记录页面
                                        if (_checkLogin()) {
                                          await Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return HistoryMatch();
                                          }));
                                        }
                                      }),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
                  Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: new Offstage(
                            offstage: _buttonText == "匹配中..." ? false : true,
                            child: RaisedButton(
                              onPressed: () => this.setState((){
                                _buttonText = "匹配";
                              }),
                              child: Icon(Icons.clear,color: Colors.white,),
                              color: Colors.cyan,
                              // textColor: Colors.tealAccent,
                              shape: CircleBorder(),
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
            ],
          )),
    );
  }

  getUserAndConnectSocket() async {
    // 获取实例
    var prefs = await SharedPreferences.getInstance();
    // 获取存储数据
    USER_ID = prefs.getInt('userId');
    //连接socket服务
    if (USER_ID != null) {
      connectSocket();
    }
  }


   bool _checkLogin() {
    if (USER_ID == null) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('温馨提示'),
                content: Text(('您当前还未登录，请先登录！')),
                actions: <Widget>[
                  FlatButton(
                    child: Text("取消"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text("确定"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                  ),
                ],
              ));
      return false;
    }
    return true;
  }

  onJoin() async {
    //校验用户是否登录
    if (_checkLogin()) {
      setState(() {
        _buttonText == "匹配" ? _buttonText = "匹配中..." : _buttonText = "匹配";
      });
      if (_buttonText == "匹配中...") {
        await HttpUtils.request(
          '/api/match/user?userId=' + USER_ID,
          method: HttpUtils.GET,
        );
      }
    }
  }

  connectSocket() async {
    socket = MessageUtils().connect(USER_ID);
    socket.on('news', (data) => _onSocketInfo(data));
  }

  _onSocketInfo(dynamic data) async {
    var roomId = data[0];
    print(roomId);
    if (_toCallPage && _buttonText == "匹配中...") {
      //获取相机权限和录音权限
      await _handleCameraAndMic();
      // 跳转到视频通话页面
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CallPage(
                    channelName: roomId,
                  )));
      _toCallPage = true;
    }
  }

  _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
        [PermissionGroup.camera, PermissionGroup.microphone]);
  }
}
