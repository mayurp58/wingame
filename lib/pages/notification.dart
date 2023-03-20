import 'dart:convert';

import 'package:wingame/globalvar.dart' as globals;
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import '../common/api_service.dart';
import '../common/encrypt_service.dart';
import '../loader.dart';
import '../widgets/GradientText.dart';
class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool isApiCallProcess = false;
  List<dynamic> notifications = [];

  void getnotifications() async
  {
    setState(() {
      isApiCallProcess = true;
    });
    Map<String, dynamic> map = {
      'user_id': globals.user_id,
      'encryption_key': globals.token,
    };
    APIService apiService = new APIService();
    apiService.apicall({"str": encryp(json.encode(map))}, "notificationlist").then((value) {
      Map<String, dynamic> responseJson = json.decode(value);
      //print(responseJson);
      var successcode = int.parse(responseJson["success"].toString());
      if (successcode != 0 && successcode != 3) {
        setState(() {
          isApiCallProcess = false;
        });
        notifications = responseJson["notifications"];
      }
      });
  }

  @override
  void initState() {
    super.initState();
    getnotifications();
  }

  List<Widget> _getChildren(int count, String name) => List<Widget>.generate(
    count,
        (i) => ListTile(

                    subtitle: Text("\n$name",style: TextStyle(color: Colors.white),),

                    title: Text(notifications[i]["dateadded"] + " " + DateFormat('hh:mm a').format(DateFormat("hh:mm").parse(notifications[i]["datecreated"])),
                      style: TextStyle(color: Colors.grey,fontSize: 11),
                      textAlign: TextAlign.right,
                    )),
  );

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: ui_setup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }
  Widget ui_setup(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(globals.color_background),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              color: HexColor(globals.color_background),
              boxShadow: [new BoxShadow(
                color: HexColor(globals.color_blue),
                blurRadius: 20.0,
              ),]
            // gradient: LinearGradient(
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomCenter,
            //     colors: <Color>[
            //       HexColor(globals.color_blue),
            //       HexColor("#BD7923"),
            //       HexColor(globals.color_blue),]),
          ),
        ),
        title: Text("Notifications"),
      ),
      body: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: HexColor(globals.color_blue),
          ),
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        itemCount: notifications.length,
        itemBuilder: (context,index){
          return ExpansionTile(
            title: Text(notifications[index]["title"],style: TextStyle(color: HexColor(globals.color_pink)),),
            children: _getChildren(1, notifications[index]["message"]),
            iconColor: Colors.white,
            collapsedIconColor: HexColor(globals.color_pink),
            initiallyExpanded: true,
            tilePadding: EdgeInsets.fromLTRB(18, 5, 0, 5),


          );
        }
      ),
    );
  }
}
