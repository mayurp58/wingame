import 'package:wingame/superjodi/sup_submit_bid.dart';
import 'package:wingame/superjodi/superjodi_gameplay_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wingame/globalvar.dart' as globals;
import '../common/theme_helper.dart';
import '../widgets/appbar.dart';
class Sup_jodi_digit extends StatefulWidget {
  final String? title;
  final String? session;
  final int id;
  final String? date;
  const Sup_jodi_digit({Key? key, this.title, this.session, required this.id, this.date}) : super(key: key);

  @override
  State<Sup_jodi_digit> createState() => _Sup_jodi_digitState();
}

class _Sup_jodi_digitState extends State<Sup_jodi_digit> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Item> itemList = [
    Item("00"),Item("01"),Item("02"),Item("03"),Item("04"),Item("05"),Item("06"),Item("07"),Item("08"),Item("09"),
    Item("10"),Item("11"),Item("12"),Item("13"),Item("14"),Item("15"),Item("16"),Item("17"),Item("18"),Item("19"),
    Item("20"),Item("21"),Item("22"),Item("23"),Item("24"),Item("25"),Item("26"),Item("27"),Item("28"),Item("29"),
    Item("30"),Item("31"),Item("32"),Item("33"),Item("34"),Item("35"),Item("36"),Item("37"),Item("38"),Item("39"),
    Item("40"),Item("41"),Item("42"),Item("43"),Item("44"),Item("45"),Item("46"),Item("47"),Item("48"),Item("49"),
    Item("50"),Item("51"),Item("52"),Item("53"),Item("54"),Item("55"),Item("56"),Item("57"),Item("58"),Item("59"),
    Item("60"),Item("61"),Item("62"),Item("63"),Item("64"),Item("65"),Item("66"),Item("67"),Item("68"),Item("69"),
    Item("70"),Item("71"),Item("72"),Item("73"),Item("74"),Item("75"),Item("76"),Item("77"),Item("78"),Item("79"),
    Item("80"),Item("81"),Item("82"),Item("83"),Item("84"),Item("85"),Item("86"),Item("87"),Item("88"),Item("89"),
    Item("90"),Item("91"),Item("92"),Item("93"),Item("94"),Item("95"),Item("96"),Item("97"),Item("98"),Item("99"),
  ];

  List<Map<String, dynamic>> itemDetail = [];
  bool isApiCallProcess = false;
  int total = 0;



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
            Sup_gameplay_header(id:widget.id.toString(),title: widget.title,type: "Jodi Digit",session: "",date: widget.date,),
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
                                      builder: (context) => Sup_submit_bid(title: widget.title,session:widget.session,id: widget.id,date: widget.date,itemDetail: itemDetail,image: "jodi_digit.png",game_name: "Jodi Digit",total: total.toString(),))
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