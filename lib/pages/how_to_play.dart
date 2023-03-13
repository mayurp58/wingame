import 'dart:convert';

import 'package:wingame/common/api_service.dart';
import 'package:wingame/loader.dart';
import 'package:wingame/pages/login_page.dart';
import 'package:wingame/widgets/GradientText.dart';
import 'package:wingame/widgets/appbar.dart';
import 'package:wingame/widgets/navigationbar.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:wingame/globalvar.dart' as globals;
import 'package:hexcolor/hexcolor.dart';
class HowtoPlay extends StatefulWidget {
  const HowtoPlay({Key? key}) : super(key: key);

  @override
  State<HowtoPlay> createState() => _HowtoPlayState();
}

class _HowtoPlayState extends State<HowtoPlay> {
  bool isApiCallProcess = false;
  Map<String, dynamic> how_to_play = Map<String, dynamic>();
  void gethowtoplay() async {
    setState(() {
      isApiCallProcess = true;
    });
    how_to_play = {"description": "Loading"};
    APIService apiService = new APIService();
    apiService
        .apicall_getdata("how_to_play").then((value) {
      Map<String, dynamic> responseJson = json.decode(value);
      var successcode = int.parse(responseJson["success"].toString());
      if (successcode != 0 && successcode != 3)
      {
        setState(() {
          isApiCallProcess = false;
        });
        how_to_play = responseJson["data"];
      }
      else
      {
        setState(() {
          isApiCallProcess = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    gethowtoplay();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    //print("BACK BUTTON!"); // Do some stuff.
    Navigator.pop(context);
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.9,
    );
  }
  @override
  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(globals.color_background),
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child :  Appbar()),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                children: [
                  SizedBox(
                    height: 70,
                  ),
                  Center(
                    child: GradientText(
                      'How To Play',
                      style:
                      TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 50.0),
                  Center(
                    child: Text(
                      how_to_play["description"].toString(),
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w400,color: Colors.white),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
