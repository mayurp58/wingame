import 'dart:convert';

import 'package:wingame/common/api_service.dart';
import 'package:wingame/common/encrypt_service.dart';
import 'package:wingame/globalvar.dart' as globals;
import 'package:wingame/loader.dart';
import 'package:wingame/pages/login_page.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:hexcolor/hexcolor.dart';
class FundRequests extends StatefulWidget {
  const FundRequests({Key? key}) : super(key: key);

  @override
  State<FundRequests> createState() => _FundRequestsState();
}

class _FundRequestsState extends State<FundRequests> {
  List<dynamic> fundrequests =[];
  bool isApiCallProcess = false;

  void get_fund_requests() async {
    setState(() {
      isApiCallProcess = true;
    });
    Map<String, dynamic> map = {
      'user_id': globals.user_id,
      'encryption_key': globals.token,
    };
    APIService apiService = new APIService();
    apiService
        .apicall({"str": encryp(json.encode(map))}, "fund_request_history").then((value) {
      Map<String, dynamic> responseJson =  json.decode(value);
      final fund_requests = List<dynamic>.from(
        responseJson["fundrequests"].map<dynamic>(
              (dynamic item) => item,
        ),
      );
      var successcode = int.parse(responseJson["success"].toString());
      if (successcode != 0 && successcode != 3) {
        setState(() {
          isApiCallProcess = false;
          fundrequests = fund_requests;
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
    get_fund_requests();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    //print("BACK BUTTON!"); // Do some stuff.
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );

  }

  @override
  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(globals.color_background),
        body: ListView.builder(

          itemCount: fundrequests.length,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: HexColor(globals.color_blue),
                          gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [Color(0xffff66c4),Color(0xff514ed8)],),

                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(0),
                              bottomRight: Radius.circular(0),
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8)
                          ),

                        ),
                        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        child : Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(text: TextSpan(
                              children: [
                                WidgetSpan(child: Icon(Icons.currency_rupee,color: Colors.white,size: 20,)),
                                TextSpan(text: fundrequests[index]["req_amount"], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),),
                              ],
                            ),),
                          ),
                          SizedBox(height: 4,),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text("Debit",style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),),
                          ),
                        ],
                      ),),

                      Container(

                        child : Column(
                          children: [
                            Column(
                              children: [
                                RichText(text: TextSpan(
                                  children: [
                                    WidgetSpan(child: Icon(Icons.calendar_month,color: Colors.white,size: 14,)),
                                    TextSpan(text: fundrequests[index]["req_date"], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.white),),
                                  ],
                                ),),
                                SizedBox(height: 10,),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: RichText(text: TextSpan(
                                    children: [
                                      WidgetSpan(child: Icon(Icons.settings,color: Colors.white,size: 14,)),
                                      TextSpan(text: fundrequests[index]["req_status"], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.white),),
                                    ],
                                  ),),
                                ),


                                
                              ],
                            ),
                          ],
                        ),),

                      ],
                  ),
                ),
              ),
            );
          },
        ),
    );
  }
}
