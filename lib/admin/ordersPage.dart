import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:deliveryapp/components/primary_orders_widget.dart';
import 'package:deliveryapp/constants.dart';
import 'package:deliveryapp/provider/appdata.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class OrdersPage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<OrdersPage> {
  AppData appData;

  Future<List<Address>> getcurrantLocation(o) async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final coordinates = new Coordinates(o[1], o[0]);
    List<Address> addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return addresses;
  }

  requestPermissions() async {
    if (await Geolocator.isLocationServiceEnabled())
      await Geolocator.requestPermission();
  } 

  @override
  void initState() {
    super.initState();
    requestPermissions();
    appData = Provider.of<AppData>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appData = Provider.of<AppData>(context, listen: true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        initialIndex: 0,
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                'All Orders',
                style: TextStyle(
                    fontWeight: FontWeight.w800, color: Kprimary, fontSize: 28),
              ),
              bottom: TabBar(
                unselectedLabelColor: Kprimary.withOpacity(0.6),
                overlayColor: MaterialStateProperty.all(red),
                indicatorColor: Kprimary,
                unselectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Kprimary.withOpacity(0.6),
                    fontSize: 14),
                labelColor: Kprimary,
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w800, color: Kprimary, fontSize: 16),
                tabs: [
                  Tab(
                    text: "Recent",
                  ),
                  Tab(
                    text: "Confirmed",
                  ),
                  Tab(
                    text: "Delivered",
                  ),
                  Tab(
                    text: "Canceled",
                  ),
                ],
              ),
            ),
            body: TabBarView(physics: BouncingScrollPhysics(),
                //controller: controller,
                children: [
                  OrdersWidget('Placed'),
                  OrdersWidget('Confirmed'),
                  OrdersWidget('Delivered'),
                  OrdersWidget('Canceled'),
                ])));
  }
}
