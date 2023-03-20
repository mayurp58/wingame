import 'dart:convert';

import 'package:wingame/common/api_service.dart';
import 'package:wingame/common/encrypt_service.dart';
import 'package:wingame/common/theme_helper.dart';
import 'package:wingame/gameplay/choice_panna.dart';
import 'package:wingame/gameplay/cycle_patti.dart';
import 'package:wingame/gameplay/digit_based_jodi.dart';
import 'package:wingame/gameplay/double_panna.dart';
import 'package:wingame/gameplay/dp_motor.dart';
import 'package:wingame/gameplay/full_sangam.dart';
import 'package:wingame/gameplay/group_jodi.dart';
import 'package:wingame/gameplay/half_sangam.dart';
import 'package:wingame/gameplay/panel_group.dart';
import 'package:wingame/gameplay/red_bracket.dart';
import 'package:wingame/gameplay/single_panna.dart';
import 'package:wingame/gameplay/singledigit.dart';
import 'package:wingame/gameplay/sp_dp_tp.dart';
import 'package:wingame/gameplay/sp_motor.dart';
import 'package:wingame/gameplay/triple_panna.dart';
import 'package:wingame/gameplay/two_digit_panel.dart';
import 'package:wingame/globalvar.dart' as globals;
import 'package:wingame/pages/landing_page.dart';
import 'package:wingame/pages/login_page.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../gameplay/jodi_digit.dart';
import '../loader.dart';
class GameTypes extends StatefulWidget {
  final String? title;
  final String? status;
  final int id;
  const GameTypes({Key? key, required this.id, required this.title, required this.status}) : super(key: key);

  @override
  State<GameTypes> createState() => _GameTypesState();
}

class _GameTypesState extends State<GameTypes> {
  //List<dynamic> landingdata =["ic_signledigit.png","ic_jodidigit.png","ic_redbracket.png","ic_digitbasedjodi.png","ic_groupjodi.png","ic_singlepana.png","ic_doublepana.png","ic_tripplepana.png","ic_spdptp.png","ic_twodigitpana.png","ic_panelgroup.png","ic_choicepana.png","ic_spmotor.png"];
  bool isApiCallProcess = false;
  String open = "false";
  String date = "01-01-1970";

