import 'dart:convert';

import 'package:wingame/common/api_service.dart';
import 'package:wingame/common/encrypt_service.dart';
import 'package:wingame/globalvar.dart' as globals;
import 'package:wingame/pages/login_page.dart';
import 'package:wingame/pages/superjodi_game_types.dart';
import 'package:wingame/pages/webview.dart';
import 'package:wingame/superjodi/superjodi_bid_history.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:hexcolor/hexcolor.dart';
import '../common/theme_helper.dart';
import '../loader.dart';
import '../superjodi/superjodi_terms_conditions.dart';
import '../widgets/GradientText.dart';
import 'landing_page.dart';
class Superjodi extends StatefulWidget {
  const Superjodi({Key? key}) : super(key: key);

  @override
  State<Superjodi> createState() => _SuperjodiState();
}

class _SuperjodiState extends State<Superjodi> {

  List<dynamic> landingdata_superjodi = [];
  bool isApiCallProcess = false;
  int dataindex = 0;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  final Uri toLaunch = Uri.parse('https://livegames.pro/kalyan-starline-panel-chart');

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    setState(() {
      landingdata_superjodi = [];
    });
    getlandingdata();
  }

  Future<dynamic> getlandingdata() async {
    Map<String, dynamic> map = {
      'user_id': globals.user_id,
      'encryption_key': globals.token,
    };
    APIService apiService = new APIService();
    setState(() {
      isApiCallProcess = true;
      globals.tabbarphysics = 1;
    });
    await apiService
        .apicall({"str": encryp(json.encode(map))}, "get_ab_game_result").then((
        value) {
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
          landingdata_superjodi = game_providers;
          globals.balance = responseJson["balance"].toString();
          globals.tabbarphysics = 0;
        });
        //print(responseJson);

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
    getlandingdata();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
  @override
  void dispose() {
    super.dispose();
    landingdata_superjodi = [];
    isApiCallProcess = false;
    BackButtonInterceptor.remove(myInterceptor);
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    //print("BACK BUTTON!"); // Do some stuff.
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LandingPage())
    );
    return true;
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

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
  }

  @override
  Widget _uiSetup(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    var lstviewkey =GlobalKey();
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        backgroundColor: HexColor(globals.color_background),
        body: Column(
          children : [
            Container(
              margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
              decoration: BoxDecoration(
                  color: Colors.black,

                  borderRadius: BorderRadius.circular(7)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      style: ThemeHelper().filled_square_button(),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                        child: Text('Bid\nHistory',textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.white),),
                      ),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Sup_bid_history()),
                        );
                      },
                    ),
                  ),

                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      style: ThemeHelper().filled_square_button(),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                        child: Text('Result\nHistory',textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.white),),
                      ),
                      //onPressed: _launchUrl,
                      onPressed: (){
                        /*setState(() {
                          _launched = _launchInBrowser(toLaunch);
                        });*/
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WebpageLoader(url: "https://livegames.pro/livegames-superjodi-panel-chart",tabval: 2,)),
                        );
                      },
                    ),
                  ),

                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      style: ThemeHelper().filled_square_button(),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                        child: Text('Terms &\nConditions', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.white),),
                      ),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Superjodi_terms()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            ConstrainedBox(

              constraints: BoxConstraints(minHeight: 150,maxHeight: deviceHeight-210),
              child: RefreshIndicator(
                onRefresh: refreshList,
                key: refreshKey,
                color: Colors.black,
                child: Container(

                  color: Colors.black,
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(5),
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                    childAspectRatio: (1 / 0.85),
                    crossAxisCount: 2,
                    children: List.generate(landingdata_superjodi.length, (index) {
                      return InkWell(
                        onTap: (){
                          if(landingdata_superjodi[index]["status"] != "closed")
                          {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Sup_game_types(id : int.parse(landingdata_superjodi[index]["prov_id"]),title : landingdata_superjodi[index]["prov_name"],status: landingdata_superjodi[index]["status"],)),
                            );
                          }
                          else
                          {
                            var snackBar = SnackBar(
                              content: Text("Market Closed"),
                              backgroundColor: HexColor(globals.color_blue),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            //border: Border.all(color: landingdata[index]["status"]!="closed" ? HexColor(globals.color_blue) : Colors.grey),
                            border: const GradientBoxBorder(
                              gradient: LinearGradient(colors: [Color(0xffFEDB87),Color(0xffBD7923),Color(0xffFEDB87)],),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black,
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 5,),
                              landingdata_superjodi[index]["status"]!="closed" ? GradientText(landingdata_superjodi[index]["prov_name"],style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),) : Text(landingdata_superjodi[index]["prov_name"],style: TextStyle(color:Colors.grey,fontWeight: FontWeight.w900, fontSize: 18),),
                              SizedBox(height: 15,),
                              landingdata_superjodi[index]["status"]!="closed" ? GradientText(landingdata_superjodi[index]["prov_result"],style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),) : Text(landingdata_superjodi[index]["prov_result"],style: TextStyle(color:Colors.grey,fontWeight: FontWeight.w900, fontSize: 20),),
                              SizedBox(height: 10,),
                              RichText(
                                  text: TextSpan(
                                      style: TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(text: "Bid Open: ", style: TextStyle(color: landingdata_superjodi[index]["status"]!="closed" ? Colors.white : Colors.grey, fontWeight: FontWeight.bold,fontSize: 10)),
                                        TextSpan(text: landingdata_superjodi[index]["open_time"], style: TextStyle(fontWeight: FontWeight.bold,color: landingdata_superjodi[index]["status"]!="closed" ? Colors.white : Colors.grey,fontSize: 10 )),
                                      ]
                                  )),
                              SizedBox(height: 5,),
                              RichText(
                                  text: TextSpan(
                                      style: TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(text: "Bid Close: ", style: TextStyle(color: landingdata_superjodi[index]["status"]!="closed" ? Colors.white : Colors.grey, fontWeight: FontWeight.bold,fontSize: 10)),
                                        TextSpan(text: landingdata_superjodi[index]["close_time"], style: TextStyle(fontWeight: FontWeight.bold,color: landingdata_superjodi[index]["status"]!="closed" ? Colors.white : Colors.grey,fontSize: 10))
                                      ]
                                  )),
                              SizedBox(height: 4,),
                              landingdata_superjodi[index]["status"]!="closed" ? Container(
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
                                        HexColor("#BD7923"),
                                        HexColor(globals.color_blue),]),
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

              ),
            ),
          ],
        ),
      ),
    );

  }


  refreshtabs(){

    getlandingdata();
    ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      //opacity: 0.3,
    );
  }
}