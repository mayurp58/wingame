import 'encrypt_service.dart';
class LoginResponseModel {
  final String str;

  LoginResponseModel({required this.str});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      str: json["str"] != null ? decryp(json["str"]) : ""
    );
  }
}