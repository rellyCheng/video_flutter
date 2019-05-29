import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import './call.dart';
import '../utils/HttpUtils.dart';
import '../utils/MessageUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './historyMatch.dart';
import 'package:flutter/gestures.dart';
import './login.dart';
import '../utils/settings.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import './homeDrawer.dart';

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
  var _userId;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        // drawer: new Drawer(
        //   child: HomeBuilder.homeDrawer(),
        // ),
        body: Center(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 350,
              child: Column(
                children: <Widget>[
                  Row(children: <Widget>[
                  ]),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Container(
                              height: 200.0,
                              width: 200.0,
                                child: RaisedButton(
                                  onPressed: () => onJoin(),
                                  child: Text(_buttonText),
                                  color: Colors.blueAccent,
                                  textColor: Colors.white,
                                  shape: CircleBorder(),
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
                                child:  Align(
                                alignment: Alignment.center,
                                child: RichText(
                                    text: TextSpan(
                                      text: '历史匹配记录',
                                     style: TextStyle(fontSize: 17.0, color: Colors.blue),
                                     recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                          //导航到历史匹配记录页面 
                                          if(_checkLogin()){
                                            await Navigator.push( context,
                                            MaterialPageRoute(builder: (context) {
                                                return HistoryMatch();
                                            }));
                                          }
                                         
                                      }),
                                    ),
                                  ),
                              ),
                          )
                        ],
                      )),
                ],
              )),
        ),
        );
       
  }

  getUserAndConnectSocket() async{
    // 获取实例
    var prefs = await SharedPreferences.getInstance();
    // 获取存储数据
    _userId = prefs.getInt('userId');
    //连接socket服务
    if(_userId!=null){
      connectSocket(_userId);
    }
  }
  bool _checkLogin()  {
    if(_userId == null){
      // Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage()));
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
                  Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage()));
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
    if(_checkLogin()){
      setState(() {
        _buttonText == "匹配" ? _buttonText = "匹配中..." : _buttonText = "匹配";    
      });
    
      await HttpUtils.request(
        '/api/match/user?userId='+'$_userId', 
        method: HttpUtils.GET,
      );
    }
  }
  connectSocket(_userId) async{
      socket = MessageUtils().connect(_userId);
      socket.on('news', (data) => _onSocketInfo(data));
  }
  _onSocketInfo(dynamic data) async{
    var roomId = data[0];
    print(roomId);
    if(_toCallPage&&_buttonText == "匹配中..."){
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


