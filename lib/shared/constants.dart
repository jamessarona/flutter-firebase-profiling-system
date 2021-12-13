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
  30: Color(0xfff9f9f9), //grey card background
  40: Color(0xffe3d2f5), // custom light violet color
  50: Color(0xff5333a4), //custom dark violet color
  60: Color(0xff4243e6), //constant bluee color
  70: Color(0xff9030f4), //constant violet color
  80: Color(0xfff09a1c), //custom yellow/orange color
  90: Color(0xffeb001b), //custom red color
  100: Color(0xff5633a7), //custom color dark violet
});

String titleCase(String text) {
  if (text.length <= 1) return text.toUpperCase();
  var words = text.split(' ');
  var capitalized = words.map((word) {
    var first = word.substring(0, 1).toUpperCase();
    var rest = word.substring(1);
    return '$first$rest';
  });
  return capitalized.join(' ');
}

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach =>
      this.split(" ").map((str) => str.inCaps).join(" ");
}

String calculateTimeOfOccurence(String date) {
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  DateTime now = new DateTime.now();
  DateTime dateDetected = DateTime.parse(date);
  print(now);
  String time = "";
  if (now.year.compareTo(dateDetected.year) == 0) {
    print("Same Year");
    if (now.month.compareTo(dateDetected.month) == 0) {
      print("Same Month");
      if (now.day.compareTo(dateDetected.day) == 0) {
        print("Same Day");
        if (now.hour.compareTo(dateDetected.hour) == 0) {
          print("Same Hour");
          if (now.minute.compareTo(dateDetected.minute) == 0) {
            time = "1m ago";
          } else {
            time = "${(now.minute - dateDetected.minute).toString()}m";
          }
        } else {
          time = "${(now.hour - dateDetected.hour).toString()}h";
        }
      } else {
        time = "${(now.day - dateDetected.day).toString()}d";
      }
    } else {
      String monthName = months[dateDetected.month - 1][0] +
          months[dateDetected.month - 1][1] +
          months[dateDetected.month - 1][2];
      time = "$monthName ${dateDetected.day}";
    }
  } else {
    String monthName = months[dateDetected.month - 1][0] +
        months[dateDetected.month - 1][1] +
        months[dateDetected.month - 1][2];
    time = "$monthName ${dateDetected.day}, ${dateDetected.year}";
  }
  return time;
}
