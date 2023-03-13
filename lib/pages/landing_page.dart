import 'package:wingame/globalvar.dart' as globals;
import 'package:wingame/pages/chat.dart';
import 'package:wingame/pages/main_markets.dart';
import 'package:wingame/pages/notification.dart';
import 'package:wingame/pages/profile_page.dart';
import 'package:wingame/pages/starline_markets.dart';
import 'package:wingame/pages/superjodi.dart';
import 'package:wingame/pages/wallet.dart';
import 'package:wingame/widgets/navigationbar.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marquee/marquee.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/GradientText.dart';
import 'history_tabs.dart';

class LandingPage extends StatefulWidget {
  final String? tabstate;
  const LandingPage({Key? key, this.tabstate}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with TickerProviderStateMixin {
  late TabController _controller;
  int _selectedIndex = 0;
  int back_count = 0;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
    _controller.animateTo((globals.tabval));
    globals.tabval = 0;
    back_count = 0;
    BackButtonInterceptor.add(myInterceptor, zIndex:2, name:"Landing", context: context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    showExitPopup;
    //BackButtonInterceptor.remove(myInterceptor);
    BackButtonInterceptor.removeByName("Landing");

  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    BackButtonInterceptor.removeAll();
    if (stopDefaultButtonEvent) return false;
    // If a dialog (or any other route) is open, don't run the interceptor.
    if (info.ifRouteChanged(context)) return false;
    //print("BACK BUTTON!"); // Do some stuff.
    back_count = back_count + 1;
    showExitPopup;
    return false;
  }

  Future<bool> showExitPopup() async {
    return await showDialog(context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              decoration: BoxDecoration(
                  color: HexColor(globals.color_background),
                  borderRadius: BorderRadius.circular(20.0),      // Radius of the border
                  border: Border.all(
                    color: HexColor(globals.color_pink),
                    width: 3,
                    // Color of the border
                  )
              ),
              height: 350,
              width: 300,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: GradientText("Do You Want To Exit App?",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                      SizedBox(height: 20,),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            //style : ThemeHelper().filled_square_button(),
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.transparent),side: MaterialStateProperty.all(BorderSide(color: HexColor(globals.color_pink),))),
                              onPressed: (){
                                Navigator.pop(context);
                              }, child: Text("No")),

                          ElevatedButton(
                            //style : ThemeHelper().filled_square_button(),
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.transparent),side: MaterialStateProperty.all(BorderSide(color: HexColor(globals.color_pink),))),
                              onPressed: (){
                                SystemNavigator.pop();
                              }, child: Text("Yes"))
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),
          );
        })??false; //if showDialouge had returned null, then return false
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: HexColor(globals.color_pink),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: HexColor(globals.color_background)
              /*gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    HexColor(globals.color_green),
                    HexColor(globals.color_blue),
                    ]),*/
            ),
          ),
          actions: <Widget>[
            Container(
              color: HexColor(globals.color_background),
              child: Row(
                children: [
                  /*InkWell(
                    child: Icon(Icons.chat_bubble),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Chat()),
                      );
                    },
                  ),
                  SizedBox(width: 20,),*/
                  InkWell(
                    child: Icon(Icons.notifications),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Notifications()),
                      );
                    },
                  ),
                  SizedBox(width: 20,),
                  InkWell(
                    child: Row(
                      children: [
                        Icon(Icons.wallet),
                        SizedBox(width: 4,),
                        Text(globals.balance.toString())
                      ],
                    )
                  ),

                  SizedBox(width: 10,),
                ],
              ),
            ),
          ],
        ),
        drawer: AppDrawer(),
        /*bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'Support',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Bidding',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wallet),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          unselectedItemColor:HexColor("#FEDB87"),
          unselectedLabelStyle: TextStyle(color: HexColor("#FEDB87"), fontSize: 13),
          showUnselectedLabels: true,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,

        ),*/
        body: Container(
          color: HexColor(globals.color_background),
          child: Column(
            children: [
              /*SizedBox(
                height:16,
                child: Marquee(
                  text: globals.congrats.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.green),
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  blankSpace: 30.0,
                  velocity: 50.0,
                  //pauseAfterRound: Duration(seconds: 2),
                  startPadding: 60.0,
                  //accelerationDuration: Duration(seconds: 4),
                  accelerationCurve: Curves.linear,
                  //decelerationDuration: Duration(milliseconds: 2000),
                  decelerationCurve: Curves.easeOut,
                )
              ),*/
              TabBar(
                controller: _controller,
                physics: (globals.tabbarphysics == 1)
                    ? NeverScrollableScrollPhysics()
                    : ScrollPhysics(),
                labelColor: HexColor(globals.color_green),
                unselectedLabelColor: Colors.grey[300],
                indicatorColor: HexColor(globals.color_green),
                labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                tabs: [
                  Tab(
                    text: "Market",
                  ),
                  Tab(
                    text: "Starline",
                  ),
                  Tab(
                    text: "SuperJodi",
                  ),
                ],
              ),
              Expanded(
                  child: TabBarView(
                controller: _controller,
                children: [MainMarkets(), Starlinemarkets(),Superjodi()],
              ))
            ],
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if(index==0)
    {
      /*Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LandingPage()),
      );*/
    }
    if(index==1)
    {
      //print(globals.support_number);
      _launchWhatsapp();
    }
    else if(index==2)
    {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HistoryTab()),
      );
    }
    else if(index==3)
    {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Wallet()),
      );
    }
    else if(index==4)
    {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }
    else
      {

      }
  }

  _launchWhatsapp() async {
    var whatsapp = globals.support_number.toString();
    var whatsappAndroid = Uri.parse(Uri.encodeFull("whatsapp://send?phone="+whatsapp));
    //await launchUrl(whatsappAndroid);
    if (!await launchUrl(whatsappAndroid)) {
      throw 'Could not Open Whatsapp';
    }
  }
}

/*class DoubleBackToCloseWidget extends StatefulWidget {
  final Widget child; // Make Sure this child has a Scaffold widget as parent.

  const DoubleBackToCloseWidget({
    required this.child,
  });

  @override
  _DoubleBackToCloseWidgetState createState() =>
      _DoubleBackToCloseWidgetState();
}

class _DoubleBackToCloseWidgetState extends State<DoubleBackToCloseWidget> {
  int _lastTimeBackButtonWasTapped = 0;
  static const exitTimeInMillis = 2000;

  bool get _isAndroid => Theme.of(context).platform == TargetPlatform.android;

  @override
  Widget build(BuildContext context) {
    if (_isAndroid) {
      return WillPopScope(
        onWillPop: _handleWillPop,
        child: widget.child,
      );
    } else {
      return widget.child;
    }
  }

  Future<bool> _handleWillPop() async {
    final _currentTime = DateTime.now().millisecondsSinceEpoch;

    if (_lastTimeBackButtonWasTapped != null &&
        (_currentTime - _lastTimeBackButtonWasTapped) < exitTimeInMillis) {
      Scaffold.of(context).removeCurrentSnackBar();
      return true;
    } else {
      _lastTimeBackButtonWasTapped = DateTime.now().millisecondsSinceEpoch;
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(
        _getExitSnackBar(context),
      );
      return false;
    }
  }

  SnackBar _getExitSnackBar(
      BuildContext context,
      ) {
    return SnackBar(
      content: Text(
        'Press BACK again to exit!',
      ),
      backgroundColor: Colors.red,
      duration: const Duration(
        seconds: 2,
      ),
      behavior: SnackBarBehavior.floating,
    );
  }
}
*/
