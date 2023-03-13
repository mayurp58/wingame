import 'package:wingame/globalvar.dart' as globals;
import 'package:wingame/widgets/GradientText.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../pages/game_types.dart';
import '../pages/landing_page.dart';
class GameplayHeader extends StatefulWidget {
  final String? id;
  final String? title;
  final String? session;
  final String? type;
  final String? date;
  const GameplayHeader({Key? key,required this.id,required this.title, required this.session, required this.type,required this.date}) : super(key: key);

  @override
  State<GameplayHeader> createState() => _GameplayHeaderState();
}

class _GameplayHeaderState extends State<GameplayHeader> {

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
            GameTypes(id: int.parse(widget.id.toString()),
              title: widget.title.toString(),
              status: "both",)),
      );
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 110,
      width: double.infinity,
      child: Card(
        color: Colors.black,
        elevation: 20, //shadow elevation for card
        margin: EdgeInsets.all(8),
        shadowColor: HexColor("#FEDB87"),
        child: Column(
          children: [

            SizedBox(height: 5,),
            GradientText(widget.title.toString(),style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),),
            SizedBox(height: 10,),
            GradientText(widget.type.toString(),style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                  child: RichText(text: TextSpan(
                    children: [
                      WidgetSpan(child: Icon(Icons.calendar_month,color: HexColor("#FEDB87"),size: 15,)),
                      TextSpan(text: widget.date.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: HexColor("#FEDB87")),),
                    ],
                  ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                  child: (widget.session.toString()=="") ? Text(widget.type.toString()) : RichText(text: TextSpan(
                    children: [
                      WidgetSpan(child: Icon(Icons.watch_later_outlined,color: HexColor("#FEDB87"),size: 15,)),
                      TextSpan(text: widget.session.toString().toUpperCase(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color:HexColor("#FEDB87")),),
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
