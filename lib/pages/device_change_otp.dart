import 'dart:convert';

import 'package:wingame/common/api_service.dart';
import 'package:wingame/common/encrypt_service.dart';
import 'package:wingame/common/theme_helper.dart';
import 'package:wingame/loader.dart';
import 'package:wingame/pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wingame/globalvar.dart' as globals;

import '../widgets/GradientText.dart';
class DeviceChangeOTP extends StatefulWidget {
  final String mobile;
  final String device_id;
  final String device_name;
  final String device_os;
  final String otp;
  final String fibase_id;
  const DeviceChangeOTP({Key? key, required this.mobile, required this.device_id, required this.otp, required this.device_name, required this.device_os, required this.fibase_id}) : super(key: key);

  @override
  State<DeviceChangeOTP> createState() => _DeviceChangeOTPState();
}

class _DeviceChangeOTPState extends State<DeviceChangeOTP> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _pinSuccess = false;
  bool isApiCallProcess = false;
  String? device_id;
  String? mobile;
  String? otp;
  String? entered_otp;
  void getprefs() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dev = widget.device_id;
    String? mob = widget.mobile;
    String? pin = widget.otp;
    setState((){
      mobile = mob;
      device_id = dev;
      otp = pin;
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
                            Center(
                              child: Text('Verification',
                                style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: HexColor(globals.color_white),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text(
                              'Enter the verification code we just sent via sms on your mobile number.',
                              style: TextStyle(
                                // fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                color: HexColor(globals.color_white),
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
                                color: HexColor(globals.color_white),

                              ),
                              otpFieldStyle: OtpFieldStyle(
                                borderColor: HexColor(globals.color_white),
                                focusBorderColor: HexColor(globals.color_blue),
                                enabledBorderColor: HexColor(globals.color_pink),
                                disabledBorderColor: HexColor(globals.color_white),
                              ),
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldStyle: FieldStyle.underline,
                              onChanged: (input) => _pinSuccess = input.length < 4 ? false : true,
                              onCompleted: (pin) {
                                if(pin.length==4)
                                {
                                  entered_otp = pin;
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
                                  if(_pinSuccess)
                                  {
                                    if(entered_otp==widget.otp)
                                    {
                                      Map<String, dynamic> map = {
                                        'mobile': widget.mobile,
                                        'device_id': widget.device_id,
                                        'otp': widget.otp,
                                        'device_name': widget.device_name,
                                        'device_os': widget.device_os,
                                        'firebaseid': widget.fibase_id,
                                      };
                                      APIService apiService = new APIService();
                                      apiService.apicall({"str": encryp(json.encode(map))}, "verify_device_change_otp").then((value) {
                                        Map<String, dynamic> responseJson = json.decode(value);
                                        var successcode = int.parse(responseJson["success"].toString());
                                        print(responseJson);
                                        if (successcode != 0)
                                        {
                                          //Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => LoginPage())
                                          );
                                          var snackBar = SnackBar(content: Text("OTP Verified Please Login Again"),);
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        }
                                        else
                                        {
                                          setState(() {
                                            isApiCallProcess = false;
                                          });
                                          var snackBar = SnackBar(content: Text("Incorrect OTP"),);
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        }
                                      });
                                    }
                                    else
                                    {
                                      var snackBar = SnackBar(content: Text("Incorrect OTP"),);
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    }
                                  }
                                  else
                                  {
                                    var snackBar = SnackBar(content: Text("Please Enter 4 Digit OTP"),);
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
