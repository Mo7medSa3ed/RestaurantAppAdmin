import 'package:flutter/material.dart';
import 'package:deliveryapp/constants.dart';
import 'package:deliveryapp/provider/appdata.dart';
import 'package:deliveryapp/screans/homepage.dart';
import 'package:deliveryapp/screans/maindrawer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AppData appData;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          title: Text("Admin App"),
          backgroundColor: Kprimary.withOpacity(0.9),
          iconTheme: IconThemeData(color: white),
        ),
        body: HomePage());
  }
}
