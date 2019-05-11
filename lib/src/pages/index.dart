import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import './call.dart';
import '../utils/HttpUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new IndexState();
  }
}

class IndexState extends State<IndexPage> {
  /// create a channelController to retrieve text value
  final _channelController = TextEditingController();

  /// if channel textfield is validated to have error
  bool _validateError = false;
  var _buttonText = '匹配';

  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Agora Flutter QuickStart'),
        ),
        body: Center(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 400,
              child: Column(
                children: <Widget>[
                  Row(children: <Widget>[]),
                  Row(children: <Widget>[
                    Expanded(
                      child:new Offstage(
                        offstage: false, //隐藏TextField
                        child: TextField(
                        controller: _channelController,
                        decoration: InputDecoration(
                            errorText: _validateError
                                ? "Channel name is mandatory"
                                : null,
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(width: 1)),
                            hintText: 'Channel name'
                            ),
                          ),
                      ),
                    )
                  ]),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: new Container(
                              height: 200.0,
                              width: 200.0,
                                child: RaisedButton(
                                  onPressed: () => onJoin(),
                                  child: Text(_buttonText),
                                  color: Colors.blueAccent,
                                  textColor: Colors.white,
                                  shape: new CircleBorder(),
                                ),
                              ),
                          )
                        ],
                      ))
                ],
              )),
        ));
  }

  onJoin() async {
    // update input validation
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
      _buttonText == "匹配" ? _buttonText = "匹配中..." : _buttonText = "匹配";    
    });


     // 获取实例
    var prefs = await SharedPreferences.getInstance();
    // 获取存储数据
    var _userId = prefs.getInt('userId');
    print(_userId);

    var result = await HttpUtils.request(
      '/api/match/user?userId='+'$_userId', 
      method: HttpUtils.GET,
    );
  
  





    // if (_channelController.text.isNotEmpty) {
    //   // await for camera and mic permissions before pushing video page
    //   await _handleCameraAndMic();
    //   // push video page with given channel name
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => new CallPage(
    //                 channelName: _channelController.text,
    //               )));
    // }
  }

  _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
        [PermissionGroup.camera, PermissionGroup.microphone]);
  }
}
