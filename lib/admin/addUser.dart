import 'package:flutter/material.dart';
import 'package:deliveryapp/constants.dart';
import 'package:deliveryapp/screans/signupbody.dart';

class AddUserScrean extends StatefulWidget {
  AddUserScrean({Key key}) : super(key: key);

  @override
  _AddUserScreanState createState() => _AddUserScreanState();
}

class _AddUserScreanState extends State<AddUserScrean> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        iconTheme: IconThemeData(color: greyw),
        backgroundColor: Kprimary.withOpacity(0.85),
        title: Text(
          "Add User",
          style: TextStyle(color: greyw, fontWeight: FontWeight.w600),
        ),
      ),
      body: SignupBody(),
    );
  }
}
