import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:wingame/common/api_service.dart';
import 'package:wingame/common/encrypt_service.dart';
import 'package:wingame/common/theme_helper.dart';
import 'package:wingame/globalvar.dart' as globals;
import 'package:wingame/loader.dart';
import 'package:wingame/pages/device_change_otp.dart';
import 'package:wingame/pages/forgot_password.dart';
import 'package:wingame/widgets/GradientText.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'landing_page.dart';
//import 'forgot_password_page.dart';
//import 'profile_page.dart';
import 'registration_page.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}): super(key:key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

enum _Actions { deleteAll }
enum _ItemActions { delete, edit, containsKey }

class _LoginPageState extends State<LoginPage>{
  double _headerHeight = 250;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  RequestModel requestModel = new RequestModel();
  bool isApiCallProcess = false;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final _storage = const FlutterSecureStorage();
  TextEditingController mobilenumber = TextEditingController();
  String saved_mobile = "";

  String? _id;
  String? devicename;
  String? deviceos;
  bool show_register = false;
  String? _deviceId;
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? deviceId;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      deviceId = await PlatformDeviceId.getDeviceId;
      devicename = androidInfo.brand! + " " + androidInfo.device!;
      deviceos = androidInfo.version.release;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _deviceId = deviceId;
      _id = deviceId;

