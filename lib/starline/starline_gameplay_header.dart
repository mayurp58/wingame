import 'package:wingame/globalvar.dart' as globals;
import 'package:wingame/pages/starline_game_types.dart';
import 'package:wingame/widgets/GradientText.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../pages/landing_page.dart';
class StarlineGameplayHeader extends StatefulWidget {
  final String? id;
  final String? title;
  final String? session;
  final String? type;
  final String? date;
  const StarlineGameplayHeader({Key? key,required this.id,required this.title, required this.session, required this.type,required this.date}) : super(key: key);

  @override
  State<StarlineGameplayHeader> createState() => _StarlineGameplayHeaderState();
}

class _StarlineGameplayHeaderState extends State<StarlineGameplayHeader> {
  int count = 0;

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    setState(() {
      globals.gametyp = 0;
    });
  }

  @override
  void dispose() {
    BackButtonInterceptor.removeByName(widget.title.toString());
    super.dispose();

  }
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
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
    else
    {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            StarlineGameTypes(id: int.parse(widget.id.toString()),
              title: widget.title.toString(),
              status: "both",)),
      );
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: double.infinity,
      child: Card(
        color:HexColor(globals.color_background) ,
        elevation: 20, //shadow elevation for card
        margin: EdgeInsets.all(8),
        shadowColor: HexColor(globals.color_blue),
        child: Column(
          children: [

            SizedBox(height: 10,),
            GradientText(widget.title.toString(),style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: HexColor(globals.color_blue)),),
            SizedBox(height: 10,),
            GradientText(widget.type.toString(),style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,color: Colors.black),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                  child: RichText(text: TextSpan(
                    children: [
                      WidgetSpan(child: Icon(Icons.calendar_month,color: Colors.white,size: 14,)),
                      TextSpan(text: widget.date.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.white),),
                    ],
                  ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                  child: (widget.session.toString()=="") ? Text(widget.type.toString()) : RichText(text: TextSpan(
                    children: [
                      WidgetSpan(child: Icon(Icons.watch_later_outlined,color: Colors.white,size: 14,)),
                      TextSpan(text: widget.session.toString().toUpperCase(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.white),),
                    ],
                  ),
                  ),
                )

              ],
            ),
          ],
        ),
      ),
    );
  }
}
