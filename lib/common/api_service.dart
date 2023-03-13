import 'dart:convert';

import 'package:wingame/common/encrypt_service.dart';
import 'package:wingame/common/response_model.dart';
import 'package:wingame/pages/login_page.dart';
import 'package:wingame/pages/otp_verification_page.dart';
import 'package:wingame/pages/registration_page.dart';
import 'package:http/http.dart' as http;
class APIService
{
  String APIURL = "https://www.wingame.pro/api/";
  Future<String> apicall(Map request,String endpoint)
  async {
    http.Client().close();
    Map personMap = request;
    //print("req" + decryp(request["str"]));
    APIURL = APIURL + endpoint;
    final response = await http.post(Uri.parse(APIURL), body: personMap);
    if (response.statusCode == 200 || response.statusCode == 400) {
      //print(response.body);
      //print("mp :" + json.decode(response.body));
      var jsondata = json.decode(response.body);
      //print(decryp(jsondata["str"]));
      return decryp(jsondata["str"]);
    } else {
      http.Client().close();
      throw Exception('Failed to load data!');
    }
  }

  Future<String> apicall_getdata(String endpoint)
  async {
    APIURL = APIURL + endpoint;
    final response = await http.get(Uri.parse(APIURL));
    if (response.statusCode == 200 || response.statusCode == 400) {
      var jsondata = json.decode(response.body);
      //print(decryp(jsondata["str"]));
      return decryp(jsondata["str"]);
    } else {
      throw Exception('Failed to load data!');
    }
  }

  Future<LoginResponseModel> login(RequestModel requestModel,String endpoint) async {
    Map personMap = requestModel.toJson();
    APIURL = APIURL + endpoint;
    final response = await http.post(Uri.parse(APIURL), body: personMap);
    if (response.statusCode == 200 || response.statusCode == 400) {
      //print("mp :" + response.body);
      return LoginResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception('Failed to load data!');
    }
  }

  Future<LoginResponseModel> register(Registermodel registermodel,String endpoint) async {
    Map personMap = registermodel.toJson();
    APIURL = APIURL + endpoint;
    final response = await http.post(Uri.parse(APIURL), body: personMap);
    if (response.statusCode == 200 || response.statusCode == 400) {
      //print("mp :" + response.body);
      return LoginResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception('Failed to load data!');
    }
  }

  Future<LoginResponseModel> otp(Otpmodel otpmodel,String endpoint) async {
    Map personMap = otpmodel.toJson();
    APIURL = APIURL + endpoint;
    final response = await http.post(Uri.parse(APIURL), body: personMap);
    //print(response.body);
    //print(decryp(personMap["str"]));
    if (response.statusCode == 200 || response.statusCode == 400) {

      return LoginResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception('Failed to load data!');
    }
  }

}