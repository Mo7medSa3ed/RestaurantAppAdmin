import 'dart:convert';

import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:deliveryapp/API.dart';
import 'package:deliveryapp/components/primart_elevatedButtom.dart';
import 'package:deliveryapp/constants.dart';
import 'package:deliveryapp/custum_widget.dart';
import 'package:deliveryapp/models/user.dart';
import 'package:deliveryapp/provider/appdata.dart';
import 'package:deliveryapp/size_config.dart';

class SignupBody extends StatefulWidget {
  @override
  _SignupBodyState createState() => _SignupBodyState();
}

class _SignupBodyState extends State<SignupBody>
    with SingleTickerProviderStateMixin {
  TextEditingController email = TextEditingController(text: '');
  TextEditingController password = TextEditingController(text: '');
  TextEditingController username = TextEditingController(text: '');

  String type = 'User';
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Form(
      key: formKey,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(30),
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustumTextField(
                controller: username,
                validator: (String v) =>
                    v.isEmpty ? 'please enter your name !' : null,
                hint: 'username',
                icon: Icons.person_outline,
                obsecure: false,
              ),
              SizedBox(
                height: getProportionateScreenHeight(28),
              ),
              CustumTextField(
                controller: email,
                validator: (String v) =>
                    v.isEmpty ? 'please enter your email !' : null,
                hint: 'email',
                icon: Icons.email_outlined,
                obsecure: false,
              ),
              SizedBox(
                height: getProportionateScreenHeight(28),
              ),
              DropdownBelow(
                  itemWidth: SizeConfig.screenWidth - 60,
                  itemTextstyle: TextStyle(fontSize: 14, color: Colors.black),
                  boxTextstyle: TextStyle(fontSize: 14, color: Colors.black),
                  boxPadding: EdgeInsets.symmetric(horizontal: 20),
                  boxDecoration: BoxDecoration(
                    color: grey.withOpacity(0.05),
                  ),
                  elevation: 0,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                  hint: Text(type ?? ''),
                  value: type ?? 'User',
                  items: ["Admin", "User", "Delivery"]
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      type = v;
                    });
                  }),
              SizedBox(
                height: getProportionateScreenHeight(28),
              ),
              CustumTextField(
                controller: password,
                validator: (String v) =>
                    v.isEmpty ? 'please enter your password !' : null,
                hint: 'password',
                icon: Icons.lock_outlined,
                obsecure: true,
              ),
              SizedBox(
                height: getProportionateScreenHeight(40),
              ),
              PrimaryElevatedButton(
                  text: 'Add User',
                  onpressed: () async => await signupbutton()),
            ],
          ),
        ),
      ),
    );
  }

  signupbutton() async {
    if (formKey.currentState.validate()) {
      showDialogWidget(context);
      User u = User(
          email: email.text.trim(),
          password: password.text.trim(),
          name: username.text.trim(),
          type: type);
      final res = (await API.signupUser(u));
      if (res.statusCode == 200 || res.statusCode == 201) {
        final u = utf8.decode(res.bodyBytes);
        final parsed = json.decode(u);
        User user = User.fromJson(parsed);
        Provider.of<AppData>(context, listen: false).addUser(user);
        reset();
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        showSnackbarWidget(
          context: context,
          msg:
              'please enter your data correctly or check the internet connection !!',
        );
      }
    }
  }

  reset() {
    setState(() {
      username.clear();
      email.clear();
      password.clear();
      type = 'User';
    });
  }
}
