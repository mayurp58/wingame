import 'package:wingame/gameplay/submit_bid.dart';
import 'package:wingame/widgets/GradientText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wingame/globalvar.dart' as globals;
import '../common/theme_helper.dart';
import '../widgets/appbar.dart';
import 'gameplay_header.dart';
class HalfSangam extends StatefulWidget {
  final String? title;
  final String? session;
  final int id;
  final String? date;
  const HalfSangam({Key? key, this.title, this.session, required this.id,required this.date}) : super(key: key);
  @override
  State<HalfSangam> createState() => _HalfSangamState();
}

class _HalfSangamState extends State<HalfSangam> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  List<Map<String, dynamic>> itemDetail = [];
  bool isApiCallProcess = false;
  int total = 0;
  final left_digit = TextEditingController();
  final amount = TextEditingController();
  static const List<String> all_panna = <String>["128", "137", "236", "678", "123", "268", "367", "178", "129", "147", "246", "679", "124", "179", " 467", "269", "120", "157", "256", " 670", "170", "567", "125", "260", "130", "158", "680", "356", "180", "568", "135", "360", "140", "159", "456", "690", "190", "569", "145", "460", "245", "240", "345", "890", "139", "189", "789", "379", "230", "280", "290", "259", "390", "458", "148", "468", "347", "478", "258", "235", "470", "457", "480", "340", "346", "369", "248", "289", "357", "578", "579", "790", "589", "359", "689", "134", "239", "234", "780", "370", "380", "880", "570", "250", "247", "477", "167", "117", "249", "244", "335", "330", "255", "557", "779", "279", "112", "126", "799", "299", "588", "358", "200", "700", "229", "224", "266", "667", "447", "479", "489", "448", "138", "368", "445", "459", "149", "144", "348", "334", "344", "899", "336", "133", "599", "990", "446", "199", "339", "488", "399", "349", "688", "188", "490", "440", "699", "469", "889", "389", "100", "600", "660", "115", "300", "800", "400", "900", "168", "136", "155", "556", "110", "566", "580", "558", "455", "559", "113", "668", "560", "150", "156", "160", "355", "350", "590", "450", "366", "118", "146", "114", "778", "278", "337", "378", "220", "225", "122", "677", "669", "466", "237", "223", "238", "288", "770", "577", "177", "127", "119", "169", "228", "377", "788", "233", "257", "270", "267", "226", "227", "277", "499", "449", "166", "116", "338", "388", "500", "550", "777", "222", "444", "999", "111", "666", "888", "333", "555", "000"];
  static const List<String> all_digits = <String>["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
  bool visible1 = true;
  bool visible2 = false;
  late TextEditingController controller;
  late TextEditingController controller2;
  Map<String, String> map1 = {};

  void takeNumber(String inputamount, String bracket,String type_id) {
    try {
      Map<String, dynamic> json = {"game_provider_id": widget.id,"game_type_id" : type_id ,"game_brackets":bracket,"game_bidding_points":inputamount,"game_date":widget.date,"game_session":widget.session};
      //int item = int.parse(bracket);
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
            GameplayHeader(id:widget.id.toString(),title: widget.title,type: "Half Sangam",session: "",date: widget.date,),
            //////////////////////////////Heade Ends Here////////////////////////////
            ElevatedButton(
                style: ThemeHelper().separatebuttonStyle_bordered(),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                  child: GradientText('Change Pattern'.toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: HexColor("#FEDB87")),),
                ),
                onPressed: () {
                  if(visible1==true)
                    {
                      setState(() {
                        visible1 = false;
                        visible2 = true;
                      });
                    }
                  else
                  {
                    setState(() {
                      visible2 = false;
                      visible1 = true;
                    });
                  }
                }
            ),
            Visibility(visible: visible1 , child: typeOne(context)),
            Visibility(visible: visible2 , child: typeTwo(context)),
            SizedBox(
              height: 400,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 400,
                        width: double.infinity,
                        child: ListView.builder(
                          itemCount: map1.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, position) {
                            // Youyr Code
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(3,8,3,8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(map1.keys.elementAt(position),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                                    Text(map1.values.elementAt(position),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                                    InkWell(
                                      child: Icon(Icons.delete, color: Colors.red,),
                                      onTap: (){
                                        setState(() {
                                          map1.remove(map1.keys.elementAt(position));
                                        });
                                      },
                                    )

                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    ],
                  ),
                ),
            )
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = (visible1==true) ? _formKey.currentState : _formKey2.currentState;
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
      child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      decoration: ThemeHelper().buttonBoxDecoration(context),
                      child :
                      Row(
                        children: [

                          ElevatedButton(
                              style: ThemeHelper().separatebuttonStyle_filled(),
                              child: Text('Submit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),


                              onPressed: (){
                                //print(controller.text + "-" + controller2.text);
                                if (validateAndSave() || map1.length > 0)
                                {
                                  map1.forEach((key, value) {
                                    //print(value + key);
                                    takeNumber(value, key, "6");
                                  });
                                  //print(itemDetail);
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
                                                  image: "half_sangam.png",
                                                  game_name: "Half Sangam",
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
                          ),


                        ],
                      ),
                  ),
                  Container(
                    decoration: ThemeHelper().buttonBoxDecoration(context),
                    child :
                    Row(
                      children: [
                        ElevatedButton(
                            style: ThemeHelper().separatebuttonStyle_filled(),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Text('Add', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                            ),
                            onPressed: (){
                              if(validateAndSave()) {
                                var txt = controller.text + "-" +
                                    controller2.text;

                                setState(() {
                                  map1[txt] = amount.text.toString();
                                  controller.text = "";
                                  controller2.text = "";
                                  amount.text = "";
                                });
                                //print(map1);
                              }
                            }
                        )
                      ],
                    ),
                  )
                ],
              ),



    );
  }
  resetvariables() {
    itemDetail = [];
    total = 0;
  }

  getlist(listdata,type) {
  }

  typeOne(BuildContext context) {
   return Container(
      //height: ,
      width: double.infinity,
      child: Card(
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
                    SizedBox(height: 5,),
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
                              },
                              fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                                this.controller = controller;

                                return TextFormField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  onEditingComplete: onEditingComplete,
                                  decoration: ThemeHelper().customInputDecoration('Open Panna',""),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  //controller: left_digit,
                                  maxLength: 3,
                                  style: ThemeHelper().textStyle(),
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
                            child: Autocomplete<String>(

                              optionsBuilder: (TextEditingValue textEditingValue) {
                                if (textEditingValue.text == '') {
                                  return const Iterable<String>.empty();
                                }
                                return all_digits.where((String option) {
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
                              },
                              fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                                this.controller2 = controller;

                                return TextFormField(
                                  controller: controller2,
                                  focusNode: focusNode,
                                  onEditingComplete: onEditingComplete,
                                  decoration: ThemeHelper().customInputDecoration('Close Digit',""),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  //controller: left_digit,
                                  maxLength: 1,
                                  style: ThemeHelper().textStyle(),
                                  //inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                  validator: (input) => (input!.isEmpty)
                                      ? "Enter Digit"
                                      : null,
                                );
                              },
                            ),
                          ),
                        ),



                      ],),
                    SizedBox(height: 15,),
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
                    SizedBox(height: 5,),
                  ],
                ),





              ),

            ),

          ],
        ),
      ),
    );
  }

  typeTwo(BuildContext context) {
    return Container(
      //height: ,
      width: double.infinity,
      child: Card(
        elevation: 20, //shadow elevation for card
        margin: EdgeInsets.all(8),
        shadowColor: HexColor("#FEDB87"),
        child: Column(
          children: [

            Form(
              key: _formKey2,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    SizedBox(height: 5,),
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
                                return all_digits.where((String option) {
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
                              },
                              fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                                this.controller = controller;

                                return TextFormField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  onEditingComplete: onEditingComplete,
                                  decoration: ThemeHelper().customInputDecoration('Open Digit',""),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  //controller: left_digit,
                                  maxLength: 1,
                                  style: ThemeHelper().textStyle(),
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
                              },
                              fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                                this.controller2 = controller;

                                return TextFormField(
                                  controller: controller2,
                                  focusNode: focusNode,
                                  onEditingComplete: onEditingComplete,
                                  decoration: ThemeHelper().customInputDecoration('Close Panna',""),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  //controller: left_digit,
                                  maxLength: 3,
                                  style: ThemeHelper().textStyle(),
                                  //inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                  validator: (input) => (input!.isEmpty)
                                      ? "Enter Digit"
                                      : null,
                                );
                              },
                            ),
                          ),
                        ),



                      ],),
                    SizedBox(height: 15,),
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
                    SizedBox(height: 5,),
                  ],
                ),

              ),

            ),

          ],
        ),
      ),
    );
  }
}
class Item {
  final String id;
  Item(this.id);
}
