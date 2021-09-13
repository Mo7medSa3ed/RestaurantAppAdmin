import 'package:deliveryapp/provider/appdata.dart';
import 'package:flutter/material.dart';
import 'package:deliveryapp/admin/allCategorysForAdmin.dart';
import 'package:deliveryapp/admin/allCopounsForAdmin.dart';
import 'package:deliveryapp/admin/allDishesForAdmin.dart';
import 'package:deliveryapp/admin/allUsersForAdmin.dart';
import 'package:deliveryapp/admin/ordersPage.dart';
import 'package:deliveryapp/constants.dart';
import 'package:deliveryapp/screans/loginScrean.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            DrawerHeader(
                margin: EdgeInsets.all(0),
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                      color: Kprimary.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(8)),
                  accountName: Text(
                    Provider.of<AppData>(context, listen: false)
                            .loginUser
                            .name ??
                        "",
                    style: TextStyle(fontSize: 14),
                  ),
                  accountEmail: Text(
                    Provider.of<AppData>(context, listen: false)
                            .loginUser
                            .email ??
                        "",
                    style: TextStyle(fontSize: 12),
                  ),
                )),
            ListTile(
              title: Text("Dishes"),
              onTap: () => go(AllDishesForAdminScrean(), context),
            ),
            ListTile(
              title: Text("Users"),
              onTap: () => go(AllUsersForAdminScrean(), context),
            ),
            ListTile(
              title: Text("Categories"),
              onTap: () => go(AllCategoriesForAdminScrean(), context),
            ),
            ListTile(
              title: Text("Orders"),
              onTap: () => go(OrdersPage(), context),
            ),
            ListTile(
              title: Text("Copouns"),
              onTap: () => go(AllCopounsForAdminScrean(), context),
            ),
            ListTile(
                title: Text("Logout"),
                onTap: () async{
                  await logout(context);
                  return Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => LoginScrean()),
                      (route) => false);
                }),
          ],
        ),
      ),
    );
  }
}

go(screan, context) {
  Navigator.of(context).pop();
  return Navigator.of(context).push(MaterialPageRoute(builder: (_) => screan));
}
