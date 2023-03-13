import 'dart:convert';

import 'package:wingame/common/api_service.dart';
import 'package:wingame/common/encrypt_service.dart';
import 'package:wingame/globalvar.dart' as globals;
import 'package:wingame/loader.dart';
import 'package:wingame/pages/game_types.dart';
import 'package:wingame/pages/login_page.dart';
import 'package:wingame/widgets/GradientText.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:hexcolor/hexcolor.dart';
class MainMarkets extends StatefulWidget {
  const MainMarkets({Key? key}) : super(key: key);

  @override
  State<MainMarkets> createState() => _MainMarketsState();
}

class _MainMarketsState extends State<MainMarkets> {
  List<dynamic> landingdata = [];
  var maingames ;
  bool isApiCallProcess = false;
  int dataindex = 0;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<dynamic> getlandingdata() async {
    setState(() {
      isApiCallProcess = true;
      globals.tabbarphysics = 1;
    });
    Map<String, dynamic> map = {
      'user_id': globals.user_id,
      'encryption_key': globals.token,
    };
    APIService apiService = new APIService();
    await apiService.apicall({"str": encryp(json.encode(map))}, "get_game_result").then((value) {
      Map<String, dynamic> responseJson = json.decode(value);

      var successcode = int.parse(responseJson["success"].toString());
      if (successcode != 0 && successcode != 3) {

        final game_providers = List<dynamic>.from(
          responseJson["game_results"].map<dynamic>(
                (dynamic item) => item,
          ),
        );

        setState(() {
          isApiCallProcess = false;
          landingdata = game_providers;
          maingames = game_providers.asMap();
          globals.balance = responseJson["balance"];
          globals.marketnames = game_providers;
          globals.tabbarphysics = 0;
        });


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
          content: Text(responseJson["message"],style: TextStyle(color: Colors.black),),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  @override
  void initState() {
    getlandingdata();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    landingdata = [];
    isApiCallProcess = false;
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
  }
  Future<bool> showExitPopup() async {
    return await showDialog( //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'),
        content: Text('Do you want to exit an App?'),
        actions:[
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            //return false when click on "NO"
            child:Text('No'),
          ),

          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            //return true when click on "Yes"
            child:Text('Yes'),
          ),

        ],
      ),
    )??false; //if showDialouge had returned null, then return false
  }
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      //opacity: 0.3,
    );

  }
  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    setState(() {
      landingdata = [];
    });
    getlandingdata();
  }
   @override
  Widget _uiSetup(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: refreshList,
          key: refreshKey,
          child: Container(
            color: HexColor(globals.color_background),
            child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(5),
           crossAxisSpacing: 0,
           mainAxisSpacing: 0,
           crossAxisCount: 2,
           children: List.generate(landingdata.length, (index) {
             return InkWell(
               onTap: (){
                 if(landingdata[index]["status"] != "closed")
                 {
                   //Navigator.pop(context);
                   Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => GameTypes(id : int.parse(landingdata[index]["prov_id"]),title : landingdata[index]["prov_name"],status: landingdata[index]["status"],)),
                   );
                 }
                 else
                 {
                   var snackBar = SnackBar(
                     content: Text("Market Closed",style: TextStyle(color: Colors.black),),
                     backgroundColor: HexColor("#FEDB87"),
                   );
                   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                 }
               },
               child: Container(
                 //padding: EdgeInsets.fromLTRB(5,5,5,5),
                 margin: EdgeInsets.all(4),
                 decoration: BoxDecoration(
                      //HexColor(globals.color_green)
                     //border: Border.all(color: landingdata[index]["status"]!="closed" ? HexColor("#FEDB87") : Colors.grey),
                     /*border: const GradientBoxBorder(
                       gradient: LinearGradient(colors: [Color(0xffFEDB87),Color(0xffBD7923),Color(0xffFEDB87)],),
                       width: 1,
                     ),*/
                    border: Border.all(color: HexColor(globals.color_pink)),
                     borderRadius: BorderRadius.circular(8),
                     color: HexColor(globals.color_background)
                 ),
                 child: Column(
                   children: [
                     SizedBox(height: 5,),
                     landingdata[index]["status"]!="closed" ? GradientText(landingdata[index]["prov_name"],style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),) : Text(landingdata[index]["prov_name"],style: TextStyle(color:Colors.grey,fontWeight: FontWeight.w900, fontSize: 18),),
                     SizedBox(height: 15,),
                     landingdata[index]["status"]!="closed" ? GradientText(landingdata[index]["prov_result"],style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),) : Text(landingdata[index]["prov_result"],style: TextStyle(color:Colors.grey,fontWeight: FontWeight.w900, fontSize: 20),),
                     SizedBox(height: 10,),
                     RichText(
                         text: TextSpan(
                             style: TextStyle(color: Colors.black),
                             children: [
                               TextSpan(text: "Bid Open: ", style: TextStyle(color: landingdata[index]["status"]!="closed" ? Colors.white : Colors.grey, fontWeight: FontWeight.bold,fontSize: 10)),
                               TextSpan(text: landingdata[index]["open_time"], style: TextStyle(fontWeight: FontWeight.bold,color: landingdata[index]["status"]!="closed" ? Colors.white : Colors.grey,fontSize: 10 )),
                             ]
                         )),
                     SizedBox(height: 5,),
                     RichText(
                         text: TextSpan(
                             style: TextStyle(color: Colors.black),
                             children: [
                               TextSpan(text: "Bid Close: ", style: TextStyle(color: landingdata[index]["status"]!="closed" ? Colors.white : Colors.grey, fontWeight: FontWeight.bold,fontSize: 10)),
                               TextSpan(text: landingdata[index]["close_time"], style: TextStyle(fontWeight: FontWeight.bold,color: landingdata[index]["status"]!="closed" ? Colors.white : Colors.grey,fontSize: 10))
                             ]
                         )),
                     SizedBox(height: 12,),
                     GradientText(
                       landingdata[index]["status"] == "both" ?
                       "Betting Running For Both" :
                       landingdata[index]["status"] == "closed" ? "Betting Closed" : "Betting Running For Close"

                       ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                     SizedBox(height: 5,),
                     landingdata[index]["status"]!="closed" ? Container(
                       width: double.infinity,
                       height: 31,
                       alignment: Alignment.center,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.only(bottomLeft: Radius.circular(7),bottomRight: Radius.circular(7)),
                         gradient: LinearGradient(
                             begin: Alignment.topCenter,
                             end: Alignment.bottomCenter,
                             colors: <Color>[
                               HexColor(globals.color_blue),
                               HexColor(globals.color_pink),]),
                       ),
                       child: Text("Play Game",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                     ) : Container(),
                   ],
                 ),
               ),
             );
           }),
          ),
        ),
        )
      ),
    );

  }

}
