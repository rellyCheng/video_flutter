import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/taurus_header.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import '../utils/HttpUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryMatch extends StatefulWidget {
  @override
  _HistoryMatchState createState() => _HistoryMatchState();
}

class _HistoryMatchState extends State<HistoryMatch> with SingleTickerProviderStateMixin {
  List<dynamic> addStr = ["13028918898", "13028918898", "13028918898", "13028918898", "13028918898", "13028918898", "13028918898", "13028918898", "13028918898", "13028918898"];
  List<dynamic> str = [];
  List<dynamic> str1 = ["13028918898", "13028918898", "13028918898", "13028918898", "13028918898", "13028918898", "13028918898", "13028918898", "13028918898", "13028918898"];
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  int current = 1;
  @override
  void initState() {
    _getHistoryList(1);
    super.initState();
  }
  _getHistoryList(current) async{
      //获取数据持久化实例
      var prefs = await SharedPreferences.getInstance();
      int _size = 2;
      int _userId = prefs.getInt('userId');
      var result = await HttpUtils.request(
      '/api/match/getHistoryList?size=$_size&current=$current&userId=$_userId', 
      method: HttpUtils.GET,
    );
    str = result["data"];
    print(result["data"][1]['startTime']);
    setState(() {});
  }
  @override
  void dispose() {
    super.dispose();
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("历史匹配记录"),
      ),
      body: Center(
          child: EasyRefresh(
        key: _easyRefreshKey,
        refreshHeader: TaurusHeader(
          key: _headerKey,
        ),
        refreshFooter: BezierBounceFooter(
          key: _footerKey,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: ListView.builder(
            //ListView的Item
            itemCount: str.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  height: 70.0,
                  child: Card(
                    child: 
                    Row(children: <Widget>[
                      Text(
                        '${str.length>0?str[index]["otherUserPhone"]:''}',
                        style: TextStyle(fontSize: 12.0),
                      ),
                          Expanded( 
                            child: Container(
                              // color: Colors.red,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center, //垂直方向居中对齐
                                children: <Widget>[
                                  Text("开始时间：${str.length>0?str[index]["startTime"]:''}",style: TextStyle(fontSize: 10.0)),
                                  Text("结束时间：${str.length>0?str[index]["endTime"]:''}",style: TextStyle(fontSize: 10.0)),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                  ));
            }),
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              str.clear();
              str.addAll(addStr);
            });
          });
        },
        loadMore: () async {
          await Future.delayed(const Duration(seconds: 1), () {
            if (str.length < 20) {
              setState(() {
                str.addAll(addStr);
              });
            }
          });
        },
      )),
    );
  }
}