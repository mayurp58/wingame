import 'dart:convert';
import 'dart:io';

import 'package:hexcolor/hexcolor.dart';
import 'package:wingame/common/api_service.dart';
import 'package:wingame/common/encrypt_service.dart';
import 'package:wingame/common/theme_helper.dart';
import 'package:wingame/loader.dart';
import 'package:wingame/pages/login_page.dart';
import 'package:wingame/widgets/GradientText.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wingame/globalvar.dart' as globals;
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  double _headerHeight = 250;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String? _id;
  // This function will be called when the floating button is pressed
  TextEditingController mpincontroller = new TextEditingController();
  Future<void> setpref(String val1, String val2) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(val1,val2);
  }

  Future<void> initPlatformState() async {
    try {
      if (Platform.isAndroid)
      {
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        setState(() {
          _id = androidInfo.id;
        });
        //print("id : " + _id.toString());
        //print("dev_name : " + devicename.toString());
        //print("dev_os : " + deviceos.toString());
      }
    } on PlatformException {

    }

  }


  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    initPlatformState();
  }
  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    //print("BACK BUTTON!"); // Do some stuff.
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
    return false;
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            /*Container(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true, Icons.app_registration), //let's create a common header widget
            ),*/
            SizedBox(height: 100,),
            Image.asset('assets/logo.png',width: 200,),
            SafeArea(
              child: Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),// This will be the login form
                  child: Column(
                    children: [
                      Text(
                        'Welcome To Wingame',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: HexColor(globals.color_white)),
                      ),
                      SizedBox(height: 20.0),
                      GradientText(
                        'Forgot Mpin? Dont Worry!',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 30.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                child: TextFormField(
                                  keyboardType: TextInputType.phone,
                                  decoration: ThemeHelper().textInputDecoration('Enter Registered Mobile Number', 'Enter 10 Digit Mobile Number'),
                                  //onSaved: (input) =>  registermodel.mobile = input,
                                  maxLength: 10,
                                  controller: mpincontroller,
                                  validator: (input) => input!.length < 10
                                      ? "Mobile Number Should Be 10 Digit"
                                      : null,
                                ),
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              ),

                              SizedBox(height: 60.0),

                              Container(
                                decoration: ThemeHelper().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: Text('Get Mpin', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                                  ),
                                  onPressed: ()
                                  {
                                    if (validateAndSave()) {
                                      setState(() {
                                        isApiCallProcess = true;
                                      });
                                      APIService apiService = new APIService();
                                      Map<String, dynamic> map = {
                                        'mobile': mpincontroller.text,
                                      };
                                      apiService.apicall({"str": encryp(json.encode(map))}, "forgot_mpin").then((value) {
                                        Map<String, dynamic> responseJson =
                                        json.decode(value);
                                        var successcode = int.parse(
                                            responseJson["success"].toString());
                                        //print(responseJson);
                                        if (successcode != 0)
                                        {
                                          setState(() {
                                            isApiCallProcess = false;
                                          });
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                                        }
                                        else
                                        {
                                          setState(() {
                                            isApiCallProcess = false;
                                          });
                                          mpincontroller.text = "";
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
                              Container(
                                margin: EdgeInsets.fromLTRB(10,20,10,20),
                                //child: Text('Don\'t have an account? Create'),
                                alignment: Alignment.center,
                                child: Center(
                                  child: Text("You will receive an SMS containing your mpin please make sure your mobile number is in working state",textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[400],fontSize: 12),),
                                )
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(10,20,10,20),
                                //child: Text('Don\'t have an account? Create'),
                                child: InkWell(
                                  child: GradientText("Already Have Account? Login",style: TextStyle(fontSize: 18),),
                                  onTap: ()=>{
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()))
                                  },
                                ),
                              ),
                            ],
                          )
                      ),
                    ],
                  )
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
