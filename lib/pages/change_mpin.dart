import 'dart:convert';

import 'package:hexcolor/hexcolor.dart';
import 'package:wingame/common/api_service.dart';
import 'package:wingame/common/encrypt_service.dart';
import 'package:wingame/common/theme_helper.dart';
import 'package:wingame/globalvar.dart' as globals;
import 'package:wingame/loader.dart';
import 'package:wingame/pages/login_page.dart';
import 'package:wingame/widgets/GradientText.dart';
import 'package:wingame/widgets/appbar.dart';
import 'package:wingame/widgets/navigationbar.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
class ChangeMpin extends StatefulWidget {
  const ChangeMpin({Key? key}) : super(key: key);

  @override
  State<ChangeMpin> createState() => _ChangeMpinState();
}

class _ChangeMpinState extends State<ChangeMpin> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ChangepinModel changepinModel = new ChangepinModel();
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
    Navigator.pop(context);
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Center(
                    child: GradientText(
                      'Change Mpin',
                      style:
                      TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 30.0),
                        Container(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration('Old Mpin', 'Enter Old Mpin',),
                            onSaved: (input) =>  changepinModel.old_mpin = input,
                            maxLength: 6,
                            validator: (input) => input!.length < 6
                                ? "Mpin Should Be 6 Digit"
                                : null,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 30.0),
                        Container(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration('New Mpin', 'Enter New Mpin',),
                            onSaved: (input) =>  changepinModel.new_mpin = input,
                            maxLength: 6,
                            validator: (input) => input!.length < 6
                                ? "Mpin Should Be 6 Digit"
                                : null,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 30.0),
                        Container(
                          decoration:
                          ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                'Update Mpin',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            onPressed: () {
                              changepinModel.user_id = globals.user_id;
                              changepinModel.encryption_key = globals.token;
                              changepinModel.device_id = globals.device_id;
                              if (validateAndSave()) {
                                setState(() {
                                  isApiCallProcess = true;
                                });
                                APIService apiService = new APIService();
                                apiService
                                    .apicall(
                                    changepinModel.toJson(), "change_mpin")
                                    .then((value) {
                                  Map<String, dynamic> responseJson =
                                  json.decode(value);
                                  var successcode = int.parse(
                                      responseJson["success"].toString());
                                  if (successcode != 0 && successcode != 3) {
                                    setState(() {
                                      isApiCallProcess = false;
                                      globals.token = responseJson["encryption_key"];
                                    });
                                    var snackBar = SnackBar(
                                      content: Text(responseJson["message"]),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else if (successcode == 3) {
                                    setState(() {
                                      isApiCallProcess = false;
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()),
                                    );
                                  } else {
                                    setState(() {
                                      isApiCallProcess = false;
                                      //globals.token = responseJson["encryption_key"];
                                    });
                                    var snackBar = SnackBar(
                                      content: Text(responseJson["message"]),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);

                                  }
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
}

class ChangepinModel {
  String? old_mpin;
  String? new_mpin;
  String? user_id;
  String? encryption_key;
  String? device_id;

  ChangepinModel({
    this.old_mpin,
    this.new_mpin,
    this.device_id,
    this.user_id,
    this.encryption_key,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'old_mpin': old_mpin,
      'new_mpin': new_mpin,
      'device_id': device_id,
      'user_id': user_id,
      'encryption_key': encryption_key,
    };
    return {'str': encryp(json.encode(map))};
  }
}