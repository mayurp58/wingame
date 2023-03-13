import 'dart:convert';

import 'package:wingame/common/api_service.dart';
import 'package:wingame/loader.dart';
import 'package:wingame/pages/login_page.dart';
import 'package:wingame/widgets/GradientText.dart';
import 'package:wingame/widgets/appbar.dart';
import 'package:wingame/widgets/navigationbar.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wingame/globalvar.dart' as globals;
class GameRates extends StatefulWidget {
  const GameRates({Key? key}) : super(key: key);

  @override
  State<GameRates> createState() => _GameRatesState();
}

class _GameRatesState extends State<GameRates> {
  bool isApiCallProcess = false;
  List<dynamic> gamerates =[];
  List<dynamic> starline =[];
  void gethowtoplay() async {
    setState(() {
      isApiCallProcess = true;
    });

    APIService apiService = new APIService();
    apiService
        .apicall_getdata("game_rates").then((value) {
      Map<String, dynamic> responseJson = json.decode(value);
      var successcode = int.parse(responseJson["success"].toString());
      if (successcode != 0 && successcode != 3)
      {
        final rates = List<dynamic>.from(
          responseJson["main"].map<dynamic>(
                (dynamic item) => item,
          ),
        );
        final star_rates = List<dynamic>.from(
          responseJson["starline"].map<dynamic>(
                (dynamic item) => item,
          ),
        );
        setState(() {
          isApiCallProcess = false;
          gamerates = rates;
          starline = star_rates;
        });

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
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 30,),
            Container(
              child: GradientText("Market Game Win Ratio",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
            ),
            Card(
              color: Colors.black,
              elevation: 10, //shadow elevation for card
              margin: EdgeInsets.all(8),
              shadowColor: HexColor("#FEDB87"),
              child: Padding(
                padding: EdgeInsets.all(25),
                child: ListView.separated(
                  itemCount: gamerates.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: 15);
                  },
                  itemBuilder: (context,index)
                  {

                    return Row(

                      children: [
                        SizedBox(width: 10,child: Icon(Icons.gamepad_rounded,color: HexColor("#FEDB87"),size: 18,),),
                        SizedBox(width: 10,),
                        SizedBox(width: 100, child: Text(gamerates[index]["game_name"],style: TextStyle(fontSize: 16,color: Colors.white),)),

                        SizedBox(width: 40,),
                        Text(":-",style: TextStyle(fontSize: 16,color: Colors.white),),
                        SizedBox(width: 10,),
                        Text(gamerates[index]["point"] + " = " + gamerates[index]["game_price"],style: TextStyle(fontSize: 16,color: Colors.white),),
                      ],
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 30,),
            Container(
              child: GradientText("Starline Game Win Ratio",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
            ),
            Card(
              color: Colors.black,
              elevation: 10, //shadow elevation for card
              margin: EdgeInsets.all(8),
              shadowColor: HexColor("#FEDB87"),
              child: Padding(
                padding: EdgeInsets.all(25),
                child: ListView.separated(
                  itemCount: starline.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: 15);
                  },
                  itemBuilder: (context,index)
                  {
                    return Row(
                      children: [
                        SizedBox(width: 10, child :Icon(Icons.gamepad_rounded,color: HexColor("#FEDB87"),size: 18,)),
                        SizedBox(width: 10,),
                        SizedBox(width: 100, child: Text(starline[index]["game_name"],style: TextStyle(fontSize: 16,color: Colors.white),),),
                        SizedBox(width: 40,),
                        Text(":-",style: TextStyle(fontSize: 16,color: Colors.white),),
                        SizedBox(width: 10,),
                        Text(starline[index]["point"] + " = " + starline[index]["game_price"],style: TextStyle(fontSize: 16,color: Colors.white),),
                      ],
                    );
                  },
                ),
              ),
            ),

          ],
        ),
      )
    );
  }
}