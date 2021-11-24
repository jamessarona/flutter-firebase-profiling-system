import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle primaryText = GoogleFonts.lato(
  fontSize: 15,
  letterSpacing: 3,
  fontWeight: FontWeight.normal,
  color: Colors.black,
);

TextStyle secandaryText = GoogleFonts.montserrat(
  fontSize: 11,
  letterSpacing: 0,
  fontWeight: FontWeight.normal,
  color: Colors.black,
);

TextStyle tertiaryText = GoogleFonts.lato(
  fontSize: 11,
  letterSpacing: 0,
  fontWeight: FontWeight.normal,
  color: Colors.black,
);

const MaterialColor customColor = MaterialColor(0xff2470c7, <int, Color>{
  10: Color(0xfffed23e), //custom Orange
  20: Color(0xffeff0f5), //custom Grey for background
});
