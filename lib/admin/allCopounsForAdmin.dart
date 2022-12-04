import 'dart:convert';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:deliveryapp/API.dart';
import 'package:deliveryapp/admin/allCopounsTable.dart';
import 'package:deliveryapp/constants.dart';
import 'package:deliveryapp/models/copoun.dart';
import 'package:deliveryapp/provider/appdata.dart';

// ignore: must_be_immutable
class AllCopounsForAdminScrean extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  String name;
  String duration;
  String amount;
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
          "All Copouns",
          style: TextStyle(color: greyw, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.add_box_outlined,
                size: 30,
              ),
              onPressed: () async => await showdialogForAdd(context)),
          SizedBox(
            width: 8,
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<dynamic>(
            future: API.getAllCopouns(),
            builder: (c, s) {
              if (s.hasData) {
                if (s.data['status'] && s.data['data'].length > 0) {
                  app.initCopounList(s.data['data'] as List<Copoun>);
                  return AllCopounsTable();
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
                              "Your Copouns is Empty",
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

  showdialogForAdd(context) {
    return showDialog(
        context: context,
        builder: (c) => AlertDialog(
              title: Text(
                "Add Copoun",
                style: TextStyle(color: Kprimary),
                textAlign: TextAlign.center,
              ),
              content: Container(
                width: MediaQuery.of(c).size.width * 0.7,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            onSaved: (s) => name = s,
                            validator: (String v) => v.isEmpty
                                ? 'please enter copoun name !!'
                                : null,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(20),
                                border: InputBorder.none,
                                fillColor: greyw,
                                hintText: 'Enter your copoun name...',
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Kprimary.withOpacity(0.35)),
                                filled: true),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            onSaved: (s) => duration = s,
                            validator: (String v) => v.isEmpty
                                ? 'please enter copoun duration !!'
                                : null,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(20),
                                border: InputBorder.none,
                                fillColor: greyw,
                                hintText: 'Enter your copoun duration...',
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Kprimary.withOpacity(0.35)),
                                filled: true),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            onSaved: (s) => amount = s,
                            validator: (String v) => v.isEmpty
                                ? 'please enter copoun amount !!'
                                : null,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(20),
                                border: InputBorder.none,
                                fillColor: greyw,
                                hintText: 'Enter your copoun amount...',
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Kprimary.withOpacity(0.35)),
                                filled: true),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(red),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.all(12))),
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: white),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Kprimary),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.all(12))),
                              onPressed: () async {
                                if (formKey.currentState.validate()) {
                                  formKey.currentState.save();
                                  Navigator.pop(c);
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.loading,
                                    text: "loading please wait....",
                                    barrierDismissible: false,
                                  );
                                  final reqData = {
                                    "text": name,
                                    "duration": int.parse(duration),
                                    "amount": int.parse(amount)
                                  };
                                  final res = await API.addCopoun(reqData);
                                  if (res.statusCode == 200 ||
                                      res.statusCode == 201) {
                                    final body = utf8.decode(res.bodyBytes);
                                    final parsed = json.decode(body);
                                    Copoun d = Copoun.fromJson(parsed);
                                    app = Provider.of<AppData>(context,
                                        listen: false);

                                    app.addtoCopoun(d);
                                    Navigator.of(context).pop();

                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.success,
                                        title: 'Add Copoun',
                                        text: "Copoun Added Successfully",
                                        barrierDismissible: false,
                                        confirmBtnColor: Kprimary,
                                        onConfirmBtnTap: () =>
                                            Navigator.of(context).pop());
                                  } else {
                                    Navigator.of(context).pop();
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        title: 'Error',
                                        text: "some thing went error !!",
                                        barrierDismissible: false,
                                        showCancelBtn: true);
                                  }
                                }
                              },
                              child: Text(
                                'Add',
                                style: TextStyle(color: white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
}
