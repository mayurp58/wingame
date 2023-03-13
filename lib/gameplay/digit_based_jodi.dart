import 'package:wingame/gameplay/submit_bid.dart';
import 'package:wingame/widgets/GradientText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

import '../common/theme_helper.dart';
import '../widgets/appbar.dart';
import 'gameplay_header.dart';
class DigitBasedJodi extends StatefulWidget {
  final String? title;
  final String? session;
  final int id;
  final String? date;
  const DigitBasedJodi({Key? key, this.title, this.session, required this.id,required this.date}) : super(key: key);

  @override
  State<DigitBasedJodi> createState() => _DigitBasedJodiState();
}

class _DigitBasedJodiState extends State<DigitBasedJodi> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> itemDetail = [];
  bool isApiCallProcess = false;
  int total = 0;
  var primary = {"1", "2", "3", "4", "5"};
  var dependent = {"6", "7", "8", "9", "0"};
  var finalarr = [];
  final left_digit = TextEditingController();
  final right_digit = TextEditingController();
  final amount = TextEditingController();
  String bet_patties = "";

  //23,32,28,82,37,73,78,87,
  //a+d, d+a, a+b, b+a, c+d, d+c, b+c, c+b

  void takeNumber(String inputamount, String bracket) {
    try {
      Map<String, dynamic> json = {"game_provider_id": widget.id,"game_type_id" : "5" ,"game_brackets":bracket,"game_bidding_points":inputamount,"game_date":widget.date,"game_session":"close"};
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
            GameplayHeader(id:widget.id.toString(),title: widget.title,type: "Digit Based Jodi",session: "",date: widget.date,),
            //////////////////////////////Heade Ends Here////////////////////////////
            Container(
              //height: ,
              width: double.infinity,
              child: Card(
                color: Colors.black,
                elevation: 20, //shadow elevation for card
                margin: EdgeInsets.all(8),
                shadowColor: HexColor("#FEDB87"),
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
                                      decoration: ThemeHelper().customInputDecoration('Left Digit',""),
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      controller: left_digit,
                                      //onChanged: (input) => right_digit.text = "",
                                      onChanged: (input){
                                        right_digit.text = "";
                                        setState((){
                                          bet_patties = "";
                                        });
                                        betpatties(input);
                                      },
                                      maxLength: 1,
                                      style: ThemeHelper().textStyle(),
                                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],

                                    ),
                                  ),
                                ),

                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                    child: TextFormField(
                                      decoration: ThemeHelper().customInputDecoration('Right Digit',""),
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      controller: right_digit,
                                      //onChanged: (input) => left_digit.text = "",
                                      onChanged: (input){
                                        left_digit.text = "";
                                        setState((){
                                          bet_patties = "";
                                        });
                                        betpatties(input);
                                      },
                                      maxLength: 1,
                                      style: ThemeHelper().textStyle(),
                                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],

                                    ),
                                  ),
                                ),


                              ],),
                            SizedBox(height: 40,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                    child: TextFormField(
                                      decoration: ThemeHelper().customInputDecoration('Enter Amount',""),
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      controller: amount,
                                      maxLength: 6,
                                      style: ThemeHelper().textStyle(),
                                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],

                                    ),
                                  ),
                                ),




                              ],),

                            SizedBox(height: 40,),
                          ],
                        ),





                      ),

                    ),
                    SizedBox(height: 40,),
                    GradientText("Bet Jodies : " + bet_patties, ),
                    SizedBox(height: 40,),
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

                            if (validateAndSave() && amount.text!="" && ((left_digit.text!="" && right_digit.text=="") || (left_digit.text=="" && right_digit.text!="")))
                            {
                              if(left_digit.text !="")
                              {
                                  for(int i = 0; i <= 9; i++)
                                  {
                                      String s = left_digit.text + i.toString();
                                      takeNumber(amount.text, s);
                                  }

                              }
                              if(right_digit.text !="")
                              {
                                for(int i = 0; i <= 9; i++)
                                {
                                  String s = i.toString() + right_digit.text;
                                  takeNumber(amount.text, s);
                                }

                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SubmitBid(title: widget.title,session:widget.session,id: widget.id,date: widget.date,itemDetail: itemDetail,image: "digit_based_jodi.png",game_name: "Digit Jodi",total: total.toString(),))
                              ).then((_) => resetvariables());
                            }
                            else if(left_digit.text=="" && right_digit.text=="")
                            {
                              var snackBar = SnackBar(content: Text("Please Enter Digit",style: TextStyle(color: Colors.black)),backgroundColor:HexColor("#FEDB87"));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                            else
                            {
                              var snackBar = SnackBar(content: Text("Please Enter Amount",style: TextStyle(color: Colors.black)),backgroundColor:HexColor("#FEDB87"));
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

  void betpatties(String input)
  {
    if(left_digit.text !="")
    {
      String bp = "";
      for(int i = 0; i <= 9; i++)
      {
        String s = left_digit.text + i.toString();
        bp = (i == 0) ?  s : bet_patties + ", " + s;
        setState((){
          bet_patties = bp;
        });
        //takeNumber(amount.text, s);
      }

    }
    if(right_digit.text !="")
    {
      String bp = "";
      for(int i = 0; i <= 9; i++)
      {
        String s = i.toString() + right_digit.text;
        bp = (i == 0) ?  s : bet_patties + ", " + s;
        setState((){
          bet_patties = bp;
        });
        //takeNumber(amount.text, s);
      }

    }
  }
}
class Item {
  final String id;
  Item(this.id);
}