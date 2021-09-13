import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:deliveryapp/API.dart';
import 'package:deliveryapp/components/primart_elevatedButtom.dart';
import 'package:deliveryapp/constants.dart';
import 'package:deliveryapp/custum_widget.dart';
import 'package:deliveryapp/models/user.dart';
import 'package:deliveryapp/provider/special.dart';
import 'package:deliveryapp/screans/home.dart';
import 'package:deliveryapp/size_config.dart';

class LoginBody extends StatefulWidget {
  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody>
    with SingleTickerProviderStateMixin {
  bool login = true;
  bool remember = false;
  final formKey = GlobalKey<FormState>();
  AnimationController _controller;
  Specials specials;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    _controller.forward();
    specials = Provider.of(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  String email, password;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return FadeTransition(
        opacity: Tween<double>(begin: 0.2, end: 1.0).animate(_controller),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                height: getProportionateScreenHeight(65),
              ),
              Text('Log in to your account',
                  style: TextStyle(
                      letterSpacing: 1,
                      fontSize: 22,
                      color: Kprimary,
                      fontWeight: FontWeight.w600)),
              SizedBox(
                height: getProportionateScreenHeight(65),
              ),
              CustumTextField(
                validator: (String v) =>
                    v.isEmpty ? 'please enter your email !' : null,
                hint: 'email',
                icon: Icons.email_outlined,
                obsecure: false,
                onchanged: (v) => v.toString().isNotEmpty ? email = v : null,
              ),
              SizedBox(
                height: getProportionateScreenHeight(28),
              ),
              CustumTextField(
                validator: (String v) =>
                    v.isEmpty ? 'please enter your password !' : null,
                hint: 'password',
                icon: Icons.lock_outlined,
                obsecure: true,
                onchanged: (v) => v.toString().isNotEmpty ? password = v : null,
              ),
              SizedBox(
                height: getProportionateScreenHeight(40),
              ),
              PrimaryElevatedButton(
                  text: 'LOGIN', onpressed: () async => await loginButton()),
            ],
          ),
        ));
  }

  loginButton() async {
    if (formKey.currentState.validate()) {
      showDialogWidget(context);
      User u = User(email: email.trim(), password: password.trim());
      final res = await API.loginUser(u);
      if (res.statusCode == 200) {
        final u = utf8.decode(res.bodyBytes);
        saveUserToshared(u, context);
        saveUsertoAppdata(u, context);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => Home()),
            (Route<dynamic> route) => false);
      } else {
        Navigator.pop(context);
        FocusScope.of(context).requestFocus(FocusNode());
        showSnackbarWidget(
          context: context,
          msg:
              'please enter your data correctly or check the internet connection!!',
        );
      }
    }
  }
}
