import 'dart:convert';

import 'package:hexcolor/hexcolor.dart';
import 'package:wingame/common/api_service.dart';
import 'package:wingame/common/encrypt_service.dart';
import 'package:wingame/globalvar.dart' as globals;
import 'package:wingame/loader.dart';
import 'package:wingame/pages/login_page.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
class TransactionHistory extends StatefulWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  List<dynamic> transactions =[];
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
        .apicall({"str": encryp(json.encode(map))}, "gettransactionhistory").then((value) {
      Map<String, dynamic> responseJson =  json.decode(value);
      final all_transactions = List<dynamic>.from(
        responseJson["transaction_history"].map<dynamic>(
              (dynamic item) => item,
        ),
      );
      var successcode = int.parse(responseJson["success"].toString());
      if (successcode != 0 && successcode != 3) {
        setState(() {
          isApiCallProcess = false;
          transactions = all_transactions;
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
    double c_width = MediaQuery.of(context).size.width*0.6;
    return Scaffold(
      backgroundColor: HexColor(globals.color_background),
      body: ListView.builder(

        itemCount: transactions.length,
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
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      decoration: BoxDecoration(
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
                            child: RichText(
                              text: TextSpan(
                              children: [
                                WidgetSpan(child: Icon(Icons.currency_rupee,color: Colors.white,size: 20,)),
                                TextSpan(text: transactions[index]["transaction_amount"], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),),
                              ],
                            ),),
                          ),
                          SizedBox(height: 10,),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(transactions[index]["transaction_status"],style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),),
                          ),
                        ],
                      ),),
                    //SizedBox(width: 20,),
                    Center(
                      child: Container(
                        width: c_width,
                        //height: 100.0,
                        alignment: Alignment.centerLeft,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.calendar_month,color: Colors.white,size: 14,),
                                  Text(transactions[index]["transaction_date"]+ " | " + transactions[index]["transaction_time"],textAlign:TextAlign.left, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.white),),
                                ],
                              ),
                              /*RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                children: [
                                  WidgetSpan(child: Icon(Icons.calendar_month,color: Colors.black,size: 14,)),
                                  TextSpan(text: transactions[index]["transaction_date"] + " | " + transactions[index]["transaction_time"], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.black),),
                                ],
                              ),),*/
                              SizedBox(height: 10,),
                              Column(
                                children: [
                                  Text(transactions[index]["description"],textAlign:TextAlign.left, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300,color: Colors.white),),
                                ],
                              ),

                            ],
                          ),
                        ),
                      ),
                    )

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
