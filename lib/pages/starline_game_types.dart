import 'package:wingame/globalvar.dart' as globals;
import 'package:wingame/pages/landing_page.dart';
import 'package:wingame/starline/starline_choice_panna.dart';
import 'package:wingame/starline/starline_cycle_patti.dart';
import 'package:wingame/starline/starline_double_panna.dart';
import 'package:wingame/starline/starline_dp_motor.dart';
import 'package:wingame/starline/starline_panel_group.dart';
import 'package:wingame/starline/starline_single_digit.dart';
import 'package:wingame/starline/starline_single_panna.dart';
import 'package:wingame/starline/starline_sp_motor.dart';
import 'package:wingame/starline/starline_spdptp.dart';
import 'package:wingame/starline/starline_triple_panna.dart';
import 'package:wingame/starline/starline_twodigit_panel.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
class StarlineGameTypes extends StatefulWidget {
  final String? title;
  final String? status;
  final int id;
  const StarlineGameTypes({Key? key, required this.id, required this.title, required this.status}) : super(key: key);

  @override
  State<StarlineGameTypes> createState() => _StarlineGameTypesState();
}

class _StarlineGameTypesState extends State<StarlineGameTypes> {
  var date = new DateFormat('yyyy-MM-dd').format(DateTime.now());
  @override
  void initState() {
    super.initState();
    setState(() {
      globals.tabval = 1;
      globals.gametyp = 1;
    });
    BackButtonInterceptor.add(myInterceptorr);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptorr);
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
        backgroundColor: HexColor(globals.color_blue),
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
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                        decoration: BoxDecoration(
                          color: HexColor("#000000"),
                          gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        //color: HexColor(globals.color_blue),
                        child: Text(
                          "Ank", style: TextStyle(color: Colors.white,),)
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
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                        border: Border.all(color: HexColor("#000000")),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: HexColor("#000000"), blurRadius: 1)
                        ],
                      ),
                      //color: Colors.grey,
                      child: InkWell(
                          onTap: () {
                            //Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StarlineSingleDigit(title: widget.title,session:"open",id: widget.id,date: date.toString(),))
                            );
                          },
                          child: Column(
                            children: [
                              SizedBox(height: 5,),
                              Image.asset("assets/single_digit.png", height: 40,),
                              SizedBox(height: 5,),
                              Text("Single\nDigit", textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: HexColor("#ffffff")),)
                            ],
                          )
                      ),
                    ),
                  ),
                ],),
              ////////////////////////////////////////////////////////////////////////////////////
              Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                        decoration: BoxDecoration(
                          color: HexColor(globals.color_blue),
                          gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        //color: HexColor(globals.color_blue),
                        child: Text(
                          "Panna", style: TextStyle(color: Colors.white,),)
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
                      boxShadow: [
                        BoxShadow(color: HexColor("#000000"), blurRadius: 1)
                      ],
                    ),
                    //color: Colors.grey,
                    child: InkWell(
                        onTap: () {
                          //Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StarlineSinglePanna(title: widget.title,session:"open",id: widget.id,date: date.toString(),))
                          );
                        },
                        child: Column(
                          children: [
                            SizedBox(height: 5,),
                            Image.asset("assets/single_panna.png", height: 40,),
                            SizedBox(height: 5,),
                            Text("Single Panna", textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor("#ffffff")),)
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
                      boxShadow: [
                        BoxShadow(color: HexColor("#000000"), blurRadius: 1)
                      ],
                    ),
                    //color: Colors.grey,
                    child: InkWell(
                        onTap: () {
                          //Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StarlineDoublePanna(title: widget.title,session:"open",id: widget.id,date: date.toString(),))
                          );
                        },
                        child: Column(
                          children: [
                            SizedBox(height: 5,),
                            Image.asset("assets/double_panna.png", height: 40,),
                            SizedBox(height: 5,),
                            Text("Double Panna", textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor("#ffffff")),)
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
                      boxShadow: [
                        BoxShadow(color: HexColor("#000000"), blurRadius: 1)
                      ],
                    ),
                    //color: Colors.grey,
                    child: InkWell(
                        onTap: () {
                          //Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StarlineTriplePanna(title: widget.title,session:"open",id: widget.id,date: date.toString(),))
                          );
                        },
                        child: Column(
                          children: [
                            SizedBox(height: 5,),
                            Image.asset("assets/tripple_panna.png", height: 40,),
                            SizedBox(height: 5,),
                            Text("Triple Panna", textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor("#ffffff")),)
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
                      gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                      border: Border.all(color: HexColor("#000000")),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: HexColor("#000000"), blurRadius: 1)
                      ],
                    ),
                    //color: Colors.grey,
                    child: InkWell(
                        onTap: () {
                          //Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StarlineSpDpTp(title: widget.title,session:"open",id: widget.id,date: date.toString(),))
                          );
                        },
                        child: Column(
                          children: [
                            SizedBox(height: 5,),
                            Image.asset("assets/spdptp.png", height: 40,),
                            SizedBox(height: 5,),
                            Text("Sp-Dp-Tp", textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor("#ffffff")),)
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
                      gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                      border: Border.all(color: HexColor("#000000")),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: HexColor("#000000"), blurRadius: 1)
                      ],
                    ),
                    //color: Colors.grey,
                    child: InkWell(
                        onTap: () {
                          //Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StarlineTwoDigitPanel(title: widget.title,session:"open",id: widget.id,date: date.toString(),))
                          );
                        },
                        child: Column(
                          children: [
                            SizedBox(height: 5,),
                            Image.asset("assets/tow_digit_panel.png", height: 40,),
                            SizedBox(height: 5,),
                            Text("Two Digit Panel", textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor("#ffffff")),)
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
                      boxShadow: [
                        BoxShadow(color: HexColor("#000000"), blurRadius: 1)
                      ],
                    ),
                    //color: Colors.grey,
                    child: InkWell(
                        onTap: () {
                          //Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StarlinePanelGroup(title: widget.title,session:"open",id: widget.id,date: date.toString(),))
                          );
                        },
                        child: Column(
                          children: [
                            SizedBox(height: 5,),
                            Image.asset("assets/panel_group.png", height: 40,),
                            SizedBox(height: 5,),
                            Text("Family Panna", textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor("#ffffff")),)
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
                      gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: HexColor("#000000"), blurRadius: 1)
                      ],
                    ),
                    //color: Colors.grey,
                    child: InkWell(
                        onTap: () {
                          //Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StarlineChoicePanna(title: widget.title,session:"open",id: widget.id,date: date.toString(),))
                          );
                        },
                        child: Column(
                          children: [
                            SizedBox(height: 5,),
                            Image.asset("assets/choice_panna.png", height: 40,),
                            SizedBox(height: 5,),
                            Text("Choice Panna", textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor("#ffffff")),)
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
                      boxShadow: [
                        BoxShadow(color: HexColor("#000000"), blurRadius: 1)
                      ],
                    ),
                    //color: Colors.grey,
                    child: InkWell(
                        onTap: () {
                          //Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StarlineCyclePatti(title: widget.title,session:"open",id: widget.id,date: date.toString(),))
                          );
                        },
                        child: Column(
                          children: [
                            SizedBox(height: 5,),
                            Image.asset("assets/cycle_patti.png", height: 40,),
                            SizedBox(height: 5,),
                            Text("Cycle Patti", textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor("#ffffff")),)
                          ],
                        )
                    ),
                  ),
                  //////////////////////Cycle Panna
                ],
              ),
              ////////////////////////////////////////////////////////////////////////////////////
              Align(
                  alignment: Alignment.center,
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
                        child: Text(
                          "Motor", style: TextStyle(color: Colors.white,),)
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
                      gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: HexColor("#000000"), blurRadius: 1)
                      ],
                    ),
                    //color: Colors.grey,
                    child: InkWell(
                        onTap: () {
                          //Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StarlineSpMotor(title: widget.title,session:"open",id: widget.id,date: date.toString(),))
                          );
                        },
                        child: Column(
                          children: [
                            SizedBox(height: 5,),
                            Image.asset("assets/sp_motor.png", height: 40,),
                            SizedBox(height: 5,),
                            Text("SP Motor", textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor("#ffffff")),)
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
                      gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: HexColor("#000000"), blurRadius: 1)
                      ],
                    ),
                    //color: Colors.grey,
                    child: InkWell(
                        onTap: () {
                          //Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StarlineDpMotor(title: widget.title,session:"open",id: widget.id,date: date.toString(),))
                          );
                        },
                        child: Column(
                          children: [
                            SizedBox(height: 5,),
                            Image.asset("assets/dp_motor.png", height: 40,),
                            SizedBox(height: 5,),
                            Text("DP Motor", textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor("#ffffff")),)
                          ],
                        )
                    ),
                  ),
                  //////////////////////Dp Motor
                ],
              ),
              //////////////////////////////////////////////////////////////////////////////////
            ],
          ),
        ),
      ),
    );
  }
}