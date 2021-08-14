import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/API.dart';
import 'package:resturantapp/custum_widget.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:resturantapp/size_config.dart';
import 'package:connectivity/connectivity.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {

  bool networktest = true;
  checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult);
    if (connectivityResult == ConnectivityResult.none) {
      networktest = false;
    } else {
      networktest = true;
    }
    setState(() {});
  }

  getData() async {
    AppData appData = Provider.of<AppData>(context, listen: false);
    await API.getAllDishes().then((value) => appData.initDishesList(value));
    await API
        .getAllCategories()
        .then((value) => appData.initCategoryList(value));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkNetwork();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: networktest ? body() : noNetworkwidget());
  }

  Widget body() {
    SizeConfig().init(context);
    return Container();
    }
}
