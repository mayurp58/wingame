import 'package:wingame/globalvar.dart' as globals;
import 'package:wingame/loader.dart';
import 'package:wingame/pages/bid_history_detail.dart';
import 'package:wingame/widgets/GradientText.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:hexcolor/hexcolor.dart';
class BidHistory extends StatefulWidget {
  const BidHistory({Key? key}) : super(key: key);

  @override
  State<BidHistory> createState() => _BidHistoryState();
}

class _BidHistoryState extends State<BidHistory> {
  List<dynamic> marketnames = globals.marketnames;
  bool isApiCallProcess = false;

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    //print("BACK BUTTON!"); // Do some stuff.
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
      body: ListView.builder(

        itemCount: marketnames.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  border: const GradientBoxBorder(
                    gradient: LinearGradient(colors: [Color(0xffff66c4),Color(0xff514ed8),Color(0xffff66c4)],),
                    width: 1,
                  ),

                  borderRadius: BorderRadius.circular(8),
                ),
                //padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                //margin: EdgeInsets.fromLTRB(20, 70, 20, 10),
                child: ListTile(
                  tileColor: HexColor(globals.color_background),
                  title: Center(
                    child: GradientText(marketnames[index]["prov_name"], style: TextStyle(fontWeight: FontWeight.w600,color: HexColor(globals.color_blue))
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BidDetails(title : marketnames[index]["prov_name"],prov_id: marketnames[index]["prov_id"],)),
                    );
                    //print(marketnames[index]["prov_name"]);
                    //Go to the next screen with Navigator.push
                  },

                )
            ),
            ),
          );
        },
      ),
    );
  }
}
