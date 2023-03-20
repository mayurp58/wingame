import 'package:wingame/superjodi/sup_submit_bid.dart';
import 'package:wingame/superjodi/superjodi_gameplay_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wingame/globalvar.dart' as globals;
import '../common/theme_helper.dart';
import '../widgets/GradientText.dart';
import '../widgets/appbar.dart';
class Sup_group_jodi extends StatefulWidget {
  final String? title;
  final String? session;
  final int id;
  final String? date;
  const Sup_group_jodi({Key? key,this.title, this.session, required this.id, this.date}) : super(key: key);

  @override
  State<Sup_group_jodi> createState() => _Sup_group_jodiState();
}

class _Sup_group_jodiState extends State<Sup_group_jodi> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> itemDetail = [];
  bool isApiCallProcess = false;
  int total = 0;
  var primary = {"1", "2", "3", "4", "5"};
  var dependent = {"6", "7", "8", "9", "0"};
  var finalarr = [];
  final jodidgt = TextEditingController();
  final amount = TextEditingController();
  String bet_patties = "";
  //23,32,28,82,37,73,78,87,
  //a+d, d+a, a+b, b+a, c+d, d+c, b+c, c+b

  void takeNumber(String inputamount, String bracket) {
    try {
      Map<String, dynamic> json = {"game_provider_id": widget.id,"game_type_id" : "1" ,"game_brackets":bracket,"game_bidding_points":inputamount,"game_date":widget.date,"game_session":"close"};
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

            Sup_gameplay_header(id:widget.id.toString(),title: widget.title,type: "Group Jodi",session: "",date: widget.date,),
            //////////////////////////////Heade Ends Here////////////////////////////
            Container(
              //height: ,
              width: double.infinity,
              child: Card(
                color: Colors.black,
                elevation: 20, //shadow elevation for card
                margin: EdgeInsets.all(8),
                shadowColor: HexColor(globals.color_blue),
                child: Column(
                  children: [

                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                child: TextFormField(
                                  decoration: ThemeHelper().customInputDecoration('Jodi Digit',""),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  controller: jodidgt,
                                  maxLength: 2,
                                  style: ThemeHelper().textStyle(),
                                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                  //onSaved: (input) => (input!="") ? takeNumber(input!, item.id.toString()) : "",
                                  onChanged: (input){
                                    setState((){
                                      bet_patties = "";
                                    });
                                    betpatties(input);
                                  },
                                  validator: (input) => (input!.isNotEmpty && input.length < 2)
                                      ? "Jodi Must Be 2 Digit"
                                      : null,
                                ),
                              ),
                            ),

                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                child: TextFormField(
                                  decoration: ThemeHelper().customInputDecoration('Enter Points',""),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  controller: amount,
                                  maxLength: 6,
                                  style: ThemeHelper().textStyle(),
                                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                  //onSaved: (input) => (input!="") ? takeNumber(input!, item.id.toString()) : "",
                                  validator: (input) => (input!.isNotEmpty && int.parse(input) < 10)
                                      ? "Amount Greater Than 10"
                                      : null,
                                ),
                              ),
                            ),
                          ],),



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

                            if (validateAndSave() && amount.text!="" && jodidgt.text!="" )
                            {
                              finalarr = [];
                              String enteredPanna = jodidgt.text.toString().trim();
                              String a = enteredPanna.substring(0, 1);
                              String b = enteredPanna.substring(enteredPanna.length - 1);
                              String c = "";
                              String d = "";

                              for (int i = 0; i < primary.length; i++) {
                                if (a == primary.elementAt(i)) {
                                  c = dependent.elementAt(i);
                                } else if (a == dependent.elementAt(i)) {
                                  c = primary.elementAt(i);
                                }
                                if (b == primary.elementAt(i)) {
                                  d = dependent.elementAt(i);
                                } else if (b == dependent.elementAt(i)) {
                                  d = primary.elementAt(i);
                                }
                              }
                              var send = {a,b,c,d};
                              finalarr.add(a+d);
                              finalarr.add(d+a);
                              finalarr.add(a+b);
                              finalarr.add(b+a);

                              finalarr.add(c+d);
                              finalarr.add(d+c);
                              finalarr.add(b+c);
                              finalarr.add(c+b);
                              var distinctIds = finalarr.toSet().toList();

                              for(int i = 0; i < distinctIds.length; i++)
                              {
                                takeNumber(amount.text, distinctIds.elementAt(i));
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Sup_submit_bid(title: widget.title,session:widget.session,id: widget.id,date: widget.date,itemDetail: itemDetail,image: "group_jodi.png",game_name: "Group Jodi",total: total.toString(),))
                              ).then((_) => resetvariables());
                            }
                            else if(jodidgt.text=="")
                            {
                              var snackBar = SnackBar(content: Text("Please Enter Jodi",style: TextStyle(color: Colors.black)),backgroundColor:HexColor(globals.color_blue));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                            else
                            {
                              var snackBar = SnackBar(content: Text("Please Enter Amount",style: TextStyle(color: Colors.black)),backgroundColor:HexColor(globals.color_blue));
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
    finalarr = [];
    String enteredPanna = jodidgt.text.toString().trim();
    String a = enteredPanna.substring(0, 1);
    String b = enteredPanna.substring(enteredPanna.length - 1);
    String c = "";
    String d = "";

    for (int i = 0; i < primary.length; i++) {
      if (a == primary.elementAt(i)) {
        c = dependent.elementAt(i);
      } else if (a == dependent.elementAt(i)) {
        c = primary.elementAt(i);
      }
      if (b == primary.elementAt(i)) {
        d = dependent.elementAt(i);
      } else if (b == dependent.elementAt(i)) {
        d = primary.elementAt(i);
      }
    }
    var send = {a,b,c,d};
    finalarr.add(a+d);
    finalarr.add(d+a);
    finalarr.add(a+b);
    finalarr.add(b+a);

    finalarr.add(c+d);
    finalarr.add(d+c);
    finalarr.add(b+c);
    finalarr.add(c+b);
    var distinctIds = finalarr.toSet().toList();
    int i = 0;
    String bp = "";
    distinctIds.forEach((value) {
      bp = (i == 0) ?  value : bet_patties + ", " + value;
      setState((){
        bet_patties = bp;
        i = i +1;
      });
    });
  }
}
class Item {
  final String id;
  Item(this.id);
}