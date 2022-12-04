import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:deliveryapp/constants.dart';

class CustumTextField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final bool obsecure;
  final Function onchanged;
  final Function onsaved;
  final Function validator;
  final String value;
  final int v;
  final TextEditingController controller;

  CustumTextField(
      {this.hint,
      this.icon,
      this.obsecure,
      this.onchanged,
      this.validator,
      this.onsaved,
      this.controller,
      this.v,
      this.value});

  @override
  _CustumTextFieldState createState() => _CustumTextFieldState();
}

class _CustumTextFieldState extends State<CustumTextField> {
  bool shadow = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          boxShadow: shadow
              ? [
                  BoxShadow(
                    color: white,
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 0),
                  )
                ]
              : null,
          borderRadius: BorderRadius.circular(8),
          color: grey.withOpacity(0.05)),
      child: Focus(
        onFocusChange: (f) {
          setState(() {
            shadow = f;
          });
        },
        child: TextFormField(
          // style: TextStyle(color: Kprimary),
          controller: widget.controller,
          validator: widget.validator,
          onChanged: widget.onchanged,
          onSaved: widget.onsaved,
          initialValue: widget.value,
          maxLines: widget.v == 0 ? 5 : 1,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hint,
              hintStyle: TextStyle(
                  fontWeight: FontWeight.w500, letterSpacing: 1, fontSize: 14),
              prefixIcon: Icon(
                widget.icon,
                size: 25,
              )),
          obscureText: widget.obsecure,
          inputFormatters:
              widget.v == 1 ? [FilteringTextInputFormatter.digitsOnly] : null,
          keyboardType: widget.hint.toLowerCase() == 'email'
              ? TextInputType.emailAddress
              : widget.hint.toLowerCase() == 'phone'
                  ? TextInputType.phone
                  : widget.v == 1
                      ? TextInputType.number
                      : TextInputType.text,
        ),
      ),
    );
  }
}

noNetworkwidget() {
  return Container(
    width: double.infinity,
    height: double.infinity,
    color: grey[300].withOpacity(0.67),
    child: Image.asset('assets/images/net.png'),
  );
}

showDialogWidget(context) {
  CoolAlert.show(
    context: context,
    animType: CoolAlertAnimType.slideInUp,
    type: CoolAlertType.loading,
    text: "loading please wait....",
    barrierDismissible: false,
  );
}

showSnackbarWidget({msg, context, icon}) {
  CoolAlert.show(
    context: context,
    type: CoolAlertType.error,
    animType: CoolAlertAnimType.scale,
    confirmBtnColor: red,
    title: 'Error',
    text: "some thing went error !!",
    barrierDismissible: false,
  );
}
