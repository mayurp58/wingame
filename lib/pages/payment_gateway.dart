import 'dart:convert';

import 'package:wingame/globalvar.dart' as globals;
import 'package:wingame/pages/wallet.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../widgets/appbar.dart';
class PaymentGateway extends StatefulWidget {
  final String amount;
  const PaymentGateway({Key? key, required this.amount}) : super(key: key);

  @override
  State<PaymentGateway> createState() => _PaymentGatewayState();
}

class _PaymentGatewayState extends State<PaymentGateway> {
  String? user_id = globals.user_id;
  String? encryption_key = globals.token;

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    //print("BACK BUTTON!"); // Do some stuff.
    globals.tabval = 1;
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Wallet()),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> map = {
      'user_id': globals.user_id,
      'encryption_key': globals.token,
      'amount': widget.amount.toString(),
      'device_id': globals.device_id,
    };
    String credentials = globals.user_id.toString() + ":" + globals.token.toString() + ":" + widget.amount.toString() + ":" + globals.device_id.toString() ;
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);      // dXNlcm5hbWU6cGFzc3dvcmQ=
    //String decoded = stringToBase64.decode(encoded);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child :  Appbar(title: "Add Fund",)),
      body: WebView(
        initialUrl: globals.payment_gateway_url.toString() + "/" + encoded,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
