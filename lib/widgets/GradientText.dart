import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wingame/globalvar.dart' as globals;

class GradientText extends StatelessWidget {
  const GradientText(
      this.text, {
        //required this.gradient,
        this.style
      });

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
          begin: Alignment(1.0, -5.0),
          end: Alignment(1.0, 2.0),
          colors: [
        HexColor(globals.color_white),
        HexColor(globals.color_white),
        HexColor(globals.color_white),
      ]).createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}