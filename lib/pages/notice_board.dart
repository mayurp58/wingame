import 'package:wingame/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:wingame/loader.dart';
import 'package:wingame/common/api_service.dart';
import 'dart:convert';
import 'dart:async';
import 'package:wingame/widgets/appbar.dart';
import 'package:wingame/widgets/navigationbar.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:hexcolor/hexcolor.dart';
class NoticeBoard extends StatefulWidget {
  const NoticeBoard({Key? key}) : super(key: key);

  @override
  State<NoticeBoard> createState() => _NoticeBoardState();
}

class _NoticeBoardState extends State<NoticeBoard> {
  bool isApiCallProcess = false;
  List<dynamic> noticeboard =[];
  void gethowtoplay() async {
    setState(() {
      isApiCallProcess = true;
    });

    APIService apiService = new APIService();
    apiService
        .apicall_getdata("noticeboard").then((value) {
      Map<String, dynamic> responseJson = json.decode(value);
      var successcode = int.parse(responseJson["success"].toString());
      if (successcode != 0 && successcode != 3)
      {
        final notices = List<dynamic>.from(
          responseJson["data"].map<dynamic>(
                (dynamic item) => item,
          ),
        );
        setState(() {
          isApiCallProcess = false;
          noticeboard = notices;
        });

      }
      else
      {
        setState(() {
          isApiCallProcess = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    gethowtoplay();
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
      opacity: 0.9,
    );
  }
  @override
  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child :  Appbar()),
      drawer: AppDrawer(),
      body: CustomScrollView(
        primary: false,
          slivers: <Widget>[
            SliverPadding(
            padding: const EdgeInsets.all(6),
            sliver: SliverGrid.count(
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              crossAxisCount: 1,
              childAspectRatio: 1/0.9,
              children: noticeboard.map((value){
                return Card(
                  elevation: 10, //shadow elevation for card
                  margin: EdgeInsets.all(8),
                  shadowColor: HexColor("#FEDB87"),
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Column(
                      children: [
                        Center(child:Text(value["title"], style: TextStyle(fontWeight: FontWeight.w600, fontStyle: FontStyle.italic)

                        ),
                        ),
                        SizedBox(height: 10,),
                        Center(child:Text(value["description"], style: TextStyle(fontWeight: FontWeight.w300, fontStyle: FontStyle.italic)

                        ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),),
            ),
          ],
      ),
    );
  }
}