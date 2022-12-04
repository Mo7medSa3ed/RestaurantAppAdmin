import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:deliveryapp/API.dart';
import 'package:deliveryapp/components/primart_elevatedButtom.dart';
import 'package:deliveryapp/components/primary_cart_card.dart';
import 'package:deliveryapp/constants.dart';
import 'package:deliveryapp/models/order.dart';
import 'package:deliveryapp/provider/appdata.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class OrderDetailsScrean extends StatefulWidget {
  final id;
  final lat;
  final lng;
  OrderDetailsScrean({this.id, this.lat, this.lng});
  @override
  _OrderDetailsScreanState createState() => _OrderDetailsScreanState();
}

class _OrderDetailsScreanState extends State<OrderDetailsScrean> {
  AppData app;
  bool check;
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String address;
  String promo;
  bool isExist = false;
  Position position;
  List<Address> addresses;
  Order detailsOrder;

  // getcurrantLocation() async {
  //   await Geolocator.isLocationServiceEnabled();
  //   await Geolocator.requestPermission();
  //   await Geolocator.checkPermission();
  //   position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   final coordinates = new Coordinates(position.latitude, position.longitude);
  //   addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   setState(() {});
  // }

  getAddress(position) async {
    final coordinates = new Coordinates(position.latitude, position.longitude);
    addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {});
  }

  @override
  void initState() {
    app = Provider.of<AppData>(context, listen: false);
    position = Position(latitude: widget.lat, longitude: widget.lng);
    getAddress(position);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
          child: FutureBuilder<dynamic>(
              future: API.getOneOrder(widget.id),
              builder: (ctx, v) {
                if (v.hasData) {
                  detailsOrder = Order.fromJson(v.data['data']);
                  app.initOrder(detailsOrder);

                  check = app.detailsOrder.state.toLowerCase() == 'delivered' ||
                      app.detailsOrder.state.toLowerCase() == 'canceled';
                  return Consumer<AppData>(
                    builder: (ctx, app, c) => Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            physics: AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics()),
                            children: [
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order Details',
                                    style: TextStyle(
                                        color: Kprimary,
                                        fontSize: 34,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1),
                                    textAlign: TextAlign.start,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: red,
                                      size: 35,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'SHIPPING ADDRESS',
                                    style: TextStyle(
                                        color: Kprimary.withOpacity(0.35),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1),
                                    textAlign: TextAlign.start,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Kprimary.withOpacity(0.35),
                                      size: 30,
                                    ),
                                    onPressed: () {},
                                  )
                                ],
                              ),
                              Text(
                                app.detailsOrder.user.name,
                                style: TextStyle(
                                    color: Kprimary.withOpacity(0.85),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                addresses != null
                                    ? addresses.first.addressLine
                                    : app.detailsOrder.address ?? '',
                                style: TextStyle(
                                    color: Kprimary.withOpacity(0.35),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1),
                                softWrap: true,
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'ITEMS',
                                style: TextStyle(
                                    color: Kprimary.withOpacity(0.35),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Column(
                                children: app.detailsOrder.items
                                    .map((e) => PrimaryCartCard(
                                          e.dish,
                                          details: true,
                                          amount: e.amount,
                                          test: check ? false : true,
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                        bootomSheet()
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })),
    );
  }

  Widget bootomSheet() {
    return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(color: white, boxShadow: [
          BoxShadow(
            color: grey[350].withOpacity(0.95),
            spreadRadius: 0.5,
            blurRadius: 20,
          )
        ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            check
                ? Column(
                    children: [
                      Form(
                        key: formKey2,
                        child: TextFormField(
                          onSaved: (String v) =>
                              v.isNotEmpty ? promo = v : null,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(20),
                              border: InputBorder.none,
                              fillColor: greyw,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(
                                    right: 16.0, left: 12.0, bottom: 2),
                                child: Icon(
                                  Icons.local_offer_rounded,
                                  size: 35,
                                  color: red,
                                ),
                              ),
                              hintText: 'Add Promo Code',
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Kprimary.withOpacity(0.35)),
                              filled: true),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  )
                : Container(),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL',
                      style: TextStyle(
                          color: Kprimary.withOpacity(0.20),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '\$ ${calctotal()} ',
                      style: TextStyle(
                          color: red,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Delivary charge included',
                      style: TextStyle(
                          color: Kprimary.withOpacity(0.35),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                Spacer(),
                Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: PrimaryElevatedButton(
                        text: check ? "RE ORDER" : "CANCEL",
                        onpressed: () async => app.detailsOrder.state
                                        .toLowerCase() ==
                                    'delivered' ||
                                app.detailsOrder.state.toLowerCase() == 'cancel'
                            ? null
                            : await cancelOrder(widget.id)))
              ],
            ),
          ],
        ));
  }

  String calctotal() {
    double sum = 0.0;
    app.detailsOrder.items.forEach((e) {
      sum += (e.dish.price * e.amount);
    });
    return sum.toString();
  }

  showSnackbar({msg, context, icon}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 2,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            msg,
            style: TextStyle(color: white.withOpacity(0.9), fontSize: 14),
          ),
          Icon(
            icon != null ? icon : Icons.error,
            color: icon != null ? white : red,
          ),
        ],
      ),
      backgroundColor: Kprimary,
    ));
  }

  cancelOrder(id) async {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.warning,
      title: 'Cancel Order',
      text: "Are you sure to cancel order ?",
      barrierDismissible: false,
      confirmBtnColor: red,
      showCancelBtn: true,
      onConfirmBtnTap: () async {
        Navigator.of(context).pop();
        CoolAlert.show(
          context: context,
          type: CoolAlertType.loading,
          text: "loading please wait....",
          barrierDismissible: false,
        );
        final reqData = {"state": "canceled"};
        final res = await API.patchOrder(reqData, id);
        if (res.statusCode == 200 || res.statusCode == 201) {
          Navigator.of(context).pop();
          app.changeOrderState(widget.id);
          CoolAlert.show(
              context: context,
              type: CoolAlertType.success,
              animType: CoolAlertAnimType.scale,
              title: 'Cancel Order',
              text: "Order Canceled Successfully",
              barrierDismissible: false,
              confirmBtnColor: Kprimary,
              onConfirmBtnTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              });
        } else {
          Navigator.of(context).pop();
          CoolAlert.show(
              context: context,
              type: CoolAlertType.loading,
              title: 'Error',
              text: "some thing went error !!",
              barrierDismissible: false,
              showCancelBtn: true);
        }
      },
    );
  }
}