  void get_game_sessions() async {
    setState(() {
      isApiCallProcess = true;
    });
    Map<String, dynamic> map = {
      'user_id': globals.user_id,
      'encryption_key': globals.token,
      'prov_id': widget.id,
    };
    APIService apiService = new APIService();
    apiService
        .apicall({"str": encryp(json.encode(map))}, "get_game_session").then((value) {
      Map<String, dynamic> responseJson =  json.decode(value);
      var successcode = int.parse(responseJson["success"].toString());
      if (successcode != 0 && successcode != 3) {
        setState(() {
          isApiCallProcess = false;
          open = responseJson["sessions"]["open"];
          date = responseJson["date"];
        });

        //print(responseJson["sessions"]);


      } else if (successcode == 3) {
        setState(() {
          isApiCallProcess = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        setState(() {
          isApiCallProcess = false;
        });
        var snackBar = SnackBar(
          content: Text(responseJson["message"]),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    get_game_sessions();
    setState(() {
      globals.tabval = 0;
      globals.gametyp = 1;
    });
    BackButtonInterceptor.add(myInterceptorr, zIndex:2, name:"Gametypes");

  }

  @override
  void dispose() {
    //BackButtonInterceptor.remove(myInterceptorr);
    BackButtonInterceptor.removeByName("Gametypes");
    super.dispose();
  }

  bool myInterceptorr(bool stopDefaultButtonEvent, RouteInfo info) {
    //print(globals.gametyp);
    if(globals.gametyp == 1)
    {
      //print ("A");
      //Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LandingPage())
      );
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      //opacity: 0.3,
    );

  }

  @override
  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(globals.color_background),
        appBar: AppBar(
          centerTitle: true,
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
          //backgroundColor: HexColor(globals.color_blue),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LandingPage()),
              );
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text(
            widget.title.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
        body:SingleChildScrollView(
          child: Container(
                child: Column(
                  children: [
                    Align(
                      alignment:Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Container(
                          decoration: BoxDecoration(
                            //color: HexColor(globals.color_blue),
                            gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          //color: HexColor(globals.color_blue),
                          child: Text("ANK",style: TextStyle(color: Colors.white,),)
                        ),
                      )
                    ),
                    ///////////////////////////////////////////////////////////////////////////////
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Align(
                        alignment:Alignment.center,
                        child: Container(
                          width: 80,
                          height: 80,
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                            border: Border.all(color: HexColor("#000")),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black,
                            boxShadow: [BoxShadow(color: HexColor(globals.color_blue),blurRadius: 1)],
                          ),
                          //color: Colors.grey,
                          child: InkWell(
                              onTap: (){
                                open=="true" ? dialog_open_close(context,"Single_Digit") : dialog_close_only(context,"Single_Digit");
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: 5,),
                                  Image.asset("assets/single_digit.png",height: 40,),
                                  SizedBox(height: 5,),
                                  Text("Single\nDigit",textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: HexColor("#FFFFFF")),)
                                ],
                              )
                          ),
                        ),
                      ),
                    ],),
                    ////////////////////////////////////////////////////////////////////////////////////
                    Align(
                        alignment:Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                                color: HexColor(globals.color_blue),
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                              ),
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              //color: HexColor(globals.color_blue),
                              child: Text("JODI",style: TextStyle(color: Colors.white,),)
                          ),
                        )
                    ),
                    ////////////////////////////////////////////////////////////////////////////////////
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ////////////////Jodi Digit///////////////////
                        Container(
                          width: 80,
                          height: 80,
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: HexColor("#000000")),
                            gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: HexColor(globals.color_blue), blurRadius: 1)
                            ],
                          ),
                          //color: Colors.grey,
                          child: InkWell(
                              onTap: () {
                                open=="true" ? jump_to_page("JodiDigit",widget.title,"close",widget.id) : dialog_market_close(context,"Jodi Digit");
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: 5,),
                                  Image.asset(open=="true" ? "assets/jodi_digit.png" : "assets/closed.png", height: 40,),
                                  SizedBox(height: 5,),
                                  Text("Jodi Digits", textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),)
                                ],
                              )
                          ),
                        ),
                        //////////////////////Jodi Digit End

                        ////////////////Red Bracket///////////////////
                        Container(
                          width: 80,
                          height: 80,
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: HexColor("#000000")),
                            gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: HexColor(globals.color_blue),blurRadius: 1)],
                          ),
                          //color: Colors.grey,
                          child: InkWell(
                              onTap: (){
                                open=="true" ? jump_to_page("red_bracket",widget.title,"close",widget.id) : dialog_market_close(context,"Red Bracket");
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: 5,),
                                  Image.asset(open=="true" ? "assets/red_bracket.png" : "assets/closed.png",height: 40,),
                                  SizedBox(height: 5,),
                                  Text("Red Bracket",textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),)
                                ],
                              )
                          ),
                        ),
                        //////////////////////Jodi Digit End
                        ////////////////Digit Based Jodi///////////////////
                        Container(
                          width: 80,
                          height: 80,
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: HexColor("#000000")),
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: HexColor(globals.color_blue),blurRadius: 1)],
                          ),
                          //color: Colors.grey,
                          child: InkWell(
                              onTap: (){
                                open=="true" ? jump_to_page("digit_based_jodi",widget.title,"close",widget.id) : dialog_market_close(context,"Digit Based Jodi");
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: 5,),
                                  Image.asset(open=="true" ? "assets/digit_based_jodi.png" : "assets/closed.png",height: 40,),
                                  SizedBox(height: 5,),
                                  Text("Digit Base\nJodi",textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),)
                                ],
                              )
                          ),
                        ),
                        ////////////////////// Digit based jodi End
                        ////////////////Group Jodi///////////////////
                        Container(
                          width: 80,
                          height: 80,
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: HexColor("#000000")),
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: HexColor(globals.color_blue),blurRadius: 1)],
                          ),
                          //color: Colors.grey,
                          child: InkWell(
                              onTap: (){
                                open=="true" ? jump_to_page("group_jodi",widget.title,"close",widget.id) : dialog_market_close(context,"Group Jodi");
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: 5,),
                                  Image.asset(open=="true" ? "assets/group_jodi.png" : "assets/closed.png",height: 40,),
                                  SizedBox(height: 5,),
                                  Text("Group Jodi",textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),)
                                ],
                              )
                          ),
                        ),
                        //////////////////////Group Jodi End
                      ],
                    ),
                    Row(
                      children: [

                      ],
                    ),
                    ////////////////////////////////////////////////////////////////////////////////////
                    Align(
                        alignment:Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                                color: HexColor(globals.color_blue),
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                              ),
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              //color: HexColor(globals.color_blue),
                              child: Text("PANNA",style: TextStyle(color: Colors.white,),)
                          ),
                        )
                    ),
                    ////////////////////////////////////////////////////////////////////////////////////
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      ////////////////Single Panna///////////////////
                      Container(
                        width: 80,
                        height: 80,
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        decoration: BoxDecoration(
                          border: Border.all(color: HexColor("#000000")),
                          gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          boxShadow: [BoxShadow(color: HexColor(globals.color_blue),blurRadius: 1)],
                        ),
                        //color: Colors.grey,
                        child: InkWell(
                            onTap: (){
                              open=="true" ? dialog_open_close(context,"Single_Panna") : dialog_close_only(context,"Single_Panna");
                            },
                            child: Column(
                              children: [
                                SizedBox(height: 5,),
                                Image.asset("assets/single_panna.png",height: 40,),
                                SizedBox(height: 5,),
                                Text("Single Panna",textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),)
                              ],
                            )
                        ),
                      ),
                      //////////////////////Single Panna End
                      ////////////////Double Panna///////////////////
                      Container(
                        width: 80,
                        height: 80,
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        decoration: BoxDecoration(
                          border: Border.all(color: HexColor("#000000")),
                          gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          boxShadow: [BoxShadow(color: HexColor(globals.color_blue),blurRadius: 1)],
                        ),
                        //color: Colors.grey,
                        child: InkWell(
                            onTap: (){
                              open=="true" ? dialog_open_close(context,"Double_Panna") : dialog_close_only(context,"Double_Panna");
                            },
                            child: Column(
                              children: [
                                SizedBox(height: 5,),
                                Image.asset("assets/double_panna.png",height: 40,),
                                SizedBox(height: 5,),
                                Text("Double Panna",textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),)
                              ],
                            )
                        ),
                      ),
                      //////////////////////Double Panna
                      ////////////////Tripple Panna///////////////////
                      Container(
                        width: 80,
                        height: 80,
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        decoration: BoxDecoration(
                          border: Border.all(color: HexColor("#000000")),
                          gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          boxShadow: [BoxShadow(color: HexColor(globals.color_blue),blurRadius: 1)],
                        ),
                        //color: Colors.grey,
                        child: InkWell(
                            onTap: (){
                              open=="true" ? dialog_open_close(context,"Triple_Panna") : dialog_close_only(context,"Triple_Panna");
                            },
                            child: Column(
                              children: [
                                SizedBox(height: 5,),
                                Image.asset("assets/tripple_panna.png",height: 40,),
                                SizedBox(height: 5,),
                                Text("Triple Panna",textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),)
                              ],
                            )
                        ),
                      ),
                      //////////////////////Triple Panna
                        ////////////////SP Dp Tp///////////////////
                        Container(
                          width: 80,
                          height: 80,
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: HexColor("#000000")),
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: HexColor(globals.color_blue),blurRadius: 1)],
                          ),
                          //color: Colors.grey,
                          child: InkWell(
                              onTap: (){
                                open=="true" ? dialog_open_close(context,"SpDpTp") : dialog_close_only(context,"SpDpTp");
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: 5,),
                                  Image.asset("assets/spdptp.png",height: 40,),
                                  SizedBox(height: 5,),
                                  Text("Sp-Dp-Tp",textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),)
                                ],
                              )
                          ),
                        ),
                        //////////////////////SP DP TP
                    ],),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ////////////////Two Digit Panel///////////////////
                        Container(
                          width: 80,
                          height: 80,
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: HexColor("#000000")),
                            gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: HexColor(globals.color_blue),blurRadius: 1)],
                          ),
                          //color: Colors.grey,
                          child: InkWell(
                              onTap: (){
                                open=="true" ? dialog_open_close(context,"Two_Digit_panel") : dialog_close_only(context,"Two_Digit_panel");
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: 5,),
                                  Image.asset("assets/tow_digit_panel.png",height: 40,),
                                  SizedBox(height: 5,),
                                  Text("Two Digit Panel",textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),)
                                ],
                              )
                          ),
                        ),
                        //////////////////////Two Digit Panel
                        ////////////////Panel Group///////////////////
                        Container(
                          width: 80,
                          height: 80,
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: HexColor("#000000")),
                            gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: HexColor(globals.color_blue),blurRadius: 1)],
                          ),
                          //color: Colors.grey,
                          child: InkWell(
                              onTap: (){
                                open=="true" ? dialog_open_close(context,"Panel_Group") : dialog_close_only(context,"Panel_Group");
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: 5,),
                                  Image.asset("assets/panel_group.png",height: 40,),
                                  SizedBox(height: 5,),
                                  Text("Family Panna",textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),)
                                ],
                              )
                          ),
                        ),
                        //////////////////////Panel Group
                        ////////////////Choice Panna///////////////////
                        Container(
                          width: 80,
                          height: 80,
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: HexColor("#000000")),
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: HexColor(globals.color_blue),blurRadius: 1)],
                          ),
                          //color: Colors.grey,
                          child: InkWell(
                              onTap: (){
                                open=="true" ? dialog_open_close(context,"choice_panna") : dialog_close_only(context,"choice_panna");
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: 5,),
                                  Image.asset("assets/choice_panna.png",height: 40,),
                                  SizedBox(height: 5,),
                                  Text("Choice Panna",textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),)
                                ],
                              )
                          ),
                        ),
                        //////////////////////Choice Panna
                        ////////////////Cycle Panna///////////////////
                        Container(
                          width: 80,
                          height: 80,
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: HexColor("#000000")),
                            gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: HexColor(globals.color_blue),blurRadius: 1)],
                          ),
                          //color: Colors.grey,
                          child: InkWell(
                              onTap: (){
                                open=="true" ? dialog_open_close(context,"cycle_patti") : dialog_close_only(context,"cycle_patti");
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: 5,),
                                  Image.asset("assets/cycle_patti.png",height: 40,),
                                  SizedBox(height: 5,),
                                  Text("Cycle Patti",textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),)
                                ],
                              )
                          ),
                        ),
                        //////////////////////Cycle Panna
                      ],
                    ),
                    ////////////////////////////////////////////////////////////////////////////////////
                    Align(
                        alignment:Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                                color: HexColor(globals.color_blue),
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                              ),
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              //color: HexColor(globals.color_blue),
                              child: Text("MOTOR",style: TextStyle(color: Colors.white,),)
                          ),
                        )
                    ),
                    ////////////////////////////////////////////////////////////////////////////////////
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ////////////////Sp Motor///////////////////
                        Container(
                          width: 80,
                          height: 80,
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: HexColor("#000000")),
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: HexColor(globals.color_blue),blurRadius: 1)],
                          ),
                          //color: Colors.grey,
                          child: InkWell(
                              onTap: (){
                                open=="true" ? dialog_open_close(context,"sp_motor") : dialog_close_only(context,"sp_motor");
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: 5,),
                                  Image.asset("assets/sp_motor.png",height: 40,),
                                  SizedBox(height: 5,),
                                  Text("SP Motor",textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),)
                                ],
                              )
                          ),
                        ),
                        //////////////////////Sp Motor
                        ////////////////Dp Motor///////////////////
                        Container(
                          width: 80,
                          height: 80,
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: HexColor("#000000")),
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: HexColor(globals.color_blue),blurRadius: 1)],
                          ),
                          //color: Colors.grey,
                          child: InkWell(
                              onTap: (){
                                open=="true" ? dialog_open_close(context,"dp_motor") : dialog_close_only(context,"dp_motor");
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: 5,),
                                  Image.asset("assets/dp_motor.png",height: 40,),
                                  SizedBox(height: 5,),
                                  Text("DP Motor",textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),)
                                ],
                              )
                          ),
                        ),
                        //////////////////////Dp Motor
                      ],
                    ),
                    ////////////////////////////////////////////////////////////////////////////////////
                    Align(
                        alignment:Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                                color: HexColor(globals.color_blue),
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                              ),
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              //color: HexColor(globals.color_blue),
                              child: Text("SANGAM",style: TextStyle(color: Colors.white,),)
                          ),
                        )
                    ),
                    ////////////////////////////////////////////////////////////////////////////////////
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ////////////////Half Sangam///////////////////
                        Container(
                          width: 80,
                          height: 80,
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: HexColor("#000000")),
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: HexColor(globals.color_blue),blurRadius: 1)],
                          ),
                          //color: Colors.grey,
                          child: InkWell(
                              onTap: (){
                                open=="true" ? jump_to_page("half_sangam",widget.title,"Half Sangam",widget.id) : dialog_market_close(context,"Half Sangam");
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: 5,),
                                  Image.asset(open=="true" ? "assets/half_sangam.png" : "assets/closed.png",height: 40,),
                                  SizedBox(height: 5,),
                                  Text("Half Sangam",textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),)
                                ],
                              )
                          ),
                        ),
                        //////////////////////Half Sangam
                        Container(),
                        ////////////////Full Sangam///////////////////
                        Container(
                          width: 80,
                          height: 80,
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: HexColor("#000000")),
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: HexColor(globals.color_blue),blurRadius: 1)],
                          ),
                          //color: Colors.grey,
                          child: InkWell(
                              onTap: (){
                                open=="true" ? jump_to_page("full_sangam",widget.title,"Full Sangam",widget.id) : dialog_market_close(context,"Full Sangam");
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: 5,),
                                  Image.asset(open=="true" ? "assets/full-sangam.png" : "assets/closed.png",height: 40,),
                                  SizedBox(height: 5,),
                                  Text("Full Sangam",textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),)
                                ],
                              )
                          ),
                        ),
                        //////////////////////Full Sangam End
                      ],
                    ),
                  ],
                ),
          ),
        ),
    );
  }

  void dialog_open_close(BuildContext context,String page) {
    showDialog(context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 160,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Text("Select Session",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                    SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                border: Border.all(color: HexColor("#000000")),
                                gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: HexColor(globals.color_blue), blurRadius: 2)
                                ],
                              ),
                              //color: Colors.grey,
                              child: IconButton(
                                icon: Image.asset("assets/open.png"),
                                padding: EdgeInsets.all(5),
                                onPressed: () {
                                  jump_to_page(page,widget.title,"open",widget.id);
                                },
                              ),
                            ),

                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              border: Border.all(color: HexColor("#000000")),
                              gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: [BoxShadow(color: HexColor(globals.color_blue),blurRadius: 2)],
                            ),
                            //color: Colors.grey,
                            child: IconButton(
                              icon: Image.asset("assets/close.png"),
                              padding: EdgeInsets.all(5),
                              onPressed: () {
                                jump_to_page(page,widget.title,"close",widget.id);
                              },
                            ),
                          ),
                        ],
                      )

                  ],
                ),
              ),
            ),
          );
        });
        //}).then((_) => open = false.toString());
  }

  void dialog_close_only(BuildContext context,String page,) {
    showDialog(context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 120,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            border: Border.all(color: HexColor("#000000")),
                            gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: HexColor(globals.color_blue),blurRadius: 2)],
                          ),
                          //color: Colors.grey,
                          child: IconButton(
                            icon: Image.asset("assets/close.png"),
                            padding: EdgeInsets.all(5),
                            onPressed: () {
                              jump_to_page(page,widget.title,"close",widget.id);
                            },
                          ),
                        ),
                      ],
                    )

                  ],
                ),
              ),
            ),
          );
        });
        //}).then((_) => open = false.toString());
  }

  void dialog_market_close(BuildContext context,String page,) {
    showDialog(context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              width: 300,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Text(page,textAlign: TextAlign.center, style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                    SizedBox(height: 20,),
                    Text("This Game Isn't Available At The Moment. The Open Bid Time Is Over ",),
                    SizedBox(height: 20,),
                    Center(
                      child: ElevatedButton(
                          style : ThemeHelper().filled_square_button(),
                          onPressed: (){
                        Navigator.pop(context);
                      }, child: Text("Ok",style: TextStyle(color: HexColor(globals.color_pink)),)),
                    )

                  ],
                ),
              ),
            ),
          );
        });
    //}).then((_) => open = false.toString());
  }

  void jump_to_page(String? page,String? title,String? session,int id)
  {
    setState(() {
      globals.gametyp = 1;
    });
    if(page=="Single_Digit") {
      //Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SingleDigit(title: title,session:session,id: id,date: date,))
      );
    }
    if(page=="JodiDigit") {
      //Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => JodiDigit(title: title,session:session,id: id,date: date,))
      );
    }
    if(page=="red_bracket") {
      //Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RedBracket(title: title,session:session,id: id,date: date,))
      );
    }
    if(page=="digit_based_jodi") {
      //Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DigitBasedJodi(title: title,session:session,id: id,date: date,))
      );
    }
    if(page=="group_jodi") {
      //Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GroupJodi(title: title,session:session,id: id,date: date,))
      );
    }
    if(page=="Single_Panna") {
      //Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SinglePanna(title: title,session:session,id: id,date: date,))
      );
    }
    if(page=="Double_Panna") {
      //Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DoublePanna(title: title,session:session,id: id,date: date,))
      );
    }
    if(page=="Triple_Panna") {
      //Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TriplePanna(title: title,session:session,id: id,date: date,))
      );
    }
    if(page=="SpDpTp") {
      //Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SpDpTp(title: title,session:session,id: id,date: date,))
      );
    }
    if(page=="Two_Digit_panel") {
      //Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TwoDigitPanel(title: title,session:session,id: id,date: date,))
      );
    }
    if(page=="Panel_Group") {
      //Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PanelGroup(title: title,session:session,id: id,date: date,))
      );
    }
    if(page=="choice_panna") {
      //Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChoicePanna(title: title,session:session,id: id,date: date,))
      );
    }
    if(page=="sp_motor") {
      //Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SpMotor(title: title,session:session,id: id,date: date,))
      );
    }
    if(page=="dp_motor") {
      //Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DpMotor(title: title,session:session,id: id,date: date,))
      );
    }
    if(page=="half_sangam") {
      //Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HalfSangam(title: title,session:session,id: id,date: date,))
      );
    }
    if(page=="full_sangam") {
      //Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FullSangam(title: title,session:session,id: id,date: date,))
      );
    }
    if(page=="cycle_patti") {
      //Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CyclePatti(title: title,session:session,id: id,date: date,))
      );
    }
  }
}
