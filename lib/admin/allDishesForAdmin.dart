import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:deliveryapp/API.dart';
import 'package:deliveryapp/admin/addDish.dart';
import 'package:deliveryapp/admin/allDishesTable.dart';
import 'package:deliveryapp/constants.dart';
import 'package:deliveryapp/models/dish.dart';
import 'package:deliveryapp/provider/appdata.dart';

// ignore: must_be_immutable
class AllDishesForAdminScrean extends StatelessWidget {
  AppData app;

  @override
  Widget build(BuildContext context) {
    app = Provider.of<AppData>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        iconTheme: IconThemeData(color: greyw),
        backgroundColor: Kprimary.withOpacity(0.9),
        title: Text(
          "All Dishes",
          style: TextStyle(color: greyw, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.add_box_outlined,
                size: 30,
              ),
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => AddDishScrean()))),
          SizedBox(
            width: 8,
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<dynamic>(
            future: API.getAllDishes(),
            builder: (c, s) {
              if (s.hasData) {
                if (s.data['status'] && s.data['data'].length > 0) {
                  app.initDishesList(s.data['data'] as List<Dish>);
                  return AllDishesTable();
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
                              "Your Dishes is Empty",
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
