import 'dart:convert';
import 'dart:io';

import 'package:hexcolor/hexcolor.dart';
import 'package:wingame/common/api_service.dart';
import 'package:wingame/common/encrypt_service.dart';
import 'package:wingame/common/theme_helper.dart';
import 'package:wingame/globalvar.dart' as globals;
import 'package:wingame/loader.dart';
import 'package:wingame/pages/login_page.dart';
import 'package:wingame/widgets/GradientText.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'otp_verification_page.dart';

class RegistrationPage extends  StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage>{

  double _headerHeight = 250;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //Registermodel registermodel = new Registermodel();
  Registermodel _registermodel = new Registermodel();
  TextEditingController _mobile = TextEditingController();
  TextEditingController _mpin = TextEditingController();
  TextEditingController _email = TextEditingController();
  bool isApiCallProcess = false;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String? _id;
  String _errorMessage = '';
  // This function will be called when the floating button is pressed

  Future<void> setpref(String val1, String val2) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(val1,val2);
  }
  void validateEmail(String val) {
    if(val.isEmpty){
      setState(() {
        _errorMessage = "Email can not be empty";
      });
    }else if(!EmailValidator.validate(val, true)){
      setState(() {
        _errorMessage = "Invalid Email Address";
      });
    }else{
      setState(() {

        _errorMessage = "";
      });
    }
  }

  Future<void> initPlatformState() async {
    try {
      if (Platform.isAndroid)
      {
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        String? dev_id = await PlatformDeviceId.getDeviceId;
        setState(() {
          _id = dev_id;
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
    initPlatformState();
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
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 10),// This will be the login form
                  child: Column(
                    children: [
                      Text(
                        'Welcome To Wingame',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: HexColor(globals.color_white)),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Register New Account',
                        style: TextStyle(fontSize: 15,color: HexColor(globals.color_white)),
                        ),
                      SizedBox(height: 30.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [

                              Container(
                                child: TextFormField(
                                  keyboardType: TextInputType.phone,
                                  decoration: ThemeHelper().textInputDecoration('Mobile Number', 'Enter 10 Digit Mobile Number'),
                                  onSaved: (input) =>  _registermodel.mobile = input,
                                  maxLength: 10,
                                  controller: _mobile,
                                  validator: (input) => input!.length < 10
                                      ? "Mobile Number Should Be 10 Digit"
                                      : null,
                                ),
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(height: 30,),
                              Container(
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: ThemeHelper().textInputDecoration('Mpin', 'Enter 6 Digit Mpin Of Your Choice'),
                                  onSaved: (input) =>  _registermodel.mpin = input,
                                  maxLength: 6,
                                  controller: _mpin,
                                  validator: (input) => input!.length < 6
                                      ? "Mpin Should Be 6 Digit"
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
                                    child: Text('Register', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                                  ),
                                  onPressed: (){

                                    _registermodel.device_id = _id;

                                    if (validateAndSave()) {
                                      setState(() {
                                        isApiCallProcess = true;
                                      });
                                      APIService apiService = new APIService();
                                      apiService.register(_registermodel,"checkuser").then((value) {
                                        Map<String, dynamic> responseJson = json.decode(value.str);
                                        //setpref("device_id",_id.toString());
                                        globals.reg_device = _id.toString();
                                        globals.reg_mobile = _mobile.text;
                                        globals.reg_mpin = _mpin.text;
                                        globals.reg_email = _email.text;
                                        //setpref("mobile",_mobile.text);
                                        //setpref("mpin",_mpin.text);
                                        //setpref("email",_email.text);
                                        var successcode = int.parse(responseJson["success"].toString());
                                        if (successcode!=0 )
                                        {
                                          setState(() {
                                            isApiCallProcess = false;
                                          });
                                          var snackBar = SnackBar(content: Text(responseJson["message"]),);
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => Otpverification()),
                                            );
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
                              Container(
                                margin: EdgeInsets.fromLTRB(10,40,10,20),
                                //child: Text('Don\'t have an account? Create'),
                                child: InkWell(
                                  child: Text("I Already have an account! Login",style: TextStyle(color: HexColor(globals.color_white)),),
                                  onTap: ()=>{
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()))
                                  },
                                )
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


class Registermodel
{
  String? mobile;
  String? device_id;
  String? mpin;
  String? email;

  Registermodel({
    this.mobile,
    this.device_id,
    this.mpin,
    this.email
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'mobile': mobile,
      'device_id' : device_id,
      'mpin' : mpin,
      'email' : email,
    };
    return {
      'str' : encryp(json.encode(map))
    };
  }

}