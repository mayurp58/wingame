import 'package:wingame/loader.dart';
import 'package:wingame/pages/bid_history.dart';
import 'package:wingame/pages/funds_requests.dart';
import 'package:wingame/pages/transaction_history.dart';
import 'package:wingame/widgets/appbar.dart';
import 'package:wingame/widgets/navigationbar.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wingame/globalvar.dart' as globals;
import 'landing_page.dart';
class HistoryTab extends StatefulWidget {
  const HistoryTab({Key? key}) : super(key: key);

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> with SingleTickerProviderStateMixin{
  bool isApiCallProcess = false;
  late TabController _tabController;
  final fieldText = TextEditingController();

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
    _tabController.dispose();
  }
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    //print("BACK BUTTON!"); // Do some stuff.
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LandingPage()),
    );
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }
  @override
  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(globals.color_background),
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child :  Appbar()),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [


            // give the tab bar a height [can change hheight to preferred height]
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(
                  25.0,
                ),

              ),
              child: TabBar(
                controller: _tabController,
                // give the indicator a decoration (color and border radius)
                indicator: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [HexColor(globals.color_blue),HexColor(globals.color_pink)],),
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                  color: HexColor(globals.color_blue),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,

                tabs: [
                  // first tab [you can add an icon using the icon property]
                  Tab(
                    child: Center(
                      child: Text(
                        "Bid\nHistory", textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  // second tab [you can add an icon using the icon property]
                  Tab(
                    child: Center(
                      child: Text(
                        "Transaction\nHistory", textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // third tab [you can add an icon using the icon property]
                  Tab(
                    child: Center(
                      child: Text(
                        "Funds\nRequests", textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // tab bar view here
            SizedBox(height: 10,),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // first tab bar view widget
                  BidHistory(),
                  // second tab bar view widget
                  TransactionHistory(),
                  // third tab bar view widget
                  FundRequests()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}