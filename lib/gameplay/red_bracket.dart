import 'package:wingame/gameplay/submit_bid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wingame/globalvar.dart' as globals;
import '../common/theme_helper.dart';
import '../widgets/appbar.dart';
import 'gameplay_header.dart';
class RedBracket extends StatefulWidget {
  final String? title;
  final String? session;
  final int id;
  final String? date;
  const RedBracket({Key? key, this.title, this.session, required this.id,required this.date}) : super(key: key);

  @override
  State<RedBracket> createState() => _RedBracketState();
}

class _RedBracketState extends State<RedBracket> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Item> itemList = [
    Item("00"),Item("11"),Item("22"),Item("33"),Item("44"),Item("55"),Item("66"),Item("77"),Item("88"),Item("99"),
    Item("05"),Item("16"),Item("27"),Item("38"),Item("49"),Item("50"),Item("61"),Item("72"),Item("83"),Item("94"),
  ];

  List<Map<String, dynamic>> itemDetail = [];
  bool isApiCallProcess = false;
  int total = 0;



  void takeNumber(String inputamount, String bracket) {
    try {
      Map<String, dynamic> json = {"game_provider_id": widget.id,"game_type_id" : "8" ,"game_brackets":bracket,"game_bidding_points":inputamount,"game_date":widget.date,"game_session":"close"};
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
            GameplayHeader(id:widget.id.toString(),title: widget.title,type: "Red Bracket",session: "",date: widget.date,),
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
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            crossAxisSpacing: 20.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: width / (height / 6),
                            physics: NeverScrollableScrollPhysics(),
                            children: List.generate(itemList.length, (index)
                            {
                              Item item = itemList[index];
                              return TextFormField(
                                decoration: ThemeHelper().gameplayInputDecoration('Amount', item.id.toString()),
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                style: ThemeHelper().textStyle(),
                                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                onSaved: (input) => (input!="") ? takeNumber(input!, item.id.toString()) : "",
                                validator: (input) => (input!.isNotEmpty && int.parse(input) < 10)
                                    ? "Amount Greater Than 10"
                                    : null,
                              );
                            }
                            ),
                          ),

                          //SizedBox(height: 10,),
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

                            if (validateAndSave() && itemDetail.length > 0)
                            {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SubmitBid(title: widget.title,session:widget.session,id: widget.id,date: widget.date,itemDetail: itemDetail,image: "red_bracket.png",game_name: "Red Bracket",total: total.toString(),))
                              ).then((_) => resetvariables());
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
}
class Item {
  final String id;
  Item(this.id);
}