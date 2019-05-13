import 'package:flutter/material.dart';
import './src/pages/index.dart';
import './src/pages/login.dart';
import './src/pages/call.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
       routes: {
        "indexPage":(BuildContext context)=>new IndexPage(),
        "callPage":(BuildContext context)=>new CallPage(),
      },
    );
  }
}


