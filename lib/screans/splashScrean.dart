import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:deliveryapp/API.dart';
import 'package:deliveryapp/constants.dart';
import 'package:deliveryapp/custum_widget.dart';
import 'package:deliveryapp/models/user.dart';
import 'package:deliveryapp/provider/appdata.dart';
import 'package:deliveryapp/screans/home.dart';
import 'package:deliveryapp/screans/loginScrean.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';

class SplashScrean extends StatefulWidget {
  @override
  _SplashScreanState createState() => _SplashScreanState();
}

class _SplashScreanState extends State<SplashScrean> {
  AppData appData;
  SharedPreferences prfs;
  bool networktest = true;
  checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      networktest = false;
    } else {
      networktest = true;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkNetwork();
    if (networktest) {
      getData();
    }
  }

  getData() async {
    appData = Provider.of<AppData>(context, listen: false);
    prfs = await SharedPreferences.getInstance();
    // prfs.clear();
    if (prfs.getString('user') != null) {
      User user = await getUserFromPrfs();
      User u = await API.getOneUser(user.id);
      if (u != null && u.updatedAt == user.updatedAt) {
        appData.initLoginUser(u);
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => Home()));
      } else {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => LoginScrean()));
      }
    } else {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => LoginScrean()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: networktest
          ? Container(
              width: double.infinity,
              height: double.infinity,
              color: white,
              child: Image.asset("assets/images/splashscrean.png"))
          : noNetworkwidget(),
    );
  }
}
