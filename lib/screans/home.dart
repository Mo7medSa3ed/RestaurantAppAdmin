import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/API.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:resturantapp/screans/homepage.dart';
import 'package:resturantapp/screans/maindrawer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AppData appData;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    appData = Provider.of<AppData>(context, listen: false);
    await API.getAllDishes().then((value) => appData.initDishesList(value));
    await API
        .getAllCategories()
        .then((value) => appData.initCategoryList(value));
    // get all category
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
