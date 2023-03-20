import 'package:wingame/gameplay/submit_bid.dart';
import 'package:wingame/widgets/GradientText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wingame/globalvar.dart' as globals;
import '../common/theme_helper.dart';
import '../widgets/appbar.dart';
import 'gameplay_header.dart';
class SpDpTp extends StatefulWidget {
  final String? title;
  final String? session;
  final int id;
  final String? date;
  const SpDpTp({Key? key, this.title, this.session, required this.id,required this.date}) : super(key: key);

  @override
  State<SpDpTp> createState() => _SpDpTpState();
}

class _SpDpTpState extends State<SpDpTp> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> itemDetail = [];
  bool isApiCallProcess = false;
  int total = 0;
  final left_digit = TextEditingController();
  final amount = TextEditingController();
  bool sp = false;
  bool dp = false;
  bool tp = false;
  String bet_patties = "";

  var itemList_one = {"137","128","146","236","245","290","380","470","489","560","678","579"};
  var itemList_two = {"129","138","147","156","237","246","345","390","480","570","589","679"};
  var itemList_three = {"120","139","148","157","238","247","256","346","490","580","689","670"};
  var itemList_four = {"130","149","158","167","239","248","257","347","356","590","680","789"};
  var itemList_five = {"140","159","168","230","249","258","267","348","357","456","690","780"};
  var itemList_six = {"123","150","169","178","240","259","268","349","358","367","457","790"};
  var itemList_seven = {"124","160","179","250","269","278","340","359","368","458","467","890"};
  var itemList_eight = {"125","134","170","189","260","279","350","369","378","459","468","567"};
  var itemList_nine = {"126","135","180","234","270","289","360","379","450","469","478","568"};
  var itemList_zero = {"127","136","145","190","235","280","370","389","460","479","569","578"};

  var itemListdp_one = {"119","155","227","335","344","399","588","669","100"};
  var itemListdp_two = {"110","228","255","336","499","660","688","778","200"};
  var itemListdp_three = {"166","229","337","355","445","599","779","788","300"};
  var itemListdp_four = {"112","220","266","338","446","455","699","770","400"};
  var itemListdp_five = {"113","122","177","339","366","447","799","889","500"};
  var itemListdp_six = {"114","277","330","448","466","556","880","899","600"};
  var itemListdp_seven = {"115","133","188","223","377","449","557","566","700"};
  var itemListdp_eight = {"116","224","233","288","440","477","558","990","800"};
  var itemListdp_nine = {"117","144","199","225","388","559","577","667","900"};
  var itemListdp_zero = {"118","226","244","299","334","488","668","677","500"};

  void takeNumber(String inputamount, String bracket,String type_id) {
    try {
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
            GameplayHeader(id:widget.id.toString(),title: widget.title,type: "SP DP TP",session: widget.session,date: widget.date,),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: this.sp,
                                        activeColor: Colors.white,
                                        checkColor: HexColor(globals.color_blue),
                                        side: BorderSide(color: Colors.white),
                                        onChanged: (bool? value) {
                                          setState(() {
                                            this.sp = value!;
                                            bet_patties = "";
                                          });
                                          betpatties();
                                        },
                                      ),
                                      GradientText("SP"),
                                    ],
                                  ),
                                ),
                                ////////////cb 2
                                Container(
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        activeColor: Colors.white,
                                        checkColor: HexColor(globals.color_blue),
                                        side: BorderSide(color: Colors.white),
                                        value: this.dp,
                                        onChanged: (bool? valuedp) {
                                          setState(() {
                                            this.dp = valuedp!;
                                            bet_patties = "";
                                          });
                                          betpatties();
                                        },
                                      ),
                                      GradientText("DP"),
                                    ],
                                  ),
                                ),
                                ////////////////cb 3
                                Container(
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        activeColor: Colors.white,
                                        checkColor: HexColor(globals.color_blue),
                                        side: BorderSide(color: Colors.white),
                                        value: this.tp,
                                        onChanged: (bool? valuetp) {
                                          setState(() {
                                            this.tp = valuetp!;
                                            bet_patties = "";
                                          });
                                          betpatties();
                                        },
                                      ),
                                      GradientText("TP"),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                            SizedBox(height: 40,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                    child: TextFormField(
                                      decoration: ThemeHelper().customInputDecoration('Digit',""),
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      controller: left_digit,
                                      maxLength: 1,
                                      style: ThemeHelper().textStyle(),
                                      onChanged: (input){
                                        setState((){
                                          bet_patties = "";
                                        });
                                        betpatties();
                                      },
                                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                      validator: (input) => (input!.isEmpty)
                                          ? "Enter Digit"
                                          : null,
                                    ),
                                  ),
                                ),

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


                              ],),
                            SizedBox(height: 40,),
                          ],
                        ),





                      ),

                    ),
                    SizedBox(height: 40,),
                    GradientText("Bet Patties : " , style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Container(
                        padding: EdgeInsets.all(15),
                        child: GradientText(bet_patties)),
                    SizedBox(height: 150,),
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
                              if(sp==true && left_digit.text=="0"){ getlist(itemList_zero,"1"); }
                              if(sp==true && left_digit.text=="1"){ getlist(itemList_one,"1"); }
                              if(sp==true && left_digit.text=="2"){ getlist(itemList_two,"1"); }
                              if(sp==true && left_digit.text=="3"){ getlist(itemList_three,"1"); }
                              if(sp==true && left_digit.text=="4"){ getlist(itemList_four,"1"); }
                              if(sp==true && left_digit.text=="5"){ getlist(itemList_five,"1"); }
                              if(sp==true && left_digit.text=="6"){ getlist(itemList_six,"1"); }
                              if(sp==true && left_digit.text=="7"){ getlist(itemList_seven,"1"); }
                              if(sp==true && left_digit.text=="8"){ getlist(itemList_eight,"1"); }
                              if(sp==true && left_digit.text=="9"){ getlist(itemList_nine,"1"); }

                              if(dp==true && left_digit.text=="1"){ getlist(itemListdp_one,"2"); }
                              if(dp==true && left_digit.text=="2"){ getlist(itemListdp_two,"2"); }
                              if(dp==true && left_digit.text=="3"){ getlist(itemListdp_three,"2"); }
                              if(dp==true && left_digit.text=="4"){ getlist(itemListdp_four,"2"); }
                              if(dp==true && left_digit.text=="5"){ getlist(itemListdp_five,"2"); }
                              if(dp==true && left_digit.text=="6"){ getlist(itemListdp_six,"2"); }
                              if(dp==true && left_digit.text=="7"){ getlist(itemListdp_seven,"2"); }
                              if(dp==true && left_digit.text=="8"){ getlist(itemListdp_eight,"2"); }
                              if(dp==true && left_digit.text=="9"){ getlist(itemListdp_nine,"2"); }
                              if(dp==true && left_digit.text=="0"){ getlist(itemListdp_zero,"2"); }

                              if(tp==true && left_digit.text=="0"){ takeNumber(amount.text.toString() ,"000","3"); }
                              if(tp==true && left_digit.text=="1"){ takeNumber(amount.text.toString() ,"111","3"); }
                              if(tp==true && left_digit.text=="2"){ takeNumber(amount.text.toString() ,"222","3"); }
                              if(tp==true && left_digit.text=="3"){ takeNumber(amount.text.toString() ,"333","3"); }
                              if(tp==true && left_digit.text=="4"){ takeNumber(amount.text.toString() ,"444","3"); }
                              if(tp==true && left_digit.text=="5"){ takeNumber(amount.text.toString() ,"555","3"); }
                              if(tp==true && left_digit.text=="6"){ takeNumber(amount.text.toString() ,"666","3"); }
                              if(tp==true && left_digit.text=="7"){ takeNumber(amount.text.toString() ,"777","3"); }
                              if(tp==true && left_digit.text=="8"){ takeNumber(amount.text.toString() ,"888","3"); }
                              if(tp==true && left_digit.text=="9"){ takeNumber(amount.text.toString() ,"999","3"); }

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SubmitBid(title: widget.title,session:widget.session,id: widget.id,date: widget.date,itemDetail: itemDetail,image: "spdptp.png",game_name: "SpDpTp",total: total.toString(),))
                              ).then((_) => resetvariables());
                            }
                            else
                            {
                              var snackBar = SnackBar(content: Text("Please Enter Amount",style: TextStyle(color: Colors.black),),backgroundColor:HexColor("#FEDB87"));
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

  getlist(listdata,type)
  {
    listdata.forEach((value) {
      takeNumber(amount.text.toString() ,value,type);
    });
  }

  setpatties(listdata,type)
  {
    listdata.forEach((value) {
      setState((){
        bet_patties = (bet_patties.length == 0) ?  value : bet_patties + ", " + value;
      });
    });
  }

  void betpatties()
  {
    if(sp==true && left_digit.text=="0"){ setpatties(itemList_zero,"1"); }
    if(sp==true && left_digit.text=="1"){ setpatties(itemList_one,"1"); }
    if(sp==true && left_digit.text=="2"){ setpatties(itemList_two,"1"); }
    if(sp==true && left_digit.text=="3"){ setpatties(itemList_three,"1"); }
    if(sp==true && left_digit.text=="4"){ setpatties(itemList_four,"1"); }
    if(sp==true && left_digit.text=="5"){ setpatties(itemList_five,"1"); }
    if(sp==true && left_digit.text=="6"){ setpatties(itemList_six,"1"); }
    if(sp==true && left_digit.text=="7"){ setpatties(itemList_seven,"1"); }
    if(sp==true && left_digit.text=="8"){ setpatties(itemList_eight,"1"); }
    if(sp==true && left_digit.text=="9"){ setpatties(itemList_nine,"1"); }

    if(dp==true && left_digit.text=="1"){ setpatties(itemListdp_one,"2"); }
    if(dp==true && left_digit.text=="2"){ setpatties(itemListdp_two,"2"); }
    if(dp==true && left_digit.text=="3"){ setpatties(itemListdp_three,"2"); }
    if(dp==true && left_digit.text=="4"){ setpatties(itemListdp_four,"2"); }
    if(dp==true && left_digit.text=="5"){ setpatties(itemListdp_five,"2"); }
    if(dp==true && left_digit.text=="6"){ setpatties(itemListdp_six,"2"); }
    if(dp==true && left_digit.text=="7"){ setpatties(itemListdp_seven,"2"); }
    if(dp==true && left_digit.text=="8"){ setpatties(itemListdp_eight,"2"); }
    if(dp==true && left_digit.text=="9"){ setpatties(itemListdp_nine,"2"); }
    if(dp==true && left_digit.text=="0"){ setpatties(itemListdp_zero,"2"); }

    if(tp==true && left_digit.text=="0"){ setState((){ bet_patties = (bet_patties.length == 0) ?  "000" : bet_patties + ", " + "000"; }); }
    if(tp==true && left_digit.text=="1"){ setState((){ bet_patties = (bet_patties.length == 0) ?  "111" : bet_patties + ", " + "111"; }); }
    if(tp==true && left_digit.text=="2"){ setState((){ bet_patties = (bet_patties.length == 0) ?  "222" : bet_patties + ", " + "222"; }); }
    if(tp==true && left_digit.text=="3"){ setState((){ bet_patties = (bet_patties.length == 0) ?  "333" : bet_patties + ", " + "333"; }); }
    if(tp==true && left_digit.text=="4"){ setState((){ bet_patties = (bet_patties.length == 0) ?  "444" : bet_patties + ", " + "444"; }); }
    if(tp==true && left_digit.text=="5"){ setState((){ bet_patties = (bet_patties.length == 0) ?  "555" : bet_patties + ", " + "555"; }); }
    if(tp==true && left_digit.text=="6"){ setState((){ bet_patties = (bet_patties.length == 0) ?  "666" : bet_patties + ", " + "666"; }); }
    if(tp==true && left_digit.text=="7"){ setState((){ bet_patties = (bet_patties.length == 0) ?  "777" : bet_patties + ", " + "777"; }); }
    if(tp==true && left_digit.text=="8"){ setState((){ bet_patties = (bet_patties.length == 0) ?  "888" : bet_patties + ", " + "888"; }); }
    if(tp==true && left_digit.text=="9"){ setState((){ bet_patties = (bet_patties.length == 0) ?  "999" : bet_patties + ", " + "999"; }); }
  }
}
class Item {
  final String id;
  Item(this.id);
}