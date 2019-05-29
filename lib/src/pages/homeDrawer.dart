import 'package:flutter/material.dart';
class HomeBuilder {
  static Widget homeDrawer() {
    return new ListView(padding: const EdgeInsets.only(), children: <Widget>[
      _drawerHeader(),
      new ClipRect(
        child: new ListTile(
          leading: new CircleAvatar(child: new Text("A")),
          title: new Text('Drawer item A'),
          subtitle: new Text("Drawer item A subtitle"),
          onTap: () => {},
        ),
      ),
      new ListTile(
        leading: new CircleAvatar(child: new Text("B")),
        title: new Text('Drawer item B'),
        subtitle: new Text("Drawer item B subtitle"),
        onTap: () => {},
      ),
      new AboutListTile(
        icon: new CircleAvatar(child: new Text("Ab")),
        child: new Text("About"),
        applicationName: "总而言之",
        applicationVersion: "v1.0",
        applicationIcon: new Image.asset(
          "assets/images/harden.jpg",
          width: 64.0,
          height: 64.0,
        ),
        applicationLegalese: "app法律条文法律条文法律条文法律条文法律条文",
      ),
    ]);
  }

  static Widget _drawerHeader() {
    return new UserAccountsDrawerHeader(
    //  margin: EdgeInsets.zero,
      accountName: new Text(
        "程雷利",
      ),
      accountEmail: new Text(
        "707471634@qq.com",
      ),
      currentAccountPicture: new CircleAvatar(
        backgroundImage: new AssetImage("assets/images/harden.jpg",),
      ),
      onDetailsPressed: () {
      },
    );
  }
}