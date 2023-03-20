import 'dart:convert';

import 'package:wingame/common/api_service.dart';
import 'package:wingame/gameplay/submit_bid.dart';
import 'package:wingame/globalvar.dart' as globals;
import 'package:wingame/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

import '../common/encrypt_service.dart';
import '../common/theme_helper.dart';
import '../pages/login_page.dart';
import '../widgets/appbar.dart';
import 'gameplay_header.dart';
class SpMotor extends StatefulWidget {
  final String? title;
  final String? session;
  final int id;
  final String? date;
  const SpMotor({Key? key, this.title, this.session, required this.id,required this.date}) : super(key: key);

  @override
  State<SpMotor> createState() => _SpMotorState();
}

class _SpMotorState extends State<SpMotor> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> itemDetail = [];
  bool isApiCallProcess = false;
  int total = 0;
  final left_digit = TextEditingController();
  final middle_digit = TextEditingController();
  final right_digit = TextEditingController();
  final amount = TextEditingController();
  bool sp = false;
  bool dp = false;
  bool tp = false;
  String fulldgt = "";
  Map<String, String> map1 = {};
  List<dynamic> mm = [];

  void takeNumber(String inputamount, String bracket,String type_id) {
    try
    {
      Map<String, dynamic> json = {"game_provider_id": widget.id,"game_type_id" : type_id ,"game_brackets":bracket,"game_bidding_points":inputamount,"game_date":widget.date,"game_session":widget.session};
      int item = int.parse(bracket);
      int amount = int.parse(inputamount);
      itemDetail.add(json);
      setState(() {
        total = total + amount;
      });
    } on FormatException {}
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child :  Appbar()),
      bottomNavigationBar: submitButtonWidget(context),
      body:SingleChildScrollView(
        child: Column(
          children: [

            GameplayHeader(id:widget.id.toString(),title: widget.title,type: "SP Motor",session: widget.session,date: widget.date,),
            //////////////////////////////Heade Ends Here////////////////////////////
            Container(
              //height: ,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.black
              ),
              child: Card(
                color: HexColor(globals.color_background),
                elevation: 10, //shadow elevation for card
                margin: EdgeInsets.all(2),
                shadowColor:  HexColor(globals.color_blue),
                child: Column(
                  children: [

                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            SizedBox(height: 40,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                    child: TextFormField(
                                      decoration: ThemeHelper().customInputDecoration('Enter Upto 9 Digits',""),
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      controller: left_digit,
                                      maxLength: 9,
                                      style: ThemeHelper().textStyle(),
                                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                      validator: (input) => (input!.isEmpty)
                                          ?  "Please Enter Atlease 4 Digits"
                                          : (input.isNotEmpty && input.length < 4) ? "Enter Minimum 4 Digits" : null,
                                    ),
                                  ),
                                ),


                              ],),
                            SizedBox(height: 40,),
                            Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                    child: TextFormField(
                                      decoration: ThemeHelper().customInputDecoration('Point',""),
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      controller: amount,
                                      maxLength: 6,
                                      style: ThemeHelper().textStyle(),
                                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                      validator: (input) => (input!.isEmpty || int.parse(input) < 10)
                                          ? "Amount Greater Than 10"
                                          : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 310,),
                          ],
                        ),





                      ),

                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  submitButtonWidget(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
      decoration: BoxDecoration(
        color: Colors.black,
        //borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
      ),
      child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
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

                                if (validateAndSave())
                                {
                                  setState(() {
                                    isApiCallProcess = true;
                                  });
                                  Map<String, dynamic> map = {
                                    'user_id': globals.user_id,
                                    'encryption_key': globals.token,
                                    'digit': left_digit.text,
                                  };
                                  APIService apiService = new APIService();
                                  apiService.apicall({"str": encryp(json.encode(map))}, "get_spmotor").then((value) {
                                    Map<String, dynamic> responseJson =  json.decode(value);
                                    var successcode = int.parse(responseJson["success"].toString());
                                    if (successcode!=0  && successcode!=3)
                                    {
                                      setState(() {
                                        isApiCallProcess = false;
                                        mm = responseJson["motor"];
                                      });
                                      //List<dynamic> mm = responseJson["motor"];

                                      mm.forEach((element) {
                                        takeNumber(amount.text, element,"13");
                                      });

                                      if(itemDetail.length > 0) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SubmitBid(title: widget.title,
                                                      session: widget.session,
                                                      id: widget.id,
                                                      date: widget.date,
                                                      itemDetail: itemDetail,
                                                      image: "sp_motor.png",
                                                      game_name: "Sp Motor",
                                                      total: total.toString(),))
                                        ).then((_) => resetvariables());
                                      }
                                      if(successcode==1 && mm.length == 0)
                                      {
                                        var snackBar = SnackBar(content: Text("Can Not Populate Motor",style: TextStyle(color: Colors.black),),backgroundColor:HexColor("#FEDB87"));
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      }
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
                                      var snackBar = SnackBar(content: Text("Something Went Wrong",style: TextStyle(color: Colors.black),),backgroundColor:HexColor("#FEDB87"));
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    }
                                  });
                                }
                                else
                                {
                                  var snackBar = SnackBar(content: Text("Fields Are Required",style: TextStyle(color: Colors.black),),backgroundColor:HexColor("#FEDB87"));
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
    );
  }
  resetvariables() {
    itemDetail = [];
    total = 0;
  }

}
