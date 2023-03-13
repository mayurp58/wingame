import 'package:wingame/globalvar.dart' as globals;
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../widgets/appbar.dart';
import 'landing_page.dart';
class WebpageLoader extends StatefulWidget {
  final String url;
  final int tabval;
  const WebpageLoader({Key? key, required this.url, required this.tabval}) : super(key: key);

  @override
  State<WebpageLoader> createState() => _WebpageLoaderState();
}

class _WebpageLoaderState extends State<WebpageLoader> {

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
    globals.tabval = widget.tabval;
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LandingPage()),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, kToolbarHeight),
          child :  Appbar(title: "Result History",)),
      body: WebView(
        initialUrl: widget.url,
      ),
    );
  }
}
