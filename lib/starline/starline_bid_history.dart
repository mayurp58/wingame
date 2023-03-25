import 'dart:convert';

import 'package:wingame/common/api_service.dart';
import 'package:wingame/common/encrypt_service.dart';
import 'package:wingame/globalvar.dart' as globals;
import 'package:wingame/loader.dart';
import 'package:wingame/pages/login_page.dart';
import 'package:wingame/widgets/GradientText.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:hexcolor/hexcolor.dart';
class StarlineBidHistory extends StatefulWidget {
  const StarlineBidHistory({Key? key}) : super(key: key);

  @override
  State<StarlineBidHistory> createState() => _StarlineBidHistoryState();
}

class _StarlineBidHistoryState extends State<StarlineBidHistory> {
  bool isApiCallProcess = false;
  List<dynamic> biddetails =[];

  void get_bid_details() async {
    setState(() {
      isApiCallProcess = true;
    });
    Map<String, dynamic> map = {
      'user_id': globals.user_id,
      'encryption_key': globals.token,
    };
    APIService apiService = new APIService();
    apiService
        .apicall({"str": encryp(json.encode(map))}, "starline_bid_history").then((value) {
      Map<String, dynamic> responseJson =  json.decode(value);
      var successcode = int.parse(responseJson["success"].toString());
      if (successcode != 0 && successcode != 3) {
        //print(responseJson["bidhistory"]);
        final all_transactions = List<dynamic>.from(
          responseJson["bidhistory"].map<dynamic>(
                (dynamic item) => item,
          ),
        );
        setState(() {
          isApiCallProcess = false;
          biddetails = all_transactions;
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
          content: Text(responseJson["message"]),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    get_bid_details();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    //print("BACK BUTTON!"); // Do some stuff.
    globals.tabval = 1;
    Navigator.pop(context);
    return true;
  }
  @override
  Widget build(BuildContext context) {
    if(biddetails.isEmpty) {
      return ProgressHUD(
        child: _uiSetup_empty(context),
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
      );
    }
    else
    {
      return ProgressHUD(
        child: _uiSetup(context),
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
      );
    }
  }

  @override
  Widget _uiSetup_empty(BuildContext context) {
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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          "Bid History",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Bidding History Not Available",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300,color: Colors.white),)
              ],
            ),

          ],
        ),
      ),
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
        backgroundColor: HexColor(globals.color_blue),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          "Bid History",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(

        itemCount: biddetails.length,
        itemBuilder: (context, index) {
          return Card(
            color: HexColor(globals.color_background),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                  decoration: BoxDecoration(
                    border: const GradientBoxBorder(
                      gradient: LinearGradient(colors: [Color(0xffff66c4),Color(0xff514ed8)],),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  //padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  //margin: EdgeInsets.fromLTRB(20, 70, 20, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children:
                        [
                          RichText(text: TextSpan(
                            children: [
                              WidgetSpan(child: Icon(Icons.numbers,color: Colors.grey,size: 14,)),
                              TextSpan(text: biddetails[index]["bid_id"], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.grey),),
                            ],
                          ),),

                          RichText(text: TextSpan(
                            children: [
                              WidgetSpan(child: Icon(Icons.calendar_month,color: Colors.grey,size: 14,)),
                              TextSpan(text: biddetails[index]["game_date"], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.grey),),
                            ],
                          ),)


                        ],
                      ),
                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          GradientText(biddetails[index]["prov_name"] + " - " + biddetails[index]["game_brackets"],
                            style: TextStyle(fontWeight: FontWeight.w600,color: HexColor(globals.color_blue),fontSize: 16),
                          ),

                        ],
                      ),
                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(children: [
                            RichText(text: TextSpan(
                              children: [
                                WidgetSpan(child: Icon(Icons.currency_rupee,color: biddetails[index]["win_status"]=="lose" ? Colors.red : ((biddetails[index]["win_status"]=="win") ? Colors.green : Colors.orange),size: 14,)),
                                TextSpan(text: biddetails[index]["game_bidding_points"], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: biddetails[index]["win_status"]=="lose" ? Colors.red : ((biddetails[index]["win_status"]=="win") ? Colors.green : Colors.orange)),),
                              ],
                            ),),
                          ],),
                          Column(children: [
                            RichText(text: TextSpan(
                                children: [
                                  WidgetSpan(child: Icon(Icons.wallet_giftcard_outlined,color: biddetails[index]["win_status"]=="lose" ? Colors.red : ((biddetails[index]["win_status"]=="win") ? Colors.green : Colors.orange),size: 14,)),
                                  TextSpan(text: biddetails[index]["win_status"], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: biddetails[index]["win_status"]=="lose" ? Colors.red : ((biddetails[index]["win_status"]=="win") ? Colors.green : Colors.orange)),),
                                  WidgetSpan(child: Icon(Icons.wallet_giftcard_outlined,color: biddetails[index]["win_status"]=="lose" ? Colors.red : ((biddetails[index]["win_status"]=="win") ? Colors.green : Colors.orange),size: 14,)),
                                ]
                            ))
                          ],),
                          Column(children: [
                            RichText(text: TextSpan(
                              children: [
                                WidgetSpan(child: Icon(Icons.currency_rupee,color: biddetails[index]["win_status"]=="lose" ? Colors.red : ((biddetails[index]["win_status"]=="win") ? Colors.green : Colors.orange),size: 14,)),
                                TextSpan(text: biddetails[index]["game_winning_points"], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: biddetails[index]["win_status"]=="lose" ? Colors.red : ((biddetails[index]["win_status"]=="win") ? Colors.green : Colors.orange)),),
                              ],
                            ),),
                          ],),
                        ],
                      )
                    ],
                  )
              ),
            ),
          );
        },
      ),
    );
  }
}
