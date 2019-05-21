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
  List<dynamic> str = [];
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  int current = 1;
  int refresh = 1;
  int loadMore = 0;
  @override
  void initState() {
    _getHistoryList(1,refresh);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getHistoryList(current,type) async{
      //获取数据持久化实例
      var prefs = await SharedPreferences.getInstance();
      int _size = 1;
      int _userId = prefs.getInt('userId');
      var result = await HttpUtils.request(
      '/api/match/getHistoryList?size=$_size&current=$current&userId=$_userId', 
       method: HttpUtils.GET,
      );
      // str = result["data"];
      if(type==refresh){
        _easyRefreshKey.currentState.callRefreshFinish();
        str.clear();
        setState(() {
          str = result["data"];
        });
      }
      if(type==loadMore){
        _easyRefreshKey.currentState.callLoadMoreFinish();
        str.addAll(result["data"]);
        setState(() {
        });
      }
  }
  _loadMoreList() {
    _getHistoryList(++current,loadMore);
  }
  _onRefreshList() {
      current = 1;
     _getHistoryList(current,refresh);
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
        behavior: ScrollOverBehavior(),
        autoControl: false,
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
          await Future.delayed(const Duration(seconds: 0), _onRefreshList());
        },
        loadMore: () async {
          await Future.delayed(const Duration(seconds: 0), _loadMoreList());
        },
      )),
    );
  }
}