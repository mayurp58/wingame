import 'dart:convert';

import 'package:wingame/common/api_service.dart';
import 'package:wingame/loader.dart';
import 'package:wingame/pages/login_page.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wingame/globalvar.dart' as globals;
class StarlineTerms extends StatefulWidget {
  const StarlineTerms({Key? key}) : super(key: key);

  @override
  State<StarlineTerms> createState() => _StarlineTermsState();
}

class _StarlineTermsState extends State<StarlineTerms> {
  bool isApiCallProcess = false;
  Map<String, dynamic> how_to_play = Map<String, dynamic>();
  void gethowtoplay() async {
    setState(() {
      isApiCallProcess = true;
    });
    how_to_play = {"description": "Loading","description2": "Loading","description3": "Loading","gameratio ": "Loading"};
    APIService apiService = new APIService();
    apiService
        .apicall_getdata("starline_terms").then((value) {
      Map<String, dynamic> responseJson = json.decode(value);
      var successcode = int.parse(responseJson["success"].toString());
      if (successcode != 0 && successcode != 3)
      {
        setState(() {
          isApiCallProcess = false;
        });
        print(responseJson["data"]);
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: HexColor(globals.color_blue),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              color: HexColor(globals.color_background),
              boxShadow: [new BoxShadow(
                color: HexColor(globals.color_blue),
                blurRadius: 20.0,
              ),]
            // gradient: LinearGradient(
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomCenter,
            //     colors: <Color>[
            //       HexColor(globals.color_blue),
            //       HexColor("#BD7923"),
            //       HexColor(globals.color_blue),]),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          "Terms And Conditions",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),

                  SizedBox(height: 50.0),
                  Center(
                    child: Text(
                      how_to_play["description"].toString(),
                      //textAlign: TextAlign.center,
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Center(
                    child: Text(
                      how_to_play["gameratio"].toString(),
                      textAlign: TextAlign.center,
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w400,color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Center(
                    child: Text(
                      how_to_play["description2"].toString(),
                      textAlign: TextAlign.center,
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Center(
                    child: Text(
                      how_to_play["description3"].toString(),
                      textAlign: TextAlign.center,
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: Colors.white),
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
