import 'dart:convert';

import 'package:wingame/common/api_service.dart';
import 'package:wingame/common/encrypt_service.dart';
import 'package:wingame/common/theme_helper.dart';
import 'package:wingame/globalvar.dart' as globals;
import 'package:wingame/loader.dart';
import 'package:wingame/pages/login_page.dart';
import 'package:wingame/pages/wallet.dart';
import 'package:wingame/widgets/appbar.dart';
import 'package:wingame/widgets/navigationbar.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';

import 'landing_page.dart';
class Address extends StatefulWidget {
  const Address({Key? key}) : super(key: key);

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Addressmodel addressmodel = new Addressmodel();
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
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  @override
  Widget _uiSetup(BuildContext context) {
    return Scaffold(
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
                      'Please Fill Your Address',
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
                            decoration: ThemeHelper().textInputDecoration('Your Full Name', 'Enter Your Full Name'),
                            onSaved: (input) =>  addressmodel.user_name = input,
                            validator: (input) => input!.length < 6
                                ? "Please Enter Your Full Name"
                                : null,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 30,),
                        Container(
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: ThemeHelper().textInputDecoration('Current Address', 'Enter Your Full Address'),
                            onSaved: (input) =>  addressmodel.address = input,
                            validator: (input) => input!.length < 10
                                ? "Please Enter Valid Address"
                                : null,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 30,),
                        Container(
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: ThemeHelper().textInputDecoration('City Name', 'Enter Your City Name'),
                            onSaved: (input) =>  addressmodel.city = input,
                            validator: (input) => input!.length < 3
                                ? "Please Enter Valid City Name"
                                : null,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),SizedBox(height: 30,),
                        Container(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: ThemeHelper().textInputDecoration('City Pincode', 'Enter Your City Pincode'),
                            onSaved: (input) =>  addressmodel.pincode = input,
                            maxLength: 6,
                            validator: (input) => input!.length < 6
                                ? "Please Enter Valid City Pincode"
                                : null,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
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
                              addressmodel.user_id = globals.user_id;
                              addressmodel.encryption_key = globals.token;
                              if (validateAndSave()) {
                                setState(() {
                                  isApiCallProcess = true;
                                });
                                APIService apiService = new APIService();
                                apiService
                                    .apicall(
                                    addressmodel.toJson(), "add_address")
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

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Wallet()),
                                    );
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


class Addressmodel {
  String? address;
  String? city;
  String? pincode;
  String? user_name;
  String? user_id;
  String? encryption_key;

  Addressmodel({
    this.address,
    this.city,
    this.pincode,
    this.user_name,
    this.user_id,
    this.encryption_key,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'address' : address,
      'city' : city,
      'pincode' : pincode,
      'user_name' : user_name,
      'user_id': user_id,
      'encryption_key': encryption_key,
    };
    return {'str': encryp(json.encode(map))};
  }
}