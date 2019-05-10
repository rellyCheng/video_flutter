import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/HttpUtils.dart';


class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<ScaffoldState> registKey = new GlobalKey();

  String _phoneNum = '';

  String _verifyCode = '';

  int _seconds = 0;

  String _verifyStr = '获取验证码';

  var  _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _cancelTimer();
  }

  _startTimer() {
    _seconds = 10;
     print(_timer==null);
    _timer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        timer?.cancel();//此处有个坑，必须释放Timer.periodic 所产生的timer对象，只释放_timer不行，不然timer一直存在
        timer = null;
         _cancelTimer();
        return;
      }
      _seconds--;
      _verifyStr = '$_seconds(s)';
      setState(() {});
      if (_seconds == 0) {
        _verifyStr = '重新发送';
        _cancelTimer();
      }
    });
    //获取验证码
    _getCode();
  }

  void _cancelTimer() {
      _timer?.cancel();
      _timer = null;
  }

  
  _getCode() async{
    var result = await HttpUtils.request(
      '/api/home/getCode?phoneNumber='+_phoneNum, 
      method: HttpUtils.GET,
      data: {
        'phoneNumber': _phoneNum,
      }
    );
    if(result["state"]==0){
        _timer = new Timer(new Duration(seconds: 3), () {
          _showDialog("验证码为："+result["message"]+",有效时间为5分钟。");
        });
    }else{
       _showDialog(result["message"]);
    }
  }

  _showDialog(text){
     showDialog(
        context: context,
        builder: (BuildContext context){
          return SimpleDialog(
            title: Text(text),
            children: <Widget>[
              
            ],
          );
        }
      );
  }

  _login() async{
    var result = await HttpUtils.request(
      '/api/home/login', 
      method: HttpUtils.POST,
      data: {
        'phoneNumber': _phoneNum,
        'code': _verifyCode
      }
    );
      if(result['state']==0){
         Navigator.pushNamed(context, "indexPage");
      }else{
         _showDialog(result["message"]);
      }
  }

  Widget _buildPhoneEdit() {
    // var node = new FocusNode();
    return new Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0),
      child: new TextField(
        onChanged: (str) {
          _phoneNum = str;
          setState(() {});
        },
        decoration: new InputDecoration(
          hintText: '请输入手机号',
        ),
        maxLines: 1,
        maxLength: 11,
        //键盘展示为号码
        keyboardType: TextInputType.phone,
        //只能输入数字
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly,
        ],
        // onSubmitted: (text) {
        //   FocusScope.of(context).reparentIfNeeded(node);
        // },
      ),
    );
  }

  Widget _buildVerifyCodeEdit() {
    // var node = new FocusNode();
    Widget verifyCodeEdit = new TextField(
      onChanged: (str) {
        _verifyCode = str;
        setState(() {});
      },
      decoration: new InputDecoration(
        hintText: '请输入短信验证码',
      ),
      maxLines: 1,
      maxLength: 6,
      //键盘展示为数字
      keyboardType: TextInputType.number,
      //只能输入数字
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly,
      ],
      // onSubmitted: (text) {
      //   FocusScope.of(context).reparentIfNeeded(node);
      // },
    );

    Widget verifyCodeBtn = new InkWell(
      onTap: (_seconds == 0)
          ? () {
              setState(() {
                _startTimer();
              });
            }
          : null,
      child: new Container(
        alignment: Alignment.center,
        width: 100.0,
        height: 36.0,
        decoration: new BoxDecoration(
          border: new Border.all(
            width: 1.0,
            color: Colors.blue,
          ),
        ),
        child: new Text(
          '$_verifyStr',
          style: new TextStyle(fontSize: 14.0),
        ),
      ),
    );

    return new Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
      child: new Stack(
        children: <Widget>[
          verifyCodeEdit,
          new Align(
            alignment: Alignment.topRight,
            child: verifyCodeBtn,
          ),
        ],
      ),
    );
  }

  Widget _buildLabel() {
    return new Container(
      margin: const EdgeInsets.only(top: 40.0, bottom: 20.0),
      alignment: Alignment.center,
      child: new Text(
        "登录",
        style: new TextStyle(fontSize: 24.0),
      ),
    );
  }

  Widget _buildRegist() {
    return new Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 20.0),
      child: new RaisedButton(
        onPressed: () {
           
           _login();
        },
        color: Colors.blue,
        textColor: Colors.white,
        disabledColor: Colors.blue[100],
        child: new Text(
          "登  录",
          style: new TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  



  Widget _buildBody(){
    return ListView(
      children: <Widget>[
        SizedBox(
          height: kToolbarHeight,
        ),
        _buildLabel(),
        _buildPhoneEdit(),
        _buildVerifyCodeEdit(),
        _buildRegist(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Scaffold(
        key: registKey,
        backgroundColor: Colors.white,
        body: _buildBody(),
      ),
    );
  }


    Align buildOtherLoginText() {
    return Align(
        alignment: Alignment.center,
        child: Text(
          '其他账号登录',
          style: TextStyle(color: Colors.grey, fontSize: 14.0),
        ));
  }
}