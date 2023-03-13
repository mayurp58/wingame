import 'dart:async';
import 'dart:convert';

import 'package:wingame/common/api_service.dart';
import 'package:wingame/common/encrypt_service.dart';
import 'package:wingame/common/theme_helper.dart';
import 'package:wingame/globalvar.dart' as globals;
import 'package:wingame/loader.dart';
import 'package:wingame/pages/login_page.dart';
import 'package:wingame/pages/profile_page.dart';
import 'package:wingame/widgets/GradientText.dart';
import 'package:wingame/widgets/appbar.dart';
import 'package:wingame/widgets/navigationbar.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

import 'landing_page.dart';

class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  late TabController _tabController;
  final fieldText = TextEditingController();
  AddFundModel addFundModel = new AddFundModel();
  WithdrawFundModel withdrawFundModel = new WithdrawFundModel();
  var min_deposit = int.parse(globals.min_deposit.toString());
  var min_withdraw = int.parse(globals.min_withdraw.toString());
  Map<String, dynamic> bankdata = Map<String, dynamic>();
  //Map<String, dynamic> note = Map<String, dynamic>();
  var note;
  String note_dep = "";
  int _selectedIndex = 0;

  Future<void> _launchInBrowser(Uri url) async {
    final Uri toLaunch = Uri.parse(url.toString());
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $toLaunch';
    }
  }

  void getprofiledata() async {
    note = {"description": "Loading"};
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
      var successcode = int.parse(responseJson["success"].toString());
      if (successcode != 0 && successcode != 3) {
        print(responseJson);
        setState(() {
          isApiCallProcess = false;
          //globals.token = responseJson["encryption_key"];
          bankdata = responseJson["profile"];
          note = {"description": responseJson["note"][0]["description"]};
          note_dep = (responseJson["deposit"].toString() == null) ? "" : responseJson["deposit"];
        });
        //globals.token = responseJson["encryption_key"];
        /*var snackBar = SnackBar(
          content: Text(responseJson["message"]),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
        /*if(bankdata["user_name"]=="" || bankdata["address"]=="" || bankdata["city"]=="" || bankdata["pincode"]=="" || successcode == 6)
        {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Address()),
            );
        }*/
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
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
      if (_tabController.index == 1 && bankdata["account_no"] == "") {
        var snackBar = SnackBar(
          content: Text("Please Fill Bank Details First"),
          backgroundColor: HexColor("#FFFFFF"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      }
    });
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    getprofiledata();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
    _tabController.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    //print("BACK BUTTON!"); // Do some stuff.
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LandingPage()),
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
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: Appbar()),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            // give the tab bar a height [can change hheight to preferred height]
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                // give the indicator a decoration (color and border radius)
                indicator: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [Color(0xffFEDB87),Color(0xffBD7923),Color(0xffFEDB87)],),
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                  color: HexColor("#FEDB87"),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: [
                  // first tab [you can add an icon using the icon property]
                  Tab(
                    text: 'Add Fund',
                  ),

                  // second tab [you can add an icon using the icon property]
                  Tab(
                    text: 'Withdraw Fund',
                  ),
                ],
              ),
            ),
            // tab bar view here
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // first tab bar view widget
                  Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 60,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 15),
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: fieldText,
                              decoration: ThemeHelper().textInputDecoration(
                                  'Amount',
                                  'Minimun Deposit Amount ' +
                                      globals.min_deposit.toString()),
                              onSaved: (input) => addFundModel.amount = input,
                              maxLength: 6,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (input) =>
                                  validateAmount(input) == false
                                      ? "Amount Greater Than " +
                                          min_deposit.toString()
                                      : null,
                            ),
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                          ),
                          SizedBox(height: 15.0),
                          Container(
                            decoration:
                                ThemeHelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text(
                                  'Add Fund',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              onPressed: () {
                                addFundModel.user_id = globals.user_id;
                                addFundModel.encryption_key = globals.token;

                                if (validateAndSave()) {
                                  /*Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PaymentGateway(amount: addFundModel.amount.toString(),)),
                                    );*/
                                  setState(() {
                                    isApiCallProcess = true;
                                    clearText();
                                  });
                                  APIService apiService = new APIService();
                                  apiService
                                      .apicall(addFundModel.toJson(),
                                          "wallet_request")
                                      .then((value) {
                                    Map<String, dynamic> responseJson =
                                        json.decode(value);
                                    var successcode = int.parse(
                                        responseJson["success"].toString());
                                    if (successcode != 0 && successcode != 3) {
                                      setState(() {
                                        isApiCallProcess = false;
                                      });
                                      //globals.token = responseJson["encryption_key"];
                                      var snackBar = SnackBar(
                                        content: Text(responseJson["message"]),
                                        backgroundColor: HexColor("#FEDB87"),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                      _launchInBrowser(
                                          Uri.parse(responseJson["upi_link"]));
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
                                      });
                                      //globals.balance = "1100";
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
                          SizedBox(
                            height: 30,
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Minimum Deposit : ",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: HexColor("#FEDB87")),
                                ),
                                TextSpan(text: " "),
                                WidgetSpan(
                                    child: Icon(
                                  Icons.currency_rupee,
                                  color: HexColor("#FEDB87"),
                                  size: 14,
                                )),
                                TextSpan(
                                  text: min_deposit.toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: HexColor("#FEDB87")),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    note_dep.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16),
                                  ))),
                        ],
                      ),
                    ),
                  ),

                  // second tab bar view widget
                  Center(
                    child: Form(
                      key: _formKey2,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        decoration: BoxDecoration(
                          border: Border.all(color: HexColor("#000000")),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: GradientText(
                                "Amount Will Be Credited To",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Mobile : ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: HexColor("#FEDB87")),
                                  ),
                                  TextSpan(text: " "),
                                  TextSpan(
                                    text: globals.mobile_number,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: HexColor("#FEDB87")),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Bank : ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: HexColor("#FEDB87")),
                                  ),
                                  TextSpan(text: " "),
                                  TextSpan(
                                    text: bankdata["bank_name"],
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: HexColor("#FEDB87")),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "A/c No. : ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: HexColor("#FEDB87")),
                                  ),
                                  TextSpan(text: " "),
                                  TextSpan(
                                    text: bankdata["account_no"],
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: HexColor("#FEDB87")),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "IFSC : ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: HexColor("#FEDB87")),
                                  ),
                                  TextSpan(text: " "),
                                  TextSpan(
                                    text: bankdata["ifsc_code"],
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: HexColor("#FEDB87")),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Name : ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: HexColor("#FEDB87")),
                                  ),
                                  TextSpan(text: " "),
                                  TextSpan(
                                    text: bankdata["ac_holder_name"],
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: HexColor("#FEDB87")),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 15),
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: fieldText,
                                decoration: ThemeHelper().textInputDecoration(
                                    'Amount',
                                    'Min. Withdraw Amount ' +
                                        globals.min_withdraw.toString()),
                                onSaved: (input) =>
                                    withdrawFundModel.amount = input,
                                maxLength: 6,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                validator: (input) => validateAmountWithdraw(
                                            input) ==
                                        false
                                    ? ((int.parse(globals.balance.toString()) <
                                            int.parse(input!))
                                        ? "Insufficient Wallet Balance"
                                        : "Amount Greater Than " +
                                            min_withdraw.toString())
                                    : null,
                              ),
                              decoration:
                                  ThemeHelper().inputBoxDecorationShaddow(),
                            ),
                            Container(
                              decoration:
                                  ThemeHelper().buttonBoxDecoration(context),
                              child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                                  child: Text(
                                    'Withdraw Fund',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                onPressed: () {
                                  if (bankdata["account_no"] == "") {
                                    var snackBar = SnackBar(
                                      content: Text(
                                          "Please Fill Bank Details First"),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfilePage()),
                                    );
                                  }
                                  withdrawFundModel.user_id = globals.user_id;
                                  withdrawFundModel.encryption_key =
                                      globals.token;

                                  if (validateAndSave2()) {
                                    setState(() {
                                      isApiCallProcess = true;
                                      clearText();
                                    });
                                    APIService apiService = new APIService();
                                    apiService
                                        .apicall(withdrawFundModel.toJson(),
                                            "wallet_request")
                                        .then((value) {
                                      Map<String, dynamic> responseJson =
                                          json.decode(value);
                                      var successcode = int.parse(
                                          responseJson["success"].toString());
                                      if (successcode != 0 &&
                                          successcode != 3) {
                                        setState(() {
                                          isApiCallProcess = false;
                                        });
                                        globals.token =
                                            responseJson["encryption_key"];
                                        var snackBar = SnackBar(
                                          content:
                                              Text(responseJson["message"]),
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
                                              builder: (context) =>
                                                  LoginPage()),
                                        );
                                      } else {
                                        setState(() {
                                          isApiCallProcess = false;
                                        });
                                        var snackBar = SnackBar(
                                          content: Container(
                                              height: 120,
                                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Uh-Oh ",
                                                    style: TextStyle(
                                                        color: HexColor("#000000"),
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                  SizedBox(height: 20,),
                                                  Text(
                                                    responseJson["message"],
                                                    style: TextStyle(
                                                        color: HexColor("#000000"),
                                                        fontSize: 18),
                                                  ),
                                                ],

                                              )
                                          ),
                                          backgroundColor: Colors.grey[100],
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    });
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(color: Colors.black),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Minimum Withdrawal : ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: HexColor("#FEDB87")),
                                  ),
                                  TextSpan(text: " "),
                                  WidgetSpan(
                                      child: Icon(
                                    Icons.currency_rupee,
                                    color: HexColor("#FEDB87"),
                                    size: 14,
                                  )),
                                  TextSpan(
                                    text: min_withdraw.toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: HexColor("#FEDB87")),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GradientText(note["description"].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                            ),
                          ],
                        ),
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

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  bool validateAndSave2() {
    final form = _formKey2.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  bool validateAmount(value) {
    int val = int.parse(value);
    int dep = int.parse(min_deposit.toString());
    if (val >= dep) {
      return true;
    }
    return false;
  }

  bool validateAmountWithdraw(value) {
    int val = int.parse(value);
    int dep = int.parse(min_withdraw.toString());
    int current_bal = int.parse(globals.balance.toString());
    if (val >= dep && current_bal >= val) {
      return true;
    }
    return false;
  }

  void clearText() {
    fieldText.clear();
  }
}

class AddFundModel {
  String? amount;
  String? user_id;
  String? encryption_key;

  AddFundModel({
    this.amount,
    this.user_id,
    this.encryption_key,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'req_amount': amount,
      'user_id': user_id,
      'encryption_key': encryption_key,
      'req_message': "Credit",
    };
    return {'str': encryp(json.encode(map))};
  }
}

class WithdrawFundModel {
  String? amount;
  String? user_id;
  String? encryption_key;

  WithdrawFundModel({
    this.amount,
    this.user_id,
    this.encryption_key,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'req_amount': amount,
      'user_id': user_id,
      'encryption_key': encryption_key,
      'req_message': "Debit",
    };
    return {'str': encryp(json.encode(map))};
  }
}
