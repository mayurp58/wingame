
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wingame/globalvar.dart' as globals;

class ThemeHelper{

  InputDecoration textInputDecoration([String lableText="", String hintText = ""]){
    return InputDecoration(
      //labelText: lableText,
      hintText: hintText,
      fillColor: Colors.white,
      counterText: "",
      filled: true,
      floatingLabelStyle: TextStyle(color: HexColor("#BD7923")),
      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(60.0), borderSide: BorderSide(color: Colors.grey)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(60.0), borderSide: BorderSide(color: Colors.grey.shade400)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(60.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(60.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
    );
  }

  TextStyle textStyle()
  {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: HexColor("#000000")
    );
  }

  InputDecoration gameplayInputDecoration([String lableText="", String prefix = ""]){
    return InputDecoration(
      fillColor: Colors.white,
      hintText: "Point",
      hintStyle: TextStyle(color: Colors.grey[300]),
      prefixIcon: Padding(
        padding: EdgeInsets.fromLTRB(5,12,0,0),
        child: RichText(text: TextSpan(
          children: [
            TextSpan(text: prefix + "  ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.grey),),
          ],
        ),
        ),
      ),
      counterText: "",
      filled: true,
      floatingLabelStyle: TextStyle(color: Colors.black),
      contentPadding: EdgeInsets.fromLTRB(0,0,0,0),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.black)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.black)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
    );
  }

  InputDecoration customInputDecoration([String lableText="", String prefix = ""]){
    return InputDecoration(
      fillColor: Colors.white,
      hintText: lableText,
      hintStyle: TextStyle(color: Colors.grey[400],),
      /*prefixIcon: Padding(
        padding: EdgeInsets.fromLTRB(0,12,0,0),
        child: RichText(text: TextSpan(
          children: [
            TextSpan(text: prefix + "  ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.grey),),
          ],
        ),
        ),
      ),*/
      counterText: "",
      filled: true,
      floatingLabelStyle: TextStyle(color: Colors.black),
      contentPadding: EdgeInsets.symmetric(horizontal: 5),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.grey)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.grey.shade400)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
    );
  }

  BoxDecoration inputBoxDecorationShaddow() {
    return BoxDecoration(boxShadow: [
      BoxShadow(
        color: HexColor("#FEDB87").withOpacity(0.1),
        blurRadius: 20,
        offset: const Offset(0, 5),
      )
    ]);
  }

  BoxDecoration buttonBoxDecoration(BuildContext context, [String color1 = "", String color2 = ""]) {
    Color c1 = HexColor(globals.color_pink);
    Color c2 = HexColor(globals.color_blue);
    if (color1.isEmpty == false) {
      c1 = HexColor(color1);
    }
    if (color2.isEmpty == false) {
      c2 = HexColor(color2);
    }

    return BoxDecoration(
      boxShadow: [
        BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
      ],
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.0, 1.0],
        colors: [
          c1,
          c2,

        ],
      ),
      borderRadius: BorderRadius.circular(30),
    );
  }

  ButtonStyle buttonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      minimumSize: MaterialStateProperty.all(Size(50, 50)),
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      shadowColor: MaterialStateProperty.all(Colors.transparent),
    );
  }

  ButtonStyle separatebuttonStyle_bordered() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: HexColor("#FEDB87")),
        ),
      ),
      minimumSize: MaterialStateProperty.all(Size(50, 50)),
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      shadowColor: MaterialStateProperty.all(HexColor("#ccc")),
    );
  }

  ButtonStyle separatebuttonStyle_filled() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      minimumSize: MaterialStateProperty.all(Size(50, 50)),
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      shadowColor: MaterialStateProperty.all(HexColor("#ccc")),
    );
  }

  ButtonStyle filled_square_button() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.0),
            side: BorderSide(color: HexColor("#FEDB87"))
        ),
      ),
      minimumSize: MaterialStateProperty.all(Size(40, 40)),
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      shadowColor: MaterialStateProperty.all(HexColor("#ccc")),
    );
  }

  AlertDialog alartDialog(String title, String content, BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black38)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

}

class LoginFormStyle{

}