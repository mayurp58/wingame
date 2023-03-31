import 'dart:convert';
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
import 'package:gradient_borders/gradient_borders.dart';
import 'package:hexcolor/hexcolor.dart';

import 'landing_page.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ProfileModel profileModel = new ProfileModel();
  bool isApiCallProcess = false;
  Map<String, dynamic> bankdata = Map<String, dynamic>();

  void getprofiledata() async {
    setState(() {
      isApiCallProcess = true;
    });
    Map<String, dynamic> map = {
      'user_id': globals.user_id,
      'encryption_key': globals.token,
    };
    APIService apiService = new APIService();
    apiService
        .apicall({"str": encryp(json.encode(map))}, "getprofile").then((value) {
      Map<String, dynamic> responseJson = json.decode(value);
      //print(responseJson);
      var successcode = int.parse(responseJson["success"].toString());
      if (successcode != 0 && successcode != 3) {

        setState(() {
          isApiCallProcess = false;
          //globals.token = responseJson["encryption_key"];
          bankdata = responseJson["profile"];
        });
        //globals.token = responseJson["encryption_key"];
        /*var snackBar = SnackBar(
          content: Text(responseJson["message"]),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
      } else if (successcode == 3) {
        setState(() {
          isApiCallProcess = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        setState(() {
          isApiCallProcess = false;
        });
        var snackBar = SnackBar(
          content: Text(responseJson["message"]),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getprofiledata();
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LandingPage()),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (bankdata["account_no_edit"] == "1" || bankdata["account_no_edit"] == 1) {
      return ProgressHUD(
        child: _uiSetup(context),
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
      );
    } else if(bankdata["account_no_edit"] == "0" || bankdata["account_no_edit"] == 0) {
      return ProgressHUD(
        child: bankexist(context),
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
      );
    }
    else
      {
        return ProgressHUD(
          child: nothingavailagle(context),
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
        );
      }
  }
  @override
  Widget nothingavailagle(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(globals.color_background),
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child :  Appbar()),
        drawer: AppDrawer(),
        body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 200,
            ),
            Center(
              child: Text(
                'Loading...',
                style:
                TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],

        ),
        ),
    );
  }

  @override
  Widget bankexist(BuildContext context) {
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
                    child: Text(
                      'Registered Mobile number',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: HexColor(globals.color_white)),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child:
                    ListTile(
                      // shape: GradientBoxBorder(
                      //   gradient: LinearGradient(colors: [Color(0xffFEDB87),Color(0xffBD7923),Color(0xffFEDB87)],),
                      //   width: 1,
                      //
                      // ),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      side: BorderSide(color: Colors.white)

                    ),
                    title : Text(
                      globals.mobile_number.toString(),
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w400,color: HexColor("#FFFFFF")),
                      ),
                      leading: Icon(Icons.phone_android,color: HexColor("#FFFFFF")),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Center(
                    child: GradientText(
                      'Your Bank Details',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          side: BorderSide(color: Colors.white)

                      ),
                      leading: Icon(Icons.holiday_village_outlined,color: HexColor("#FFFFFF")),
                      title: Text(
                        bankdata["bank_name"],
                        style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w400,color: HexColor("#FFFFFF")),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          side: BorderSide(color: Colors.white)

                      ),
                      leading: Icon(Icons.numbers,color: HexColor("#FFFFFF")),
                      title: Text(
                         bankdata["account_no"],
                        style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w400,color: HexColor("#FFFFFF")),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Align(
                    alignment:Alignment.centerLeft,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          side: BorderSide(color: Colors.white)

                      ),
                      leading: Icon(Icons.info_outline_rounded,color: HexColor("#FFFFFF")),
                      title: Text(
                        bankdata["ifsc_code"],
                        style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w400,color: HexColor("#FFFFFF")),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          side: BorderSide(color: Colors.white)

                      ),
                      leading: Icon(Icons.person_outline,color: HexColor("#FFFFFF")),
                      title: Text(
                        bankdata["ac_holder_name"],
                        style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w400,color: HexColor("#FFFFFF")),
                      ),
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
                      'Fill Your Bank Details',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: ThemeHelper().textInputDecoration(
                                'Bank Name', 'Enter Your Bank\'s Name'),
                            onSaved: (input) => profileModel.bank_name = input,
                            validator: (input) => input!.length < 2
                                ? "Enter Valid Bank Name"
                                : null,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: ThemeHelper().textInputDecoration(
                                'Bank Account Number',
                                'Enter Your Bank Account Number'),
                            onSaved: (input) =>
                                profileModel.account_number = input,
                            validator: (input) => input!.length < 10
                                ? "Enter Valid Account number"
                                : null,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            maxLength: 11,
                            decoration: ThemeHelper().textInputDecoration(
                                'IFSC Code', 'Enter Banks IFSC Code'),
                            onSaved: (input) => profileModel.ifsc_code = input,
                            validator: (input) =>
                                input!.length < 10 ? "Enter IFSC Code" : null,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: ThemeHelper().textInputDecoration(
                                'Account Holder Name',
                                'Your Name In Bank Passbook'),
                            onSaved: (input) =>
                                profileModel.account_holder_name = input,
                            validator: (input) => input!.length < 4
                                ? "Enter Your Name As Per Bank Passbook"
                                : null,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          decoration:
                              ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                'Update Details'.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            onPressed: () {
                              profileModel.user_id = globals.user_id;
                              profileModel.encryption_key = globals.token;
                              if (validateAndSave()) {
                                setState(() {
                                  isApiCallProcess = true;
                                });
                                APIService apiService = new APIService();
                                apiService
                                    .apicall(
                                        profileModel.toJson(), "addprofile")
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

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) => super.widget));
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
                                      globals.token = responseJson["encryption_key"];
                                    });
                                    var snackBar = SnackBar(
                                      content: Text(responseJson["message"]),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    /*Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) => super.widget));*/
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

class ProfileModel {
  String? account_number;
  String? ifsc_code;
  String? bank_name;
  String? account_holder_name;
  String? user_id;
  String? encryption_key;

  ProfileModel({
    this.account_number,
    this.ifsc_code,
    this.bank_name,
    this.account_holder_name,
    this.user_id,
    this.encryption_key,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'account_no': account_number,
      'ifsc_code': ifsc_code,
      'bank_name': bank_name,
      'ac_holder_name': account_holder_name,
      'user_id': user_id,
      'encryption_key': encryption_key,
    };
    return {'str': encryp(json.encode(map))};
  }
}
