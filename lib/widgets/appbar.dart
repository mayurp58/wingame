import 'package:wingame/globalvar.dart' as globals;
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../pages/notification.dart';
import 'navigationbar.dart';
class Appbar extends StatefulWidget {
  final String? title;
  Appbar({Key? key,this.title}) : super(key: key);

  @override
  State<Appbar> createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {

  var appBarHeight = kToolbarHeight;  //this value comes from constants.dart and equals to 56.0
  String titleforbar = "";
  @override
  Widget build(BuildContext context) {
    if (widget.title.toString().contains("null"))
    {
      titleforbar = "";
    }
    else
      {
        titleforbar = widget.title.toString();
      }
    return Scaffold(
      appBar :  AppBar(
        backgroundColor: HexColor(globals.color_pink),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              color: HexColor(globals.color_background),
              boxShadow: [new BoxShadow(
                color: HexColor(globals.color_blue),
                blurRadius: 20.0,
              ),]
            /*gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    HexColor(globals.color_green),
                    HexColor(globals.color_blue),
                    ]),*/
          ),
        ),
        actions: <Widget>[
          Container(
            color: HexColor(globals.color_background),
            child: Row(
              children: [
                /*InkWell(
                    child: Icon(Icons.chat_bubble),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Chat()),
                      );
                    },
                  ),
                  SizedBox(width: 20,),*/
                InkWell(
                  child: Icon(Icons.notifications),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Notifications()),
                    );
                  },
                ),
                SizedBox(width: 20,),
                InkWell(
                    child: Row(
                      children: [
                        Icon(Icons.wallet),
                        SizedBox(width: 4,),
                        Text(globals.balance.toString())
                      ],
                    )
                ),

                SizedBox(width: 10,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

