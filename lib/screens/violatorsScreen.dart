import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanod_apprehension/screens/detailViolatorScreen.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/myCards.dart';
import 'package:tanod_apprehension/shared/mySpinKits.dart';

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
            builder: (context, violatorsSnapshot) {
              if (violatorsSnapshot.hasData &&
                  !violatorsSnapshot.hasError &&
                  (violatorsSnapshot.data! as Event).snapshot.value != null) {
                violators = (violatorsSnapshot.data! as Event).snapshot.value;
              } else {
                return MySpinKitLoadingScreen();
              }
              var filteredViolators =
                  filterViolators(violators, _searchTextEditingController.text);

              return Container(
                height: screenSize.height,
                width: screenSize.width,
                margin: EdgeInsets.only(
                  left: screenSize.width * .01,
                  right: screenSize.width * .01,
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: 15,
                        bottom: 15,
                        left: screenSize.width * .05,
                        right: screenSize.width * .05,
                      ),
                      child: TextFormField(
                        controller: _searchTextEditingController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        validator: (value) {},
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: 'Search',
                          hintStyle: tertiaryText.copyWith(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                          suffix: GestureDetector(
                            onTap: () {
                              setState(() {
                                _searchTextEditingController.clear();
                              });
                            },
                            child: Text(
                              'X',
                              style: tertiaryText.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
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
                    Expanded(
                      child: ListView(
                        children: [
                          for (var item in filteredViolators)
                            MyViolatorCard(
                              name: item['Name'],
                              gender: item['Gender'],
                              age: calculateAge(item['Birthday']),
                              onTap: () {
                                print('Load Specific Violator');
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => DetailViolatorScreen(
                                      id: item['ViolatorId'].toString(),
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
