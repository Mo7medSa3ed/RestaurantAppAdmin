import 'package:flutter/material.dart';
import 'package:deliveryapp/API.dart';
import 'package:deliveryapp/constants.dart';
import 'package:deliveryapp/custum_widget.dart';
import 'package:deliveryapp/size_config.dart';
import 'package:connectivity/connectivity.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  bool networktest = true;
  static const titles = const [
    'Admins',
    'User',
    'Delivery',
    'Dish',
    'Category',
    'Coupon',
    'Recent',
    'Confirmed',
    'Delivered',
    'Canceled',
  ];
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
    return Container(
      child: RefreshIndicator(
        onRefresh: () {
          setState(() {});
          return Future.value("data");
        },
        child: FutureBuilder(
            future: API.getHome(),
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data;
                final list = [
                  data['admins'],
                  data['users'],
                  data['deliveries'],
                  data['dishes'],
                  data['categories'],
                  data['coupons'],
                  data['recentOrders'],
                  data['confirmedOrders'],
                  data['deliveredOrders'],
                  data['canceledOrders'],
                ];

                return GridView.builder(
                    itemCount: list.length,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1.2, crossAxisCount: 2),
                    itemBuilder: (ctx, i) => buildCardForHome(
                        text: list[i].toString() + '\t' + titles[i]));
              }
              return Center(
                child: CircularProgressIndicator(
                  color: Kprimary,
                ),
              );
            }),
      ),
    );
  }

  Widget buildCardForHome({icon, text}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      elevation: 5,
      child: Container(
        // height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
                backgroundColor: Kprimary.withOpacity(0.95),
                child: Icon(
                  icon ?? Icons.person,
                  color: white,
                )),
            Text(
              text ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
