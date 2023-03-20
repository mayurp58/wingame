import 'dart:convert';

import 'package:wingame/globalvar.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:hexcolor/hexcolor.dart';

import '../common/api_service.dart';
import '../common/encrypt_service.dart';
import '../common/theme_helper.dart';
import '../loader.dart';
import '../pages/landing_page.dart';
import '../pages/login_page.dart';
class SubmitBid extends StatefulWidget {
  final String? title;
  final String? session;
  final int id;
  final String? date;
  final List<Map<String, dynamic>> itemDetail;
  final String image;
  final String game_name;
  final String total;
  const SubmitBid({Key? key,this.title, this.session, required this.id,required this.date,required this.itemDetail,required this.image,required this.game_name,required this.total}) : super(key: key);

  @override
  State<SubmitBid> createState() => _SubmitBidState();
}

class _SubmitBidState extends State<SubmitBid> {
  bool isApiCallProcess = false;
  int total = 0;
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
          widget.title.toString()+ "-" + widget.session.toString().toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ),
      bottomNavigationBar: submitButtonWidget(context,total),
      body:ListView.builder(
          itemCount: widget.itemDetail.length,
          itemBuilder: (context, index) {

            return Card(
              color: Colors.black,
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
                    children: [
                      SizedBox(
                        width: 80,
                        height: 60,
                        child: Container(
                          decoration: BoxDecoration(

                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  HexColor(globals.color_pink),
                                  HexColor(globals.color_blue),]),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                                topLeft: Radius.circular(7),
                                bottomLeft: Radius.circular(7)
                            ),

                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 5,),
                              Image.asset("assets/"+widget.image.toString(),height: 30,),
                              SizedBox(height: 5,),
                              Text(widget.game_name.toString(),textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,color: Colors.white),)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        //width: 80,
                        child: Container(
                          color: Colors.black,
                          padding: EdgeInsets.fromLTRB(140, 10, 10, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text("Points : " + widget.itemDetail[index]["game_bidding_points"],textAlign: TextAlign.left,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                              ),

                              SizedBox(height: 6,),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Text("Digit    : " + widget.itemDetail[index]["game_brackets"],textAlign: TextAlign.left,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
      ),
    );
  }

  submitButtonWidget(BuildContext context,int total) {
    return Container(
      height: 80,
      padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
      decoration: BoxDecoration(
        color: Colors.black,
        //borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
      ),
      child: Column(
        children: [
          Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Points",style: TextStyle(color: HexColor(globals.color_pink),fontWeight: FontWeight.bold),),
                          RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(child: Icon(Icons.currency_rupee,color: HexColor(globals.color_pink),size: 14,)),
                                TextSpan(text: widget.total.toString(), style: TextStyle(fontWeight: FontWeight.bold,color: HexColor(globals.color_pink)),),
                              ],
                            ),),
                          //Text(widget.total.toString(),style: TextStyle(color: HexColor(globals.color_blue),fontWeight: FontWeight.bold),),
                        ],
                      ),
                  ),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          decoration: ThemeHelper().buttonBoxDecoration(context),
                          child :
                          ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text('Submit'.toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                              ),
                              onPressed: (){
                                Map<String, dynamic> map = {
                                  'user_id': globals.user_id,
                                  'encryption_key': globals.token,
                                  'device_id': globals.device_id,
                                  'itemDetail': widget.itemDetail
                                };
                                if (widget.itemDetail.length > 0 && int.parse(globals.balance.toString()) >= int.parse(widget.total.toString())) {
                                  setState(() {
                                    isApiCallProcess = true;
                                  });

                                  APIService apiService = new APIService();
                                  apiService.apicall({"str": encryp(json.encode(map))}, "add_bid").then((value) {
                                    Map<String, dynamic> responseJson =  json.decode(value);
                                    var successcode = int.parse(responseJson["success"].toString());
                                    if (successcode!=0  && successcode!=3)
                                    {
                                      setState(() {
                                        isApiCallProcess = false;
                                        globals.balance = responseJson["current_balance"];
                                      });
                                      globals.token = responseJson["encryption_key"];
                                      var snackBar = SnackBar(content: Text(responseJson["message"],style: TextStyle(color: Colors.black),),backgroundColor:HexColor(globals.color_blue));
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => LandingPage()),
                                      );
                                    }
                                    else if (successcode == 3) {
                                      setState(() {
                                        isApiCallProcess = false;
                                      });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => LoginPage()),
                                      );
                                    }
                                    else
                                    {
                                      setState(() {
                                        isApiCallProcess = false;
                                      });
                                      var snackBar = SnackBar(content: Text(responseJson["message"]),backgroundColor:HexColor(globals.color_blue));
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    }
                                  });
                                }
                                else
                                  {
                                    var snackBar = SnackBar(content: Text("Insufficient Balance"),backgroundColor:HexColor(globals.color_blue));
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  }
                              }
                          )
                      )
                    ],
                  ),

                ],
              )
          ),
        ],
      ),
    );
  }
}
