import 'dart:convert';

import 'package:wingame/common/api_service.dart';
import 'package:wingame/common/encrypt_service.dart';
import 'package:wingame/common/theme_helper.dart';
import 'package:wingame/globalvar.dart' as globals;
import 'package:wingame/loader.dart';
import 'package:wingame/pages/login_page.dart';
import 'package:wingame/widgets/GradientText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Otpverification extends StatefulWidget {
  const Otpverification({Key? key}) : super(key: key);

  @override
  _OtpverificationState createState() => _OtpverificationState();
}

class _OtpverificationState extends State<Otpverification> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _pinSuccess = false;
  bool isApiCallProcess = false;
  Otpmodel otpmodel = new Otpmodel();
  String? device_id;
  String? mobile;
  String? mpin;
  String? email;


  void getprefs() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dev = globals.reg_device;
    String? mob = globals.reg_mobile;
    String? pin = globals.reg_mpin;
    String? em = globals.reg_email;
    setState((){
      mobile = mob;
      device_id = dev;
      mpin = pin;
      email = em;
    });
  }
  @override
  void initState() {
    super.initState();
    getprefs();
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
    double _headerHeight = 300;

    return Scaffold(
        backgroundColor: HexColor(globals.color_background),
        body: SingleChildScrollView(
          child: Column(
            children: [
              /*Container(
                height: _headerHeight,
                child: HeaderWidget(
                    _headerHeight, true, Icons.privacy_tip_outlined),
              ),*/
              SizedBox(height: 100,),
              Image.asset('assets/logo.png',width: 200,),
              SafeArea(
                child: Container(
                  margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Verification',
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor(globals.color_white)
                              ),
                              // textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10,),
                            Text(
                              'Enter the verification code we just sent via sms on your mobile number.',
                              style: TextStyle(
                                // fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor(globals.color_white)
                              ),
                              // textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            OTPTextField(
                              length: 4,
                              width: 300,
                              fieldWidth: 50,

                              style: TextStyle(
                                  fontSize: 30,
                                color: HexColor(globals.color_white)

                              ),
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldStyle: FieldStyle.underline,
                              otpFieldStyle: OtpFieldStyle(
                                  focusBorderColor: HexColor(globals.color_pink),
                                  enabledBorderColor: HexColor(globals.color_blue),
                              ),
                              onChanged: (input) => _pinSuccess = input.length < 4 ? false : true,
                              onCompleted: (pin) {
                                if(pin.length==4)
                                {
                                    otpmodel.otp = pin;
                                }
                                setState(() {
                                  _pinSuccess = pin.length==4 ? true : false;
                                });
                              },

                            ),
                            SizedBox(height: 60.0),

                            Container(
                              decoration: _pinSuccess ? ThemeHelper().buttonBoxDecoration(context):ThemeHelper().buttonBoxDecoration(context, "#AAAAAA","#757575"),
                              child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      40, 10, 40, 10),
                                  child: Text(
                                    "Verify".toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onPressed: _pinSuccess ? () {
                                  if(_pinSuccess) {
                                    otpmodel.mobile = mobile.toString();
                                    otpmodel.device_id = device_id.toString();
                                    otpmodel.mpin = mpin.toString();
                                    otpmodel.email = email.toString();

                                    setState(() {
                                      isApiCallProcess = true;
                                    });
                                    APIService apiService = new APIService();
                                    //print("mp" + decryp(otpmodel.toString()));
                                    apiService.otp(otpmodel,"register").then((value) {
                                      Map<String, dynamic> responseJson = json.decode(value.str);
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
                                          MaterialPageRoute(builder: (context) => LoginPage()),
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
                                  else
                                  {
                                    var snackBar = SnackBar(content: Text("Please Enter 4 Digit OTP",style: TextStyle(color: HexColor(globals.color_pink)),),);
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  }
                                } : null,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}

class Otpmodel
{
  String? mobile;
  String? device_id;
  String? mpin;
  String? otp;
  String? email;

  Otpmodel({
    this.mobile,
    this.device_id,
    this.mpin,
    this.otp,
    this.email,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'mobile': mobile,
      'device_id' : device_id,
      'mpin' : mpin,
      'otp' : otp,
      'email' : email,
    };
    //print(map);
    return {
      'str' : encryp(json.encode(map))
    };
  }

}