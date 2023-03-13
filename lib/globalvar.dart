library ankgame.globalvar;

bool isLoggedIn = false;
String? user_id = "0";
String? mobile_number = "0";
String? token = null;
String? device_id = null;
String? support_number = "0";
String? balance = "0";

String? min_withdraw = "0";
String? min_deposit = "0";
List<dynamic> marketnames =[];
List<Map<String, dynamic>> pannadetails = [];
int tabval = 0;
int tabbarphysics = 0;
String? firebase_token = "";
String? payment_gateway_url = "";

String? reg_mobile;
String? reg_mpin;
String? reg_email;
String? reg_device;
int gametyp = 0;
String? congrats;

//colors defination

String color_pink = "#ff66c4";
String color_green = "#b1e50e";
String color_black = "#000000";
String color_blue = "#514ed8";
String color_white = "#FFFFFF";
String color_background = "#1b1e2d";