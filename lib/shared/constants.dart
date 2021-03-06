import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tanood/shared/globals.dart';

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
  110: Color(0xfffafcff), //white background
  120: Color(0xffe4e8f2), //grey theme
  130: Color(0xff1c52dd), //blue theme
  140: Color(0xff1640ac), //dark blue theme
  150: Color(0xff6400e3), //violet theme
  160: Color(0xff1cdd69), //green theme
  170: Color(0xffdd901c), //orange theme
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

Future<String> getCurrentUserUID() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  return user!.uid.toString();
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
  String time = "";
  if (now.year.compareTo(dateDetected.year) == 0) {
    if (now.month.compareTo(dateDetected.month) == 0) {
      if (now.day.compareTo(dateDetected.day) == 0) {
        if (now.hour.compareTo(dateDetected.hour) == 0) {
          if (now.minute.compareTo(dateDetected.minute) == 0) {
            time = "1m";
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

int countReportsByLocation(List<dynamic> list, String locationId) {
  int count = 0;
  for (int i = 0; i < list.length; i++) {
    if (list[i]['LocationId'] == locationId &&
        list[i]['Category'] == "Latest" &&
        list[i]['AssignedTanod'] == null) {
      count++;
    }
  }
  return count;
}

String convertMonth(int month) {
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
  String monthName =
      months[month - 1][0] + months[month - 1][1] + months[month - 1][2];
  return monthName;
}

String convertHour(int hour, int method) {
  //method
  // 0 = get hour
  // 1 = get AM/PM
  if (hour > 12) {
    hour -= 12;
    if (method == 0) {
      return (hour < 10 ? '0' : '') + hour.toString();
    } else {
      return "PM";
    }
  } else if (hour == 12) {
    if (method == 0) {
      return hour.toString();
    } else {
      return "PM";
    }
  } else {
    if (method == 0) {
      return (hour < 10 ? '0' : '') + hour.toString();
    } else {
      return "AM";
    }
  }
}

List filterReport(String category, List reports) {
  bool isFiltered = false;

  for (int i = 0; i < reports.length; i++) {
    if (reports[i]['Category'] == category) {
      if (filters['Date']['Start'] ||
          filters['Date']['End'] ||
          filters['Area']['Tarape\'s Store'] ||
          filters['Area']['ShopStrutt.ph'] ||
          filters['Area']['Melchor\'s Store']) isFiltered = true;
    }
  }

  int len = 0;

  for (int i = 0; i < reports.length; i++) {
    if (reports[i]['Category'] == category) {
      if (isFiltered) {
        if (filters['Date']['Start'] &&
            filters['Date']['End'] &&
            start != null &&
            end != null &&
            DateTime.parse(reports[i]['Date']).compareTo(start!) >= 0 &&
            DateTime.parse(reports[i]['Date']).compareTo(end!) <= 0) {
          len++;
        } else if (filters['Date']['Start'] &&
            end == null &&
            DateTime.parse(reports[i]['Date']).compareTo(start!) >= 0) {
          len++;
        } else if (filters['Date']['End'] &&
            start == null &&
            DateTime.parse(reports[i]['Date']).compareTo(end!) <= 0) {
          len++;
        } else if (filters['Area']['Tarape\'s Store'] &&
            reports[i]['LocationId'] == 'Tarape\'s Store') {
          len++;
        } else if (filters['Area']['ShopStrutt.ph'] &&
            reports[i]['LocationId'] == 'ShopStrutt.ph') {
          len++;
        } else if (filters['Area']['Melchor\'s Store'] &&
            reports[i]['LocationId'] == 'Melchor\'s Store') {
          len++;
        }
      } else {
        len++;
      }
    }
  }

  var filterReport = new List.filled(len, []);
  int x = 0;

  for (int i = 0; i < reports.length; i++) {
    if (reports[i]['Category'] == category) {
      if (isFiltered) {
        if (filters['Date']['Start'] &&
            filters['Date']['End'] &&
            start != null &&
            end != null &&
            DateTime.parse(reports[i]['Date']).compareTo(start!) >= 0 &&
            DateTime.parse(reports[i]['Date']).compareTo(end!) <= 0) {
          filterReport[x++].add(reports[i]);
        } else if (filters['Date']['Start'] &&
            end == null &&
            DateTime.parse(reports[i]['Date']).compareTo(start!) >= 0) {
          filterReport[x++].add(reports[i]);
        } else if (filters['Date']['End'] &&
            start == null &&
            DateTime.parse(reports[i]['Date']).compareTo(end!) <= 0) {
          filterReport[x++].add(reports[i]);
        } else if (filters['Area']['Tarape\'s Store'] &&
            reports[i]['LocationId'] == 'Tarape\'s Store') {
          filterReport[x++].add(reports[i]);
        } else if (filters['Area']['ShopStrutt.ph'] &&
            reports[i]['LocationId'] == 'ShopStrutt.ph') {
          filterReport[x++].add(reports[i]);
        } else if (filters['Area']['Melchor\'s Store'] &&
            reports[i]['LocationId'] == 'Melchor\'s Store') {
          filterReport[x++].add(reports[i]);
        }
      } else {
        filterReport[x++].add(reports[i]);
      }
    }
  }

  return filterReport;
}

List filterPreferenceReport(List<dynamic> list, String locationId) {
  int len = 0;
  for (int i = 0; i < list.length; i++) {
    if (locationId == list[i]['LocationId'] &&
        list[i]['Category'] == "Latest" &&
        list[i]['AssignedTanod'] == null) {
      len++;
    }
  }

  var filterReport = new List.filled(len, []);
  int x = 0;

  for (int i = 0; i < list.length; i++) {
    if (locationId == list[i]['LocationId'] &&
        list[i]['Category'] == "Latest" &&
        list[i]['AssignedTanod'] == null) {
      filterReport[x++].add(list[i]);
    }
  }
  return filterReport;
}

List getSelectedReportInformation(List<dynamic> list, String id) {
  var selectedReport = new List.filled(1, []);
  for (int i = 0; i < list.length; i++) {
    if (list[i]['Id'].toString().compareTo(id) == 0) {
      selectedReport[0].add(list[i]);
      break;
    }
  }
  return selectedReport[0];
}

String setDateTime(String date, String method) {
  late DateTime dateTimeAssigned = DateTime.parse(date);
  if (date != '') {
    if (method == 'Date') {
      return "${convertMonth(dateTimeAssigned.month)} ${dateTimeAssigned.day}, ${dateTimeAssigned.year}";
    } else {
      return "${convertHour(dateTimeAssigned.hour, 0)}:${dateTimeAssigned.minute}:${dateTimeAssigned.second} ${convertHour(dateTimeAssigned.hour, 1)}";
    }
  }
  return '';
}

String getViolatorSpecifiedInformation(
    List<dynamic> list, String? id, String specific) {
  String name = "";
  for (int i = 0; i < list.length; i++) {
    if (list[i]['ViolatorId'].toString() == id) {
      name = list[i][specific];
    }
  }
  return name;
}

List filterCurrentUserInformation(List<dynamic> list, String tanodUID) {
  var filterCurrentUser = new List.filled(1, []);
  for (int i = 0; i < list.length; i++) {
    if (list[i]['TanodUID'] == tanodUID) {
      filterCurrentUser[0].add(list[i]);
    }
  }
  return filterCurrentUser[0];
}

List filterViolators(List<dynamic> list, String search) {
  if (search != '') {
    int count = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i]['Name'].toLowerCase().contains(search.toLowerCase())) {
        count++;
      }
    }

    var filteredViolators = new List.filled(count, []);
    int x = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i]['Name'].toLowerCase().contains(search.toLowerCase())) {
        filteredViolators[x++].add(list[i]);
      }
    }

    return filteredViolators.isNotEmpty
        ? (filteredViolators[0]..sort((a, b) => a['Name'].compareTo(b['Name'])))
        : [];
  } else {
    return list..sort((a, b) => a['Name'].compareTo(b['Name']));
  }
}

