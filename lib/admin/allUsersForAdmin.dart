import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:resturantapp/API.dart';
import 'package:resturantapp/admin/allUsersTable.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/models/user.dart';

class AllUsersForAdminScrean extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        iconTheme: IconThemeData(color: greyw),
        backgroundColor: Kprimary.withOpacity(0.9),
        title: Text(
          "All Users",
          style: TextStyle(color: greyw, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<dynamic>(
            future: API.getAllUser(),
            builder: (c, s) {
              if (s.hasData) {
                if (s.data['status'] && s.data['data'].length > 0) {
                  return AllUsersTable(
                    userlist: s.data['data'] as List<User>,
                  );
                }
                return Center(
                    child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/List.png",
                              fit: BoxFit.fill,
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.width * 0.5,
                            ),
                            Text(
                              "Your Users is Empty",
                              style: TextStyle(color: grey, fontSize: 18),
                            )
                          ],
                        )));
              } else {
                return Center(
                  child: SpinKitCircle(
                    color: Kprimary,
                  ),
                );
              }
            }),
      ),
    );
  }
}
