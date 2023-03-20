import 'package:wingame/starline/starline_gameplay_header.dart';
import 'package:wingame/starline/submit_starline_bid.dart';
import 'package:wingame/widgets/GradientText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wingame/globalvar.dart' as globals;
import '../common/theme_helper.dart';
import '../widgets/appbar.dart';
class StarlineTwoDigitPanel extends StatefulWidget {
  final String? title;
  final String? session;
  final int id;
  final String? date;
  const StarlineTwoDigitPanel({Key? key, this.title, this.session, required this.id,required this.date}) : super(key: key);

  @override
  State<StarlineTwoDigitPanel> createState() => _StarlineTwoDigitPanelState();
}

class _StarlineTwoDigitPanelState extends State<StarlineTwoDigitPanel> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> itemDetail = [];
  bool isApiCallProcess = false;
  int total = 0;
  final left_digit = TextEditingController();
  final amount = TextEditingController();
  var singlepanel = {"127", "128", "129", "120", "130", "140", "123", "124", "125", "126", "136", "137", "138", "139", "149", "159", "150", "160", "134", "135", "145", "146", "147", "148", "158", "168", "169", "179", "170", "180", "190", "236", "156", "157", "167", "230", "178", "250", "189", "234", "235", "245", "237", "238", "239", "249", "240", "269", "260", "270", "280", "290", "246", "247", "248", "258", "259", "278", "279", "289", "370", "380", "345", "256", "257", "267", "268", "340", "350", "360", "389", "470", "390", "346", "347", "348", "349", "359", "369", "379", "460", "489", "480", "490", "356", "357", "358", "368", "378", "450", "479", "560", "570", "580", "590", "456", "367", "458", "459", "469", "569", "579", "589", "670", "680", "690", "457", "467", "468", "478", "578", "678", "679", "689", "789", "780", "790", "890", "567", "568"};
  var doublepanel = {"118", "100", "110", "166", "112", "113", "114", "115", "116", "117", "226", "119", "200", "229", "220", "122", "277", "133", "224", "144", "244", "155", "228", "300", "266", "177", "330", "188", "233", "199", "299", "227", "255", "337", "338", "339", "448", "223", "288", "225", "334", "335", "336", "355", "400", "366", "466", "377", "440", "388", "488", "344", "499", "445", "446", "447", "556", "449", "477", "559", "550", "399", "660", "599", "455", "500", "600", "557", "558", "577", "668", "588", "688", "779", "699", "799", "880", "566", "800", "667", "677", "669", "778", "788", "770", "889", "899", "700", "990", "900"};
  String bet_patties = "";

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
      backgroundColor: HexColor(globals.color_background),
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child :  Appbar()),
      bottomNavigationBar: submitButtonWidget(context),
      body:SingleChildScrollView(
        child: Column(
          children: [
            StarlineGameplayHeader(id:widget.id.toString(),title: widget.title,type: "Two Digit Panel",session: widget.session,date: widget.date,),
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
                                      decoration: ThemeHelper().customInputDecoration('Two Digit',""),
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      controller: left_digit,
                                      maxLength: 2,
                                      onChanged: (input){
                                        setState((){
                                          bet_patties = "";
                                        });
                                        setpatties(singlepanel);
                                        setpatties(doublepanel);
                                      },
                                      style: ThemeHelper().textStyle(),
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
                    SizedBox(height: 235,),
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
                              getlist(singlepanel,"1");
                              getlist(doublepanel,"2");
                              if(itemDetail.length > 0) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SubmitStarlineBid(title: widget.title,
                                              session: widget.session,
                                              id: widget.id,
                                              date: widget.date,
                                              itemDetail: itemDetail,
                                              image: "tow_digit_panel.png",
                                              game_name: "2Dgt Panel",
                                              total: total.toString(),))
                                ).then((_) => resetvariables());
                              }
                            }
                            else if(itemDetail.length == 0)
                            {
                              var snackBar = SnackBar(content: Text("No Panels Created Using Given Digits"),backgroundColor:HexColor(globals.color_blue));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                            else
                            {
                              var snackBar = SnackBar(content: Text("Please Enter Amount"),backgroundColor:HexColor(globals.color_blue));
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
    var other = left_digit.text;
    listdata.forEach((value) {
      if (value.contains(other)) {
        takeNumber(amount.text.toString() ,value,type);
      }
    });
  }

  setpatties(listdata)
  {
    var other = left_digit.text;
    if(left_digit.text.length==2) {
      listdata.forEach((value) {
        if (value.contains(other)) {
          setState(() {
            bet_patties =
            (bet_patties.length == 0) ? value : bet_patties + ", " + value;
          });
          //takeNumber(amount.text.toString() ,value,type);
        }
      });
    }
  }
}
class Item {
  final String id;
  Item(this.id);
}