List filterTanods(List<dynamic> list, String search) {
  if (search != '') {
    int count = 0;
    for (int i = 0; i < list.length; i++) {
      if (("${list[i]['Firstname']} ${list[i]['Lastname']}")
          .toLowerCase()
          .contains(search.toLowerCase())) {
        count++;
      }
    }

    var filteredTanods = new List.filled(count, []);
    int x = 0;
    for (int i = 0; i < list.length; i++) {
      if (("${list[i]['Firstname']} ${list[i]['Lastname']}")
          .toLowerCase()
          .contains(search.toLowerCase())) {
        filteredTanods[x++].add(list[i]);
      }
    }

    return filteredTanods.isNotEmpty
        ? (filteredTanods[0]
          ..sort((a, b) => "${a['Firstname']} ${a['Lastname']}"
              .compareTo("${b['Firstname']} ${b['Lastname']}")))
        : [];
  } else {
    return list
      ..sort((a, b) => "${a['Firstname']} ${a['Lastname']}"
          .compareTo("${b['Firstname']} ${b['Lastname']}"));
  }
}

List filterLocations(List<dynamic> list, String search) {
  if (search != '') {
    int count = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i]['Name'].toLowerCase().contains(search.toLowerCase())) {
        count++;
      }
    }

    var filteredLocations = new List.filled(count, []);
    int x = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i]['Name'].toLowerCase().contains(search.toLowerCase())) {
        filteredLocations[x++].add(list[i]);
      }
    }
    return filteredLocations.isNotEmpty ? filteredLocations[0] : [];
    // return filteredLocations.isNotEmpty
    //     ? (filteredLocations[0]..sort((a, b) => a['Name'].compareTo(a['Name'])))
    //     : [];
  } else {
    return list;
    // return list..sort((a, b) => a['Name'].compareTo(b['Name']));
  }
}

