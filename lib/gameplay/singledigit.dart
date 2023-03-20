import 'package:wingame/gameplay/submit_bid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wingame/globalvar.dart' as globals;
import '../common/theme_helper.dart';
import '../widgets/appbar.dart';
import 'gameplay_header.dart';
class SingleDigit extends StatefulWidget {
  final String? title;
  final String? session;
  final int id;
  final String? date;
  const SingleDigit({Key? key, this.title, this.session, required this.id,required this.date}) : super(key: key);

  @override
  State<SingleDigit> createState() => _SingleDigitState();
}

class _SingleDigitState extends State<SingleDigit> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Item> itemList = [
    Item("0"),Item("1"),Item("2"),Item("3"),Item("4"),Item("5"),Item("6"),Item("7"),Item("8"),Item("9"),
  ];
  List<Map<String, dynamic>> itemDetail = [];
  bool isApiCallProcess = false;
  int total = 0;
  String date = "01-01-1970";

  void takeNumber(String inputamount, String bracket) {
    try {
      Map<String, dynamic> json = {"game_provider_id": widget.id,"game_type_id" : "4" ,"game_brackets":bracket,"game_bidding_points":inputamount,"game_date":widget.date,"game_session":widget.session};
      int item = int.parse(bracket);
      int amount = int.parse(inputamount);
      //total = total + amount;
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
      body: SingleChildScrollView(

          child: Column(
            children: [
              GameplayHeader(id:widget.id.toString(),title: widget.title,type: "Single Digit",session: widget.session,date: widget.date,),
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
                  shadowColor: HexColor(globals.color_blue),
                  child: Column(
                    children: [
                      Form(
                          key: _formKey,
                          child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(children: [

                            GridView.count(
                              crossAxisCount: 2,

                              //scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              crossAxisSpacing: 20.0,
                              mainAxisSpacing: 8.0,
                              childAspectRatio: width / (height / 6),
                              children: List.generate(itemList.length, (index)
                              {

                                return TextFormField(
                                  decoration: ThemeHelper().gameplayInputDecoration('Amount', index.toString()),
                                  keyboardType: TextInputType.number,
                                  maxLength: 6,
                                  style: ThemeHelper().textStyle(),
                                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                  onSaved: (input) => (input!="") ? takeNumber(input!, index.toString()) : "",
                                  validator: (input) => (input!.isNotEmpty && int.parse(input) < 10)
                                      ? "Amount Greater Than 10"
                                      : null,
                                );
                              }
                              ),
                            ),

                            SizedBox(height: 50,),
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
                                            if (validateAndSave() && itemDetail.length > 0)
                                            {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => SubmitBid(title: widget.title,session:widget.session,id: widget.id,date: widget.date,itemDetail: itemDetail,image: "single_digit.png",game_name: "Single Digit",total: total.toString(),))
                                              ).then((_) => resetvariables());
                                            }
                                            else
                                            {
                                                var snackBar = SnackBar(content: Text("Please Enter Amount",style: TextStyle(color: Colors.black),),backgroundColor:HexColor(globals.color_blue));
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                            }


                                        }
                                    )
                                )
                              ],
                            ),
                            SizedBox(height: 120,),
                          ],),



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

  resetvariables() {
    itemDetail = [];
    total = 0;
  }
}
class Item {
  final String id;
  Item(this.id);
}