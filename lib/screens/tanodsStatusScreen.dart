import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/myCards.dart';
import 'package:tanod_apprehension/shared/mySpinKits.dart';

class TanodsStatusScreen extends StatefulWidget {
  final String userUID;
  const TanodsStatusScreen({
    required this.userUID,
  });

  @override
  _TanodsStatusScreenState createState() => _TanodsStatusScreenState();
}

class _TanodsStatusScreenState extends State<TanodsStatusScreen> {
  late Size screenSize;
  final dbRef = FirebaseDatabase.instance.reference();
  var tanods;
  var filteredViolators;
  TextEditingController _searchTextEditingController = TextEditingController();

  String checkIsUser(String uid) {
    String value = '';
    if (widget.userUID == uid) {
      value = '(You)';
    }
    return value;
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
            'Tanods Activity',
            style: primaryText.copyWith(fontSize: 18, letterSpacing: 1),
          ),
        ),
        body: StreamBuilder(
            stream: dbRef.child('Tanods').onValue,
            builder: (context, tanodsSnapshot) {
              if (tanodsSnapshot.hasData &&
                  !tanodsSnapshot.hasError &&
                  (tanodsSnapshot.data! as Event).snapshot.value != null) {
                tanods = (tanodsSnapshot.data! as Event).snapshot.value;
              } else {
                return MySpinKitLoadingScreen();
              }
              filteredViolators =
                  filterTanods(tanods, _searchTextEditingController.text);

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
                            MyTanodCard(
                              name:
                                  "${item['Firstname']} ${item['Lastname']} ${checkIsUser(item['TanodUID'])}",
                              gender: item['Gender'],
                              status: item['Status'],
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
