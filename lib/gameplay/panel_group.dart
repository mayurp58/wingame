import 'package:wingame/gameplay/gameplay_header.dart';
import 'package:wingame/gameplay/submit_bid.dart';
import 'package:wingame/widgets/GradientText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wingame/globalvar.dart' as globals;
import '../common/theme_helper.dart';
import '../widgets/appbar.dart';
class PanelGroup extends StatefulWidget {
  final String? title;
  final String? session;
  final int id;
  final String? date;
  const PanelGroup({Key? key, this.title, this.session, required this.id,required this.date}) : super(key: key);

  @override
  State<PanelGroup> createState() => _PanelGroupState();
}

class _PanelGroupState extends State<PanelGroup> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> itemDetail = [];
  bool isApiCallProcess = false;
  int total = 0;
  String bet_patties = "";
  final left_digit = TextEditingController();
  final amount = TextEditingController();
  static const List<String> all_panna = <String>["128", "137", "236", "678", "123", "268", "367", "178", "129", "147", "246", "679", "124", "179", " 467", "269", "120", "157", "256", " 670", "170", "567", "125", "260", "130", "158", "680", "356", "180", "568", "135", "360", "140", "159", "456", "690", "190", "569", "145", "460", "245", "240", "345", "890", "139", "189", "789", "379", "230", "280", "290", "259", "390", "458", "148", "468", "347", "478", "258", "235", "470", "457", "480", "340", "346", "369", "248", "289", "357", "578", "579", "790", "589", "359", "689", "134", "239", "234", "780", "370", "380", "880", "570", "250", "247", "477", "167", "117", "249", "244", "335", "330", "255", "557", "779", "279", "112", "126", "799", "299", "588", "358", "200", "700", "229", "224", "266", "667", "447", "479", "489", "448", "138", "368", "445", "459", "149", "144", "348", "334", "344", "899", "336", "133", "599", "990", "446", "199", "339", "488", "399", "349", "688", "188", "490", "440", "699", "469", "889", "389", "100", "600", "660", "115", "300", "800", "400", "900", "168", "136", "155", "556", "110", "566", "580", "558", "455", "559", "113", "668", "560", "150", "156", "160", "355", "350", "590", "450", "366", "118", "146", "114", "778", "278", "337", "378", "220", "225", "122", "677", "669", "466", "237", "223", "238", "288", "770", "577", "177", "127", "119", "169", "228", "377", "788", "233", "257", "270", "267", "226", "227", "277", "499", "449", "166", "116", "338", "388", "500", "550", "777", "222", "444", "999", "111", "666", "888", "333", "555", "000"];
  var panelgroups = [
    {"128", "137", "236", "678", "123", "268", "367", "178"},
    {"129", "147", "246", "679", "124", "179", "467", "269"},
    {"120", "157", "256", "670", "170", "567", "125", "260"},
    {"130", "158", "680", "356", "180", "568", "135", "360"},
    {"140", "159", "456", "690", "190", "569", "145", "460"},
    {"245", "240", "290", "259", "470", "457", "579", "790"},
    {"345", "890", "390", "458", "480", "340", "589", "359"},
    {"139", "189", "148", "468", "346", "369", "689", "134"},
    {"789", "379", "347", "478", "248", "289", "239", "234"},
    {"230", "280", "258", "235", "357", "578", "780", "370"},
    {"380", "880", "335", "330", "588", "358"},
    {"570", "250", "255", "557", "200", "700"},
    {"247", "477", "779", "279", "229", "224"},
    {"167", "117", "112", "126", "266", "667"},
    {"249", "244", "799", "299", "447", "479"},
    {"489", "448", "344", "899", "399", "349"},
    {"138", "368", "336", "133", "688", "188"},
    {"445", "459", "599", "990", "490", "440"},
    {"149", "144", "446", "199", "699", "469"},
    {"348", "334", "339", "488", "889", "389"},
    {"100", "600", "155", "556", "560", "150"},
    {"660", "115", "110", "566", "156", "160"},
    {"300", "800", "580", "558", "355", "350"},
    {"400", "900", "455", "559", "590", "450"},
    {"168", "136", "113", "668", "366", "118"},
    {"146", "114", "669", "466", "119", "169"},
    {"778", "278", "237", "223", "228", "377"},
    {"337", "378", "238", "288", "788", "233"},
    {"220", "225", "770", "577", "257", "270"},
    {"122", "677", "177", "127", "267", "226"},
    {"227", "277", "777", "222"},
    {"499", "449", "444", "999"},
    {"166", "116", "111", "666"},
    {"338", "388", "888", "333"},
    {"500", "550", "555", "000"}
  ];
  late TextEditingController controller;


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
            GameplayHeader(id:widget.id.toString(),title: widget.title,type: "Family Panna",session: widget.session,date: widget.date,),
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
                                    child: Autocomplete<String>(

                                      optionsBuilder: (TextEditingValue textEditingValue) {
                                        if (textEditingValue.text == '') {
                                          return const Iterable<String>.empty();
                                        }
                                        return all_panna.where((String option) {
                                          return option.contains(textEditingValue.text.toLowerCase());
                                        });
                                      },
                                      optionsViewBuilder:
                                          (context, Function(String) onSelected, options) {
                                            return Align(
                                              alignment: Alignment.topLeft,
                                              child: Material(
                                                elevation: 4.0,
                                                child: ConstrainedBox(
                                                  constraints:
                                                  const BoxConstraints(maxHeight: 200, maxWidth: 150),
                                                  child: ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    shrinkWrap: true,
                                                    itemCount: options.length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      final String option = options.elementAt(index);
                                                      return InkWell(
                                                        onTap: () {
                                                          onSelected(option);
                                                        },
                                                        child: Container(
                                                          color: Theme.of(context).focusColor,
                                                          padding: const EdgeInsets.all(16.0),
                                                          child: Text(option),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            );

                                      },
                                      onSelected: (String selection) {
                                        //debugPrint('You just selected $selection');
                                        setState((){
                                          bet_patties = "";
                                        });
                                        betpatties(panelgroups);
                                        //print(bet_patties);
                                      },
                                      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                                        this.controller = controller;

                                        return TextFormField(
                                          controller: controller,
                                          focusNode: focusNode,
                                          onEditingComplete: onEditingComplete,
                                          decoration: ThemeHelper().customInputDecoration('Enter Panel',""),
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          //controller: left_digit,
                                          maxLength: 3,
                                          style: ThemeHelper().textStyle(),
                                          onChanged: (input){
                                            setState((){
                                              bet_patties = "";
                                            });
                                            betpatties(panelgroups);
                                          },
                                          //inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                          validator: (input) => (input!.isEmpty)
                                              ? "Enter Panel"
                                              : null,
                                        );
                                      },
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

                            GradientText("Bet Patties : " + bet_patties, ),
                            SizedBox(height: 340,),
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
                              getlist(panelgroups,"1");
                              //getlist(doublepanel,"2");
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
                                              image: "tow_digit_panel.png",
                                              game_name: "2Dgt Panel",
                                              total: total.toString(),))
                                ).then((_) => resetvariables());
                              }
                            }
                            else if(controller.text == "")
                            {
                              var snackBar = SnackBar(content: Text("Please Enter Panel" + controller.text,style: TextStyle(color: Colors.black),),backgroundColor:HexColor("#FEDB87"));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                            else if(controller.text != "" && amount.text != "")
                            {
                              var snackBar = SnackBar(content: Text("No Panels Created Using Given Digits " + itemDetail.length.toString(),style: TextStyle(color: Colors.black),),backgroundColor:HexColor("#FEDB87"));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                            else if(amount.text == "")
                            {
                              var snackBar = SnackBar(content: Text("Please Enter Amount",style: TextStyle(color: Colors.black),),backgroundColor:HexColor("#FEDB87"));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                            else
                            {
                              var snackBar = SnackBar(content: Text("Something Went Wrong",style: TextStyle(color: Colors.black),),backgroundColor:HexColor("#FEDB87"));
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
  betpatties(listdata)
  {
    var getgroup = [];
    var other = controller.text;
    try
    {
      listdata.forEach((value) {
        value.forEach((panna) {
          if (value.contains(other)) {
            getgroup.add(value);
            throw "";
          }
        });
      });
    } catch (e) {
      // leave it
    }

    int i = 0;
    String bp = "";
    getgroup[0].forEach((value) {
      bp = (i == 0) ?  value : bet_patties + ", " + value;
      setState((){
        bet_patties = bp;
        i = i +1;
      });
    });
  }
  getlist(listdata,type)
  {
    var getgroup = [];
    var other = controller.text;
    try
    {
        listdata.forEach((value) {
          value.forEach((panna) {
            if (value.contains(other)) {
              getgroup.add(value);
              throw "";
            }
          });
        });
    } catch (e) {
      // leave it
    }
    getgroup[0].forEach((value) {
      takeNumber(amount.text.toString() ,value,"13");
    });
  }
}
class Item {
  final String id;
  Item(this.id);
}