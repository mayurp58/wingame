import 'package:wingame/starline/starline_gameplay_header.dart';
import 'package:wingame/starline/submit_starline_bid.dart';
import 'package:wingame/widgets/GradientText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wingame/globalvar.dart' as globals;
import '../common/theme_helper.dart';
import '../widgets/appbar.dart';
class StarlineChoicePanna extends StatefulWidget {
  final String? title;
  final String? session;
  final int id;
  final String? date;
  const StarlineChoicePanna({Key? key, this.title, this.session, required this.id,required this.date}) : super(key: key);

  @override
  State<StarlineChoicePanna> createState() => _StarlineChoicePannaState();
}

class _StarlineChoicePannaState extends State<StarlineChoicePanna> {
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
  String bet_patties = "";

  Map<String, String> map1 = {};

  var singlePannaArray = {"127", "128", "129", "120", "130", "140", "123", "124", "125", "126", "136", "137", "138", "139", "149", "159", "150", "160", "134", "135", "145", "146", "147", "148", "158", "168", "169", "179", "170", "180", "190", "236", "156", "157", "167", "230", "178", "250", "189", "234", "235", "245", "237", "238", "239", "249", "240", "269", "260", "270", "280", "290", "246", "247", "248", "258", "259", "278", "279", "289", "370", "380", "345", "256", "257", "267", "268", "340", "350", "360", "389", "470", "390", "346", "347", "348", "349", "359", "369", "379", "460", "489", "480", "490", "356", "357", "358", "368", "378", "450", "479", "560", "570", "580", "590", "456", "367", "458", "459", "469", "569", "579", "589", "670", "680", "690", "457", "467", "468", "478", "578", "678", "679", "689", "789", "780", "790", "890", "567", "568"};
  var doublePannaArray = {"118", "100", "110", "166", "112", "113", "114", "115", "116", "117", "226", "119", "200", "229", "220", "122", "277", "133", "224", "144", "244", "155", "228", "300", "266", "177", "330", "188", "233", "199", "299", "227", "255", "337", "338", "339", "448", "223", "288", "225", "334", "335", "336", "355", "400", "366", "466", "377", "440", "388", "488", "344", "499", "445", "446", "447", "556", "449", "477", "559", "550", "399", "660", "599", "455", "500", "600", "557", "558", "577", "668", "588", "688", "779", "699", "799", "880", "566", "800", "667", "677", "669", "778", "788", "770", "889", "899", "700", "990", "900"};
  var tripplePannaArray = {"000", "777", "444", "111", "888", "555", "222", "999", "666", "333"};
  var allpanna = {"127", "128", "129", "120", "130", "140", "123", "124", "125", "126", "136", "137", "138", "139", "149", "159", "150", "160", "134", "135", "145", "146", "147", "148", "158", "168", "169", "179", "170", "180", "190", "236", "156", "157", "167", "230", "178", "250", "189", "234", "235", "245", "237", "238", "239", "249", "240", "269", "260", "270", "280", "290", "246", "247", "248", "258", "259", "278", "279", "289", "370", "380", "345", "256", "257", "267", "268", "340", "350", "360", "389", "470", "390", "346", "347", "348", "349", "359", "369", "379", "460", "489", "480", "490", "356", "357", "358", "368", "378", "450", "479", "560", "570", "580", "590", "456", "367", "458", "459", "469", "569", "579", "589", "670", "680", "690", "457", "467", "468", "478", "578", "678", "679", "689", "789", "780", "790", "890", "567", "568"
    , "118", "100", "110", "166", "112", "113", "114", "115", "116", "117", "226", "119", "200", "229", "220", "122", "277", "133", "224", "144", "244", "155", "228", "300", "266", "177", "330", "188", "233", "199", "299", "227", "255", "337", "338", "339", "448", "223", "288", "225", "334", "335", "336", "355", "400", "366", "466", "377", "440", "388", "488", "344", "499", "445", "446", "447", "556", "449", "477", "559", "550", "399", "660", "599", "455", "500", "600", "557", "558", "577", "668", "588", "688", "779", "699", "799", "880", "566", "800", "667", "677", "669", "778", "788", "770", "889", "899", "700", "990", "900"
    , "000", "777", "444", "111", "888", "555", "222", "999", "666", "333"};

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
            StarlineGameplayHeader(id:widget.id.toString(),title: widget.title,type: "Choice Pana",session: widget.session,date: widget.date,),
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
                                            this.sp = value!;bet_patties = "";
                                          });
                                          betpatties();
                                        },
                                      ),
                                      GradientText("SP",style: TextStyle(fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                ),
                                ////////////cb 2
                                Container(
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: this.dp,
                                        activeColor: Colors.white,
                                        checkColor: HexColor(globals.color_blue),
                                        side: BorderSide(color: Colors.white),
                                        onChanged: (bool? valuedp) {
                                          setState(() {
                                            this.dp = valuedp!;
                                            bet_patties = "";
                                          });
                                          betpatties();
                                        },
                                      ),
                                      GradientText("DP",style: TextStyle(fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                ),
                                ////////////////cb 3
                                Container(
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: this.tp,
                                        activeColor: Colors.white,
                                        checkColor: HexColor(globals.color_blue),
                                        side: BorderSide(color: Colors.white),
                                        onChanged: (bool? valuetp) {
                                          setState(() {
                                            this.tp = valuetp!;
                                            bet_patties = "";
                                          });
                                          betpatties();
                                        },
                                      ),
                                      GradientText("TP",style: TextStyle(fontWeight: FontWeight.bold),),
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
                                      decoration: ThemeHelper().customInputDecoration('Left',""),
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      controller: left_digit,
                                      maxLength: 1,
                                      onChanged: (input){
                                        setState((){
                                          bet_patties = "";
                                        });
                                        betpatties();
                                      },
                                      style: ThemeHelper().textStyle(),
                                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                    ),
                                  ),
                                ),

                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                    child: TextFormField(
                                      decoration: ThemeHelper().customInputDecoration('Middle',""),
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      controller: middle_digit,
                                      maxLength: 1,
                                      onChanged: (input){
                                        setState((){
                                          bet_patties = "";
                                        });
                                        betpatties();
                                      },
                                      style: ThemeHelper().textStyle(),
                                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                    ),
                                  ),
                                ),

                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                    child: TextFormField(
                                      decoration: ThemeHelper().customInputDecoration('Right',""),
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      controller: right_digit,
                                      maxLength: 1,
                                      onChanged: (input){
                                        setState((){
                                          bet_patties = "";
                                        });
                                        betpatties();
                                      },
                                      style: ThemeHelper().textStyle(),
                                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
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
                            SizedBox(height: 10,),
                          ],
                        ),





                      ),

                    ),
                    SizedBox(height: 5,),
                    GradientText("Bet Patties : " , style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Container(
                        padding: EdgeInsets.all(15),
                        child: GradientText(bet_patties)),
                    SizedBox(height: 125,),
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
                            fulldgt = left_digit.text + middle_digit.text + right_digit.text;
                            if (validateAndSave() && amount.text.isNotEmpty && (left_digit.text.isNotEmpty || middle_digit.text.isNotEmpty || right_digit.text.isNotEmpty) && (fulldgt.toString().length == 3 || (sp==true || dp==true || tp==true)))
                            {
                              if(fulldgt.toString().length == 3)
                              {
                                takeNumber(amount.text.toString() ,fulldgt,"13");
                              }
                              else
                              {
                                if(sp==true){ getlist_twodigit(singlePannaArray); }
                                if(dp==true){ getlist_twodigit(doublePannaArray); }
                                if(tp==true){ getlist_twodigit(tripplePannaArray); }
                              }
                              map1.forEach((key, value) {
                                takeNumber(value,key,"13");
                                //registermodel('Key = $key : Value = $value');
                              });
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
                                              image: "choice_panna.png",
                                              game_name: "Choice Panna",
                                              total: total.toString(),))
                                ).then((_) => resetvariables());
                              }
                            }
                            else if(fulldgt.toString().length != 3 && (sp==false || dp==false || tp==false))
                            {
                              var snackBar = SnackBar(content: Text("Please Check SP or Dp or TP"),backgroundColor:HexColor("#FEDB87"));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                            else if(left_digit.text.isEmpty || middle_digit.text.isEmpty || right_digit.text.isEmpty)
                            {
                              var snackBar = SnackBar(content: Text("Enter Digit In Left, Middle or Right"),backgroundColor:HexColor("#FEDB87"));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                            else
                            {
                              var snackBar = SnackBar(content: Text("Please Enter Amount"),backgroundColor:HexColor("#FEDB87"));
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
    map1 = {};
  }

  getlist_betpatties(listdata)
  {
    listdata.forEach((value)
    {
      List<String> searchKeywords = List<String>.generate(value.length,(index) => value[index]);
      //print("left" + left_digit.text + middle_digit.text + right_digit.text);
      if(left_digit.text != "" && left_digit.text==searchKeywords[0] && middle_digit.text=="" && right_digit.text=="")
      {
        //map1[value] = amount.text;
        setState((){ bet_patties = (bet_patties.length == 0) ?  value : bet_patties + ", " + value; });
      }
      if(middle_digit.text != "" && middle_digit.text==searchKeywords[1] && left_digit.text=="" && right_digit.text=="")
      {
        //map1[value] = amount.text;
        setState((){ bet_patties = (bet_patties.length == 0) ?  value : bet_patties + ", " + value; });
      }
      if(right_digit.text != "" && right_digit.text==searchKeywords[2] && left_digit.text=="" && middle_digit.text=="")
      {
        //map1[value] = amount.text;
        setState((){ bet_patties = (bet_patties.length == 0) ?  value : bet_patties + ", " + value; });
      }
      if(left_digit.text != "" && left_digit.text==searchKeywords[0] && middle_digit.text != "" && middle_digit.text==searchKeywords[1] && right_digit.text=="")
      {
        //map1[value] = amount.text;
        setState((){ bet_patties = (bet_patties.length == 0) ?  value : bet_patties + ", " + value; });
      }
      if(left_digit.text != "" && left_digit.text.toString()==searchKeywords[0].toString() && right_digit.text != "" && right_digit.text.toString()==searchKeywords[2].toString() && middle_digit.text=="")
      {
        //map1[value] = amount.text;
        setState((){ bet_patties = (bet_patties.length == 0) ?  value : bet_patties + ", " + value; });
      }
      if(middle_digit.text != "" && middle_digit.text==searchKeywords[1] && right_digit.text != "" && right_digit.text==searchKeywords[2] && left_digit.text=="")
      {
        //map1[value] = amount.text;
        setState((){ bet_patties = (bet_patties.length == 0) ?  value : bet_patties + ", " + value; });
      }

    });
  }

  void betpatties() {
    if(sp==true){ getlist_betpatties(singlePannaArray); }
    if(dp==true){ getlist_betpatties(doublePannaArray); }
    if(tp==true){ getlist_betpatties(tripplePannaArray); }
  }

  getlist_twodigit(listdata)
  {
    listdata.forEach((value)
    {
      List<String> searchKeywords = List<String>.generate(value.length,(index) => value[index]);
      //print("left" + left_digit.text + middle_digit.text + right_digit.text);
      if(left_digit.text != "" && left_digit.text==searchKeywords[0] && middle_digit.text=="" && right_digit.text=="")
      {
        map1[value] = amount.text;
      }
      if(middle_digit.text != "" && middle_digit.text==searchKeywords[1] && left_digit.text=="" && right_digit.text=="")
      {
        map1[value] = amount.text;
      }
      if(right_digit.text != "" && right_digit.text==searchKeywords[2] && left_digit.text=="" && middle_digit.text=="")
      {
        map1[value] = amount.text;
      }
      if(left_digit.text != "" && left_digit.text==searchKeywords[0] && middle_digit.text != "" && middle_digit.text==searchKeywords[1] && right_digit.text=="")
      {
        map1[value] = amount.text;
      }
      if(left_digit.text != "" && left_digit.text.toString()==searchKeywords[0].toString() && right_digit.text != "" && right_digit.text.toString()==searchKeywords[2].toString() && middle_digit.text=="")
      {
        map1[value] = amount.text;
      }
      if(middle_digit.text != "" && middle_digit.text==searchKeywords[1] && right_digit.text != "" && right_digit.text==searchKeywords[2] && left_digit.text=="")
      {
        map1[value] = amount.text;
      }

    });
  }

}