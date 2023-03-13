import 'package:wingame/starline/starline_gameplay_header.dart';
import 'package:wingame/starline/submit_starline_bid.dart';
import 'package:wingame/widgets/GradientText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wingame/globalvar.dart' as globals;
import '../common/theme_helper.dart';
import '../widgets/appbar.dart';
class StarlineCyclePatti extends StatefulWidget {
  final String? title;
  final String? session;
  final int id;
  final String? date;
  const StarlineCyclePatti({Key? key, this.title, this.session, required this.id,required this.date}) : super(key: key);

  @override
  State<StarlineCyclePatti> createState() => _StarlineCyclePattiState();
}

class _StarlineCyclePattiState extends State<StarlineCyclePatti> {
  Map cycle = {};
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> itemDetail = [];
  bool isApiCallProcess = false;
  int total = 0;
  String bet_patties = "";
  final left_digit = TextEditingController();
  final amount = TextEditingController();
  static const List<String> all_panna = <String>["00","10","11","12","13","14","15","16","17","18","19","20","22","23","24","25","26","27","28","29","30","33","34","35","36","37","38","39","40","44","45","46","47","48","49","50","55","56","57","58","59","60","66","67","68","69","70","77","78","79","80","88","89","90","99"];
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    setdigits();
  }
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
            StarlineGameplayHeader(id:widget.id.toString(),title: widget.title,type: "Cycle Patti",session: widget.session,date: widget.date,),
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
                                        betpatties(selection);
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
                                            betpatties(input);
                                          },
                                          //inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                          validator: (input) => (input!.isEmpty)
                                              ? "Enter Digit"
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
                            SizedBox(height: 40,),
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
                              getlist(controller.text,"13");
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
                                              image: "cycle_patti.png",
                                              game_name: "Cycle Patti",
                                              total: total.toString(),))
                                ).then((_) => resetvariables());
                              }
                            }
                            else if(itemDetail.length == 0)
                            {
                              var snackBar = SnackBar(content: Text("No Panels Created Using Given Digits"),backgroundColor:HexColor("#FEDB87"));
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
  }
  betpatties(listdata)
  {
    //print(listdata);
    int i = 0;
    String bp = "";
    cycle[int.parse(listdata)].forEach((value) {
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
    cycle[int.parse(listdata)].forEach((value) {
      takeNumber(amount.text.toString() ,value,"13");
    });
  }

  setdigits()
  {
    setState((){

      cycle[00] = {"100","200","300","400","500","600","700","800","900","000"};
      cycle[10] = {"100","110","120","130","140","150","160","170","180","190"};
      cycle[11] = {"110","111","112","113","114","115","116","117","118","119"};
      cycle[12] = {"112","120","122","123","124","125","126","127","128","129"};
      cycle[13] = {"113","123","130","133","134","134","136","137","138","139"};
      cycle[14] = {"114","124","134","140","144","145","146","147","148","149"};
      cycle[15] = {"115","125","135","145","150","155","156","157","158","159"};
      cycle[16] = {"116","126","136","146","156","160","166","167","168","169"};
      cycle[17] = {"117","127","137","147","157","167","170","177","178","179"};
      cycle[18] = {"118","128","138","148","158","168","178","180","188","189"};
      cycle[19] = {"119","129","139","149","159","169","179","189","190","199"};
      cycle[20] = {"120","200","220","230","240","250","260","270","280","290"};
      cycle[22] = {"122","220","223","224","225","226","227","228","229","222"};
      cycle[23] = {"123","230","233","234","235","236","237","238","239","223"};
      cycle[24] = {"124","240","244","245","246","247","248","249","224","234"};
      cycle[25] = {"125","250","255","256","257","258","259","225","235","245"};
      cycle[26] = {"126","260","266","267","268","269","226","236","246","256"};
      cycle[27] = {"127","270","277","278","279","227","237","247","257","267"};
      cycle[28] = {"128","280","288","289","228","238","248","258","268","278"};
      cycle[29] = {"129","290","299","229","239","249","259","269","279","289"};
      cycle[30] = {"130","230","300","330","340","350","360","370","380","390"};
      cycle[33] = {"133","233","333","334","335","336","337","338","339","330"};
      cycle[34] = {"134","234","334","340","344","345","346","347","348","349"};
      cycle[35] = {"135","350","355","335","345","235","356","357","358","359"};
      cycle[36] = {"136","360","366","336","346","356","367","368","369","236"};
      cycle[37] = {"137","370","377","337","347","357","367","378","379","237"};
      cycle[38] = {"138","380","388","238","338","348","358","368","378","389"};
      cycle[39] = {"139","390","399","349","359","369","379","389","239","339"};
      cycle[40] = {"140","240","340","400","440","450","460","470","480","490"};
      cycle[44] = {"144","244","344","440","449","445","446","447","448","444"};
      cycle[45] = {"145","245","345","450","456","457","458","459","445","455"};
      cycle[46] = {"146","460","446","467","468","469","246","346","456","466"};
      cycle[47] = {"147","470","447","478","479","247","347","457","467","477"};
      cycle[48] = {"148","480","489","248","348","448","488","458","468","478"};
      cycle[49] = {"149","490","499","449","459","469","479","489","249","349"};
      cycle[50] = {"500","550","150","250","350","450","560","570","580","590"};
      cycle[55] = {"155","556","557","558","559","255","355","455","555","550"};
      cycle[56] = {"156","556","567","568","569","356","256","456","560","566"};
      cycle[57] = {"157","257","357","458","557","578","579","570","457","577"};
      cycle[58] = {"158","558","568","578","588","589","580","258","358","458"};
      cycle[59] = {"159","259","359","459","559","569","579","589","590","599"};
      cycle[60] = {"600","160","260","360","460","560","660","670","680","690"};
      cycle[66] = {"660","667","668","669","666","166","266","366","466","566"};
      cycle[67] = {"670","167","267","367","467","567","667","678","679","677"};
      cycle[68] = {"680","688","668","678","168","268","368","468","568","689"};
      cycle[69] = {"690","169","269","369","469","569","669","679","689","699"};
      cycle[70] = {"700","170","270","370","470","570","670","770","780","790"};
      cycle[77] = {"770","177","277","377","477","577","677","778","779","777"};
      cycle[78] = {"178","278","378","478","578","678","778","788","789","780"};
      cycle[79] = {"179","279","379","479","579","679","779","789","799","790"};
      cycle[80] = {"180","280","380","480","580","680","780","880","800","890"};
      cycle[88] = {"188","288","388","488","588","688","788","889","888","880"};
      cycle[89] = {"189","289","389","489","589","689","789","889","890","899"};
      cycle[90] = {"900","190","290","390","490","590","690","790","890","990"};
      cycle[99] = {"199","299","399","499","599","699","799","899","990","999"};
    });
  }
}
class Item {
  final String id;
  Item(this.id);
}