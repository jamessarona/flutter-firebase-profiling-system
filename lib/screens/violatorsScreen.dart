import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/mySpinKits.dart';
import 'package:tanod_apprehension/shared/myTextFormFields.dart';

class ViolatorsScreen extends StatefulWidget {
  const ViolatorsScreen({Key? key}) : super(key: key);

  @override
  _ViolatorsScreenState createState() => _ViolatorsScreenState();
}

class _ViolatorsScreenState extends State<ViolatorsScreen> {
  late Size screenSize;
  final dbRef = FirebaseDatabase.instance.reference();
  var violators;
  TextEditingController _searchTextEditingController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              FontAwesomeIcons.chevronLeft,
              color: Colors.black,
              size: 18,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text(
            'Violators',
            style: primaryText.copyWith(fontSize: 18, letterSpacing: 1),
          ),
        ),
        body: StreamBuilder(
            stream: dbRef.child('Violators').onValue,
            builder: (context, reportsSnapshot) {
              if (reportsSnapshot.hasData &&
                  !reportsSnapshot.hasError &&
                  (reportsSnapshot.data! as Event).snapshot.value != null) {
                violators = (reportsSnapshot.data! as Event).snapshot.value;
              } else {
                return MySpinKitLoadingScreen();
              }
              return Container(
                height: screenSize.height,
                width: screenSize.width,
                child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: 15,
                        left: screenSize.width * .1,
                        right: screenSize.width * .1,
                      ),
                      child: TextFormField(
                        controller: _searchTextEditingController,
                        keyboardType: TextInputType.text,
                        validator: (value) {},
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: 'Search',
                          hintText: 'Search',
                          hintStyle: tertiaryText.copyWith(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                          //TODO: Make a search input box. Last Edit
                          suffixIcon: Icon(FontAwesomeIcons.walking),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Color(0xff1c52dd),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Colors.white70,
                        ),
                      ),
                    ),
                    for (var item in violators)
                      Card(
                        child: ListTile(
                          dense: true,
                          leading: Container(
                            height: 40,
                            width: 40,
                            child: Image.asset(
                              "assets/images/${item['Gender'] == 'Female' ? 'woman' : 'man'}.png",
                              width: 20,
                              height: 20,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          title: Text(
                            item['Name'],
                            style: tertiaryText.copyWith(
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Text(
                            "${calculateAge(item['Birthday'])} year's old",
                            style: tertiaryText.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
