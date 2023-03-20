import 'package:hexcolor/hexcolor.dart';
import 'package:wingame/globalvar.dart' as globals;
import 'package:wingame/pages/change_mpin.dart';
import 'package:wingame/pages/game_rates.dart';
import 'package:wingame/pages/history_tabs.dart';
import 'package:wingame/pages/how_to_play.dart';
import 'package:wingame/pages/landing_page.dart';
import 'package:wingame/pages/login_page.dart';
import 'package:wingame/pages/profile_page.dart';
import 'package:wingame/pages/wallet.dart';
import 'package:wingame/widgets/GradientText.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class AppDrawer extends StatelessWidget {

  AppDrawer({Key? key}) : super(key: key);
  String mob = globals.mobile_number != "" ? globals.mobile_number.toString() : "";


  void logout() async
  {
    /*SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('token');
    await prefs.remove('mobile');
    await Future.delayed(Duration(seconds: 2));*/
  }

  _launchWhatsapp() async {
    var whatsapp = globals.support_number.toString();
    var whatsappAndroid = Uri.parse(Uri.encodeFull("whatsapp://send?phone="+whatsapp));
    //await launchUrl(whatsappAndroid);
    if (!await launchUrl(whatsappAndroid)) {
      throw 'Could not Open Whatsapp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Drawer(
        backgroundColor: HexColor(globals.color_background),
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: HexColor(globals.color_background),
              ),
              child: Image(
                image: AssetImage("assets/logo.png"),
              ),
            ),
        /* Container(
           padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
           decoration: BoxDecoration(
             gradient: LinearGradient(
                 begin: Alignment.topRight,
                 end: Alignment.topLeft,
                 colors: <Color>[
                   HexColor(globals.color_blue),
                   HexColor("#BD7923"),
                   HexColor(globals.color_blue),]),
           ),
           child: Text("Welcome To wingame",style: TextStyle(fontWeight: FontWeight.w400,color: Colors.white)),
         ),*/
          /*  SizedBox(
              height: 160,
              child: DrawerHeader(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/banner.png"),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.center,
                    )
                ),
                child: Text("")
              ),
            ),*/
            ListTile(
              title: GradientText("Welcome : " + mob,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600,fontSize: 20),
              ),
            ),
            // ListTile(
            //   leading: Icon(
            //     Icons.home,
            //     color: Colors.white,
            //   ),
            //   title: const Text('Home',
            //   style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            //   ),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => LandingPage()),
            //     );
            //   },
            // ),
            // ListTile(
            //   leading: Icon(
            //     Icons.person,
            //     color: Colors.white,
            //   ),
            //   title: const Text('My Profile',
            //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            //   ),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => ProfilePage()),
            //     );
            //   },
            // ),
            // ListTile(
            //   leading: Icon(
            //     Icons.wallet,
            //     color: Colors.white,
            //   ),
            //   title: const Text('Wallet',
            //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            //   ),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => Wallet()),
            //     );
            //   },
            // ),
            // ListTile(
            //   leading: Icon(
            //     Icons.history,
            //     color: Colors.white,
            //   ),
            //   title: const Text('History',
            //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            //   ),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => HistoryTab()),
            //     );
            //   },
            // ),
            ListTile(
              leading: Icon(
                Icons.password_sharp,
                color: Colors.white,
              ),
              title: const Text('Change Mpin',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangeMpin()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
              title: const Text('How To Play',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HowtoPlay()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.currency_rupee,
                color: Colors.white,
              ),
              title: const Text('Game Rates',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameRates()),
                );
              },
            ),
           /* ListTile(
              leading: Icon(
                Icons.newspaper,
                color: Colors.white,
              ),
              title: const Text('Notice Board',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NoticeBoard()),
                );
              },
            ),*/
            // ListTile(
            //   leading: Icon(
            //     FontAwesomeIcons.whatsapp,
            //     color: Colors.green,
            //   ),
            //   title: const Text('Whatsapp Support',
            //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            //   ),
            //   onTap: () {
            //     _launchWhatsapp();
            //   },
            // ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title: const Text('Logout',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context);
                logout();
                Navigator.of(context).pushAndRemoveUntil(
                  // the new route
                  MaterialPageRoute(
                    builder: (BuildContext context) => LoginPage(),
                  ),

                  // this function should return true when we're done removing routes
                  // but because we want to remove all other screens, we make it
                  // always return false
                      (Route route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