      print("deviceId->$_deviceId");
    });
  }
  // This function will be called when the floating button is pressed
  /*Future<void> initPlatformState() async {
   try {
      if (Platform.isAndroid)
      {
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        setState(() {
          _id = androidInfo.id;
          devicename = androidInfo.brand! + " " + androidInfo.device!;
          deviceos = androidInfo.version.release;
        });
        //print("id : " + _id.toString());
        //print("dev_name : " + devicename.toString());
        //print("dev_os : " + deviceos.toString());
      }
    } on PlatformException {

    }
   //check_device();
  }*/

  void check_device() async {
    setState(() {
      isApiCallProcess = true;
    });
    Map<String, dynamic> map = {
      'device_id': _id,
    };
    
    APIService apiService = new APIService();
    apiService
        .apicall({"str": encryp(json.encode(map))}, "check_device").then((value) {
      Map<String, dynamic> responseJson = json.decode(value);
      //print(responseJson);
      var successcode = int.parse(responseJson["success"].toString());
      if (successcode == 1)
      {

        setState(() {
          isApiCallProcess = false;
          show_register = true;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
      }
      else
      {
        setState(() {
          isApiCallProcess = false;
          show_register = false;
        });

      }
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    setmobile();
  }
  /*--------------------------code for secured storage--------------------------------*/
  void setmobile()
  {
    _storage.readAll(aOptions: _getAndroidOptions()).then((value) {
      mobilenumber.text = (value["mobile"].toString().length == 10 ) ? value["mobile"].toString() : "";
    });
  }
  Future<void> writeSecureData(String key, String value) async {
    try {
      await _storage.write(
        key: key,
        value: value,
        aOptions: _getAndroidOptions(),
      );
    } catch (e) {
      //print(e);
    }
  }

  Future<String> readSecureData(String key) async {
    String value = "";
    try {
      value = (await _storage.read(key: key)) ?? "";
    } catch (e) {
      //print(e);
    }
    return value.toString();
  }


  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  /*--------------------------Code for secure storage end -----------------------------*/
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
              child: HeaderWidget(_headerHeight, true, Icons.login_rounded), //let's create a common header widget
            ),*/
            SizedBox(height: 70,),
            Image.asset('assets/logo.png',width: 200,),
            SafeArea(
              child: Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 10),// This will be the login form
                  child: Column(
                    children: [

                      Text(
                        'Signin into your account',
                        style: TextStyle(color: HexColor(globals.color_white)),
                      ),
                      SizedBox(height: 30.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                child: TextFormField(
                                  keyboardType: TextInputType.phone,
                                  controller: mobilenumber,
                                  //initialValue: "8087827327",
                                  decoration: ThemeHelper().textInputDecoration('Mobile Number', 'Enter 10 Digit Mobile Number'),
                                  onSaved: (input) =>  requestModel.mobile = input,
                                  maxLength: 10,
                                  validator: (input) => input!.length < 10
                                      ? "Mobile Number Should Be 10 Digit"
                                      : null,
                                ),
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(height: 30.0),
                              Container(
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  obscureText: true,
                                  //initialValue: "123456",
                                  decoration: ThemeHelper().textInputDecoration('Mpin', 'Enter Mpin',),
                                  onSaved: (input) =>  requestModel.password = input,
                                  maxLength: 6,
                                  validator: (input) => input!.length < 6
                                      ? "Mpin Should Be 6 Digit"
                                      : null,
                                ),
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(height: 15.0),
                              Container(
                                margin: EdgeInsets.fromLTRB(10,0,10,20),
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    //Navigator.push( context, MaterialPageRoute( builder: (context) => ForgotPasswordPage()), );
                                  },
                                  child: InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ForgotPassword()),
                                      );
                                    },
                                    child: Text( "Forgot Your Mpin?", style: TextStyle( color: HexColor(globals.color_white), ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: ThemeHelper().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: Text('Sign In', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: HexColor(globals.color_white)),),
                                  ),
                                  onPressed: (){

                                    requestModel.device_id = _id;
                                    requestModel.device_name = devicename;
                                    requestModel.device_os = "Android" + deviceos.toString();
                                    globals.device_id = _id;
                                    if (validateAndSave()) {
                                      setState(() {
                                        isApiCallProcess = true;
                                      });
                                      APIService apiService = new APIService();
                                      apiService.login(requestModel,"login_with_pin").then((value) {
                                        Map<String, dynamic> responseJson = json.decode(value.str);
                                        var successcode = int.parse(responseJson["success"].toString());
                                        if (successcode!=0 && successcode!=6)
                                        {
                                          globals.isLoggedIn = true;
                                          globals.user_id = responseJson["user_id"];
                                          globals.mobile_number = responseJson["mobile"];
                                          globals.token = responseJson["encryption_key"];
                                          globals.min_withdraw = responseJson["min_withdraw"];
                                          globals.min_deposit = responseJson["min_deposit"];
                                          globals.balance = responseJson["current_balance"];
                                          globals.congrats = responseJson["congrats"];
                                          globals.support_number = responseJson["appversion"]["mobile"];
                                          globals.device_id = _id;
                                          globals.payment_gateway_url = responseJson["appversion"]["payment_gateway"];
                                          //this is to set the mobile number in keystore
                                          writeSecureData("mobile",mobilenumber.text);
                                          setState(() {
                                            isApiCallProcess = false;

                                          });
                                            //var snackBar = SnackBar(content: Text(responseJson["message"]),);
                                            //ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => LandingPage()),
                                            );
                                        }
                                        else if(successcode==6)
                                          {
                                            setState(() {
                                              isApiCallProcess = false;
                                            });
                                            show_device_change(context,responseJson["message"],responseJson["mobile"]);
                                            //print("Show popup for device change");
                                          }
                                        else
                                          {
                                            setState(() {
                                              isApiCallProcess = false;
                                            });
                                            var snackBar = SnackBar(content: Text(responseJson["message"]),);
                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                          }
                                      });
                                    }
                                    //After successful login we will redirect to profile page. Let's create profile page now
                                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                                  },
                                ),
                              ),
                              SizedBox(height: 20,),
                              Container(
                                margin: EdgeInsets.fromLTRB(10,20,10,20),
                                //child: Text('Don\'t have an account? Create'),
                                child: InkWell(
                                  child: Text("Dont Have Account? Register",style: TextStyle(color: HexColor(globals.color_white)),),
                                  onTap: ()=>{
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()))
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

  void show_device_change(BuildContext context,String page,String mobile) {
    showDialog(context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              decoration: BoxDecoration(
                color: HexColor(globals.color_background),
                  borderRadius: BorderRadius.circular(20.0),      // Radius of the border
                  border: Border.all(
                    color: HexColor(globals.color_white),
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
                      Center(child: Text("New Device Found",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: HexColor(globals.color_white)),)),
                      SizedBox(height: 20,),
                      Text(page,style: TextStyle(color: HexColor(globals.color_white)),),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              //style : ThemeHelper().filled_square_button(),
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.transparent),side: MaterialStateProperty.all(BorderSide(color: HexColor(globals.color_white)))),
                              onPressed: (){
                                Navigator.pop(context);
                              }, child: Text("No",style: TextStyle(color: HexColor(globals.color_white)),)),

                          ElevatedButton(
                              //style : ThemeHelper().filled_square_button(),
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.transparent),side: MaterialStateProperty.all(BorderSide(color: HexColor(globals.color_white)))),
                              onPressed: () async {

                                print(PlatformDeviceId.getDeviceId.toString());
                                Map<String, dynamic> map = {
                                  'mobile': mobile,
                                  'device_id': globals.device_id,
                                };
                                APIService apiService = new APIService();
                                  apiService.apicall({"str": encryp(json.encode(map))}, "send_device_change_otp").then((value) {
                                  Map<String, dynamic> responseJson = json.decode(value);
                                  var successcode = int.parse(responseJson["success"].toString());
                                  if (successcode != 0)
                                  {
                                    //Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DeviceChangeOTP(mobile: mobile,device_id: globals.device_id.toString(), otp: responseJson["otp"].toString(),device_name: devicename.toString(),device_os: "Android" + deviceos.toString(),fibase_id: globals.firebase_token.toString(),))
                                    );

                                  }
                                  else
                                  {
                                    setState(() {
                                      isApiCallProcess = false;
                                    });
                                    var snackBar = SnackBar(content: Text(responseJson["message"]),);
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => LoginPage()),
                                    );
                                  }
                                });

                              }, child: Text("Yes",style: TextStyle(color: HexColor(globals.color_white)),))
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),
          );
        });
    //}).then((_) => open = false.toString());
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

class RequestModel
{
  String? mobile;
  String? password;
  String? device_id;
  String? firebaseid;
  String? device_name;
  String? device_os;
  RequestModel({
    this.mobile,
    this.password,
    this.device_id,
    this.firebaseid,
    this.device_name,
    this.device_os,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'mobile': mobile,
      'mpin': password,
      'device_id' : device_id,
      'firebaseid' : globals.firebase_token,
      'device_name' : device_name,
      'appversion' : "1.0",
      'device_os' : device_os,

    };
    return {
      'str' : encryp(json.encode(map))
    };
  }

}