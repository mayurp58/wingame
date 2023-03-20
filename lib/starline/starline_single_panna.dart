import 'package:wingame/starline/starline_gameplay_header.dart';
import 'package:wingame/starline/submit_starline_bid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wingame/globalvar.dart' as globals;
import '../common/theme_helper.dart';
import '../widgets/appbar.dart';
class StarlineSinglePanna extends StatefulWidget {
  final String? title;
  final String? session;
  final int id;
  final String? date;
  const StarlineSinglePanna({Key? key, this.title, this.session, required this.id,required this.date}) : super(key: key);

  @override
  State<StarlineSinglePanna> createState() => _StarlineSinglePannaState();
}

class _StarlineSinglePannaState extends State<StarlineSinglePanna> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<StarlineSinglePanna>{
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Item> itemList_one = [Item("137"),Item("128"),Item("146"),Item("236"),Item("245"),Item("290"),Item("380"),Item("470"),Item("489"),Item("560"),Item("678"),Item("579")];
  List<Item> itemList_two = [Item("129"),Item("138"),Item("147"),Item("156"),Item("237"),Item("246"),Item("345"),Item("390"),Item("480"),Item("570"),Item("589"),Item("679")];
  List<Item> itemList_three = [Item("120"),Item("139"),Item("148"),Item("157"),Item("238"),Item("247"),Item("256"),Item("346"),Item("490"),Item("580"),Item("689"),Item("670")];
  List<Item> itemList_four = [Item("130"),Item("149"),Item("158"),Item("167"),Item("239"),Item("248"),Item("257"),Item("347"),Item("356"),Item("590"),Item("680"),Item("789")];
  List<Item> itemList_five = [Item("140"),Item("159"),Item("168"),Item("230"),Item("249"),Item("258"),Item("267"),Item("348"),Item("357"),Item("456"),Item("690"),Item("780")];
  List<Item> itemList_six = [Item("123"),Item("150"),Item("169"),Item("178"),Item("240"),Item("259"),Item("268"),Item("349"),Item("358"),Item("367"),Item("457"),Item("790")];
  List<Item> itemList_seven = [Item("124"),Item("160"),Item("179"),Item("250"),Item("269"),Item("278"),Item("340"),Item("359"),Item("368"),Item("458"),Item("467"),Item("890")];
  List<Item> itemList_eight = [Item("125"),Item("134"),Item("170"),Item("189"),Item("260"),Item("279"),Item("350"),Item("369"),Item("378"),Item("459"),Item("468"),Item("567")];
  List<Item> itemList_nine = [Item("126"),Item("135"),Item("180"),Item("234"),Item("270"),Item("289"),Item("360"),Item("379"),Item("450"),Item("469"),Item("478"),Item("568")];
  List<Item> itemList_zero = [Item("127"),Item("136"),Item("145"),Item("190"),Item("235"),Item("280"),Item("370"),Item("389"),Item("460"),Item("479"),Item("569"),Item("578")];

  List<Map<String, dynamic>> itemDetail = [];
  List<Map<String, dynamic>> _values = [];
  bool isApiCallProcess = false;
  int total = 0;
  List<TextEditingController> _controller = List.generate(1000, (i) => TextEditingController());
  Map<String, String> map1 = {};

  void takeNumber(String inputamount, String bracket) {
    try {
      Map<String, dynamic> json = {"game_provider_id": widget.id,"game_type_id" : "1" ,"game_brackets":bracket,"game_bidding_points":inputamount,"game_date":widget.date,"game_session":widget.session};
      int item = int.parse(bracket);
      int amount = int.parse(inputamount);
      setState(() {
        itemDetail.add(json);
        total = total + amount;
      });
    } on FormatException {}
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 10,
      child: Scaffold(
        backgroundColor: HexColor(globals.color_background),
        appBar: PreferredSize(
            preferredSize: const Size(double.infinity, kToolbarHeight),
            child :  Appbar()),
        bottomNavigationBar: submitButtonWidget(context),
        body: Form(
          key: _formKey,
          child : Column(
            children: [
              StarlineGameplayHeader(id:widget.id.toString(),title: widget.title,type: "Single Pana",session: widget.session,date: widget.date,),
              //////////////////////////////Heade Ends Here////////////////////////////
              Container(
                //color: HexColor("#000000"),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: GradientBoxBorder(
                    gradient: LinearGradient(colors: [HexColor(globals.color_pink),HexColor(globals.color_blue)],),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TabBar(
                    isScrollable: true,
                    unselectedLabelColor: Colors.white,
                    labelColor: Colors.white,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [HexColor(globals.color_pink),HexColor(globals.color_blue)]),
                        borderRadius: BorderRadius.circular(10),
                        // border: const GradientBoxBorder(
                        //   gradient: LinearGradient(colors: [Color(0xffFEDB87),Color(0xffBD7923),Color(0xffFEDB87)],),
                        //   width: 1,
                        // ),
                        color: Colors.black),
                    tabs: [
                      Tab(
                        child: Text('1'),
                      ),
                      Tab(
                        child: Text('2'),
                      ),
                      Tab(
                        child: Text('3'),
                      ),
                      Tab(
                        child: Text('4'),
                      ),
                      Tab(
                        child: Text('5'),
                      ),
                      Tab(
                        child: Text('6'),
                      )
                      ,
                      Tab(
                        child: Text('7'),
                      )
                      ,
                      Tab(
                        child: Text('8'),
                      )
                      ,
                      Tab(
                        child: Text('9'),
                      )
                      ,
                      Tab(
                        child: Text('0'),
                      )
                    ]),
              ),
              Expanded(
                child :
                TabBarView(
                  children: <Widget>[


                    Container(child: showsinglepanna(context,itemList_one),),
                    Container(child: showsinglepanna(context,itemList_two),),
                    Container(child: showsinglepanna(context,itemList_three),),
                    Container(child: showsinglepanna(context,itemList_four),),
                    Container(child: showsinglepanna(context,itemList_five),),
                    Container(child: showsinglepanna(context,itemList_six),),
                    Container(child: showsinglepanna(context,itemList_seven),),
                    Container(child: showsinglepanna(context,itemList_eight),),
                    Container(child: showsinglepanna(context,itemList_nine),),
                    Container(child: showsinglepanna(context,itemList_zero),),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showsinglepanna(BuildContext context,List<Item> itemList)
  {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
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
            Padding(
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
                    //total = total + 1;
                    int panna = int.parse(item.id.toString());
                    return TextFormField(
                      decoration: ThemeHelper().gameplayInputDecoration('Amount', item.id.toString()),
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      controller: _controller[panna],
                      style: ThemeHelper().textStyle(),
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      //onSaved: (input) => (input!="") ? takeNumber(_controller[panna].text, item.id.toString()) : "",
                      //onEditingComplete: (){ takeNumber(_controller[panna].text, item.id.toString()); },
                      onChanged: (val)=>{ (int.parse(val) >= 10) ? map1[item.id.toString()] = val : null },
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



          ],
        ),
      ),
    );
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
                            map1.forEach((key, value) {
                              takeNumber(value,key);
                              _controller[int.parse(key)].text = "";
                              //print('Key = $key : Value = $value');
                            });
                            //print(_controller);
                            if (validateAndSave() && itemDetail.length > 0)
                            {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SubmitStarlineBid(title: widget.title,session:widget.session,id: widget.id,date: widget.date,itemDetail: itemDetail,image: "single_panna.png",game_name: "Single Panna",total: total.toString(),))
                              ).then((_) => resetvariables());
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
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  bool get wantKeepAlive => true;
}
class Item {
  final String id;
  Item(this.id);
}