List filterReportByViolator(List<dynamic> list, String id) {
  int count = 0;
  for (int i = 0; i < list.length; i++) {
    if (list[i]['AssignedTanod'] != null) {
      for (int x = 0; x < list[i]['AssignedTanod'].length; x++) {
        if (list[i]['AssignedTanod'][x]['Documentation'] != null) {
          for (int y = 0;
              y < list[i]['AssignedTanod'][x]['Documentation'].length;
              y++) {
            if (list[i]['AssignedTanod'][x]['Documentation'][y]['ViolatorId'] ==
                id) {
              count++;
            }
          }
        }
      }
    }
  }
  var filteredReport = new List.filled(count, []);
  int z = 0;
  for (int i = 0; i < list.length; i++) {
    if (list[i]['AssignedTanod'] != null) {
      for (int x = 0; x < list[i]['AssignedTanod'].length; x++) {
        if (list[i]['AssignedTanod'][x]['Documentation'] != null) {
          for (int y = 0;
              y < list[i]['AssignedTanod'][x]['Documentation'].length;
              y++) {
            if (list[i]['AssignedTanod'][x]['Documentation'][y]['ViolatorId'] ==
                id) {
              filteredReport[z++].add(list[i]);
            }
          }
        }
      }
    }
  }

  return filteredReport;
}

int calculateAge(String birthday) {
  DateTime currentDate = DateTime.now();

  DateTime birthDate = DateTime.parse(birthday);
  int age = currentDate.year - birthDate.year;
  int month1 = currentDate.month;
  int month2 = birthDate.month;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = birthDate.day;
    if (day2 > day1) {
      age--;
    }
  }
  return age;
}

String numberFormat(int number) {
  if (number >= 0 && number < 10) {
    return '0$number';
  }
  return number.toString();
}

String getLocationName(List list, String id) {
  String locationName = '';
  for (int i = 0; i < list.length; i++) {
    if (list[i]['LocationId'] == id) {
      locationName = list[i]['Name'];
    }
  }
  return locationName;
}
