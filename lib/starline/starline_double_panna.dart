import 'package:wingame/starline/starline_gameplay_header.dart';
import 'package:wingame/starline/submit_starline_bid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wingame/globalvar.dart' as globals;
import '../common/theme_helper.dart';
import '../widgets/appbar.dart';
class StarlineDoublePanna extends StatefulWidget {
  final String? title;
  final String? session;
  final int id;
  final String? date;
  const StarlineDoublePanna({Key? key, this.title, this.session, required this.id,required this.date}) : super(key: key);

  @override
  State<StarlineDoublePanna> createState() => _StarlineDoublePannaState();
}

class _StarlineDoublePannaState extends State<StarlineDoublePanna> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<StarlineDoublePanna>{
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Item> itemList_one = [Item("119"),Item("155"),Item("227"),Item("335"),Item("344"),Item("399"),Item("588"),Item("669"),Item("100")];
  List<Item> itemList_two = [Item("110"),Item("228"),Item("255"),Item("336"),Item("499"),Item("660"),Item("688"),Item("778"),Item("200")];
  List<Item> itemList_three = [Item("166"),Item("229"),Item("337"),Item("355"),Item("445"),Item("599"),Item("779"),Item("788"),Item("300")];
  List<Item> itemList_four = [Item("112"),Item("220"),Item("266"),Item("338"),Item("446"),Item("455"),Item("699"),Item("770"),Item("400")];
  List<Item> itemList_five = [Item("113"),Item("122"),Item("177"),Item("339"),Item("366"),Item("447"),Item("799"),Item("889"),Item("500")];
  List<Item> itemList_six = [Item("114"),Item("277"),Item("330"),Item("448"),Item("466"),Item("556"),Item("880"),Item("899"),Item("600")];
  List<Item> itemList_seven = [Item("115"),Item("133"),Item("188"),Item("223"),Item("377"),Item("449"),Item("557"),Item("566"),Item("700")];
  List<Item> itemList_eight = [Item("116"),Item("224"),Item("233"),Item("288"),Item("440"),Item("477"),Item("558"),Item("990"),Item("800")];
  List<Item> itemList_nine = [Item("117"),Item("144"),Item("199"),Item("225"),Item("388"),Item("559"),Item("577"),Item("667"),Item("900")];
  List<Item> itemList_zero = [Item("118"),Item("226"),Item("244"),Item("299"),Item("334"),Item("488"),Item("668"),Item("677"),Item("550")];

  List<Map<String, dynamic>> itemDetail = [];
  List<Map<String, dynamic>> _values = [];
  bool isApiCallProcess = false;
  int total = 0;
  List<TextEditingController> _controller = List.generate(1000, (i) => TextEditingController());
  Map<String, String> map1 = {};

  void takeNumber(String inputamount, String bracket) {
    try {
      Map<String, dynamic> json = {"game_provider_id": widget.id,"game_type_id" : "2" ,"game_brackets":bracket,"game_bidding_points":inputamount,"game_date":widget.date,"game_session":widget.session};
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
              StarlineGameplayHeader(id:widget.id.toString(),title: widget.title,type: "Double Pana",session: widget.session,date: widget.date,),
              //////////////////////////////Heade Ends Here////////////////////////////
              Container(
                //color: HexColor(globals.color_blue),
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
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [HexColor(globals.color_pink),HexColor(globals.color_blue)]),
                        borderRadius: BorderRadius.circular(10),
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
                                      builder: (context) => SubmitStarlineBid(title: widget.title,session:widget.session,id: widget.id,date: widget.date,itemDetail: itemDetail,image: "double_panna.png",game_name: "Double Panna",total: total.toString(),))
                              ).then((_) => resetvariables());
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