import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:deliveryapp/constants.dart';
import 'package:deliveryapp/custum_widget.dart';
import 'package:deliveryapp/screans/loginbody.dart';
import 'package:deliveryapp/size_config.dart';
import 'package:connectivity/connectivity.dart';

class LoginScrean extends StatefulWidget {
  @override
  _LoginScreanState createState() => _LoginScreanState();
}

class _LoginScreanState extends State<LoginScrean> {
  String email, password, username;
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
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
          leading: Padding(
        padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
        child: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
              color: Colors.grey[400],
              size: 35,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      )),
      body: networktest
          ? SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(28),
                    vertical: getProportionateScreenHeight(20)),
                child: Column(
                  children: [buildmovetabs(), LoginBody()],
                ),
              ),
            )
          : noNetworkwidget(),
    );
  }

  Row buildmovetabs() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: red, width: 4))),
            child: Text(
              'Sign In',
              style: TextStyle(
                  fontSize: 36, fontWeight: FontWeight.w900, color: Kprimary),
              textAlign: TextAlign.start,
            ),
          ),
        ),
      ],
    );
  }
}
