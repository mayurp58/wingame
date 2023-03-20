import 'package:wingame/globalvar.dart' as globals;
import 'package:wingame/superjodi/Superjodi_digit_base.dart';
import 'package:wingame/superjodi/superjodi_group_jodi.dart';
import 'package:wingame/superjodi/superjodi_jodi_digit.dart';
import 'package:wingame/superjodi/superjodi_red_bracket.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import 'landing_page.dart';
class Sup_game_types extends StatefulWidget {
  final String? title;
  final String? status;
  final int id;
  const Sup_game_types({Key? key, required this.id, required this.title, required this.status}) : super(key: key);

  @override
  State<Sup_game_types> createState() => _Sup_game_typesState();
}

class _Sup_game_typesState extends State<Sup_game_types> {
  var date = new DateFormat('yyyy-MM-dd').format(DateTime.now());
  @override
  void initState() {
    super.initState();
    setState(() {
      globals.tabval = 2;
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
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  HexColor("#FEDB87"),
                  HexColor("#BD7923"),
                  HexColor("#FEDB87"),]),
          ),
        ),
        backgroundColor: HexColor("#FEDB87"),
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
                        //color: HexColor("#FEDB87"),
                        child: Text(
                          "Jodies", style: TextStyle(color: Colors.white,),)
                    ),
                  )
              ),
              ////////////////////////////////////////////////////////
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
                        BoxShadow(color: HexColor("#FEDB87"), blurRadius: 1)
                      ],
                    ),
                    //color: Colors.grey,
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Sup_jodi_digit(title: widget.title,session:"close",id: widget.id,date: date.toString(),))
                          );
                        },
                        child: Column(
                          children: [
                            SizedBox(height: 5,),
                            Image.asset("jodi_digit.png", height: 40,),
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
                      boxShadow: [BoxShadow(color: HexColor("#FEDB87"),blurRadius: 1)],
                    ),
                    //color: Colors.grey,
                    child: InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Sup_red_bracket(title: widget.title,session:"close",id: widget.id,date: date.toString(),))
                          );
                        },
                        child: Column(
                          children: [
                            SizedBox(height: 5,),
                            Image.asset("red_bracket.png",height: 40,),
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
                      boxShadow: [BoxShadow(color: HexColor("#FEDB87"),blurRadius: 1)],
                    ),
                    //color: Colors.grey,
                    child: InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Sup_digit_base(title: widget.title,session:"close",id: widget.id,date: date.toString(),))
                          );
                        },
                        child: Column(
                          children: [
                            SizedBox(height: 5,),
                            Image.asset("digit_based_jodi.png",height: 40,),
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
                      boxShadow: [BoxShadow(color: HexColor("#FEDB87"),blurRadius: 1)],
                    ),
                    //color: Colors.grey,
                    child: InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Sup_group_jodi(title: widget.title,session:"close",id: widget.id,date: date.toString(),))
                          );
                        },
                        child: Column(
                          children: [
                            SizedBox(height: 5,),
                            Image.asset("group_jodi.png",height: 40,),
                            SizedBox(height: 5,),
                            Text("Group Jodi",textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),)
                          ],
                        )
                    ),
                  ),
                  //////////////////////Group Jodi End
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
