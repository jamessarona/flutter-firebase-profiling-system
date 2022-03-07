import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanood/net/authenticationService.dart';
import 'package:tanood/shared/constants.dart';
import 'package:tanood/shared/myButtons.dart';
import 'package:tanood/shared/myCards.dart';
import 'package:tanood/shared/mySpinKits.dart';

class TanodsStatusScreen extends StatefulWidget {
  final String userUID;
  final VoidCallback onSignOut;
  final BaseAuth auth;
  const TanodsStatusScreen({
    required this.userUID,
    required this.onSignOut,
    required this.auth,
  });

  @override
  _TanodsStatusScreenState createState() => _TanodsStatusScreenState();
}

class _TanodsStatusScreenState extends State<TanodsStatusScreen> {
  late Size screenSize;
  final dbRef = FirebaseDatabase.instance.reference();
  var tanods;
  var filteredTanods;
  var locations;
  TextEditingController _searchTextEditingController = TextEditingController();

  bool isLoading = false;

  bool checkIsUser(String uid) {
    bool isUser = false;
    if (widget.userUID == uid) {
      isUser = true;
    }
    return isUser;
  }

  _buildCreateUpdateConfirmaModal(
    BuildContext context,
    String tanodUID,
    String tanodId,
    String name,
    bool isDisabled,
    String selectedTanodEmail,
  ) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: Text(
                'Confirmation',
                style: tertiaryText.copyWith(fontSize: 18),
              ),
              content: Text.rich(
                TextSpan(
                  style: secandaryText.copyWith(fontSize: 13, letterSpacing: 0),
                  children: [
                    TextSpan(
                      text: 'Do you want to ',
                      style: secandaryText.copyWith(
                          fontSize: 14, letterSpacing: 0),
                    ),
                    TextSpan(
                      text: '${isDisabled ? 'Activate' : 'Disable'}',
                      style: secandaryText.copyWith(
                        fontSize: 14,
                        letterSpacing: 0,
                        color: isDisabled ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' the account',
                      style: secandaryText.copyWith(
                          fontSize: 14, letterSpacing: 0),
                    ),
                    TextSpan(
                      text: ' $name',
                      style: secandaryText.copyWith(
                        fontSize: 14,
                        letterSpacing: 0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '?',
                      style: secandaryText.copyWith(
                          fontSize: 14, letterSpacing: 0),
                    ),
                  ],
                ),
              ),
              actions: [
                Container(
                  width: 100,
                  child: MyOutlineButton(
                    color: Color(0xff1640ac),
                    elavation: 5,
                    isLoading: false,
                    radius: 10,
                    text: Text(
                      'Cancel',
                      style: tertiaryText.copyWith(
                          fontSize: 14, color: customColor[140]),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  width: 100,
                  child: MyRaisedButton(
                    color: Color(0xff1640ac),
                    elavation: 5,
                    isLoading: isLoading,
                    radius: 10,
                    text: Text(
                      'Update',
                      style: tertiaryText.copyWith(
                          fontSize: 14, color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        isLoading = true;

                        _updateSelectedTanodStatus(tanodId, tanodUID,
                                isDisabled, selectedTanodEmail)
                            .then((value) {
                          Navigator.pop(context);
                          isLoading = false;
                        });
                      });
                    },
                  ),
                ),
              ],
            );
          });
        });
  }

  Future<String> _updateSelectedTanodStatus(String tanodId, String tanodUID,
      bool isDisabled, String selectedTanodEmail) async {
    await dbRef.child('Tanods').child(tanodId).update({
      'Status': isDisabled ? 'Standby' : 'Disabled',
    });
    return '';
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
            stream: dbRef.child('Locations').onValue,
            builder: (context, locationsSnapshot) {
              if (locationsSnapshot.hasData &&
                  !locationsSnapshot.hasError &&
                  (locationsSnapshot.data! as Event).snapshot.value != null) {
                locations = (locationsSnapshot.data! as Event).snapshot.value;
              } else {
                return MySpinKitLoadingScreen();
              }
              return StreamBuilder(
                  stream: dbRef.child('Tanods').onValue,
                  builder: (context, tanodsSnapshot) {
                    if (tanodsSnapshot.hasData &&
                        !tanodsSnapshot.hasError &&
                        (tanodsSnapshot.data! as Event).snapshot.value !=
                            null) {
                      tanods = (tanodsSnapshot.data! as Event).snapshot.value;
                    } else {
                      return MySpinKitLoadingScreen();
                    }
                    filteredTanods =
                        filterTanods(tanods, _searchTextEditingController.text);

                    return Container(
                      height: screenSize.height,
                      width: screenSize.width,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              top: 15,
                              bottom: 15,
                              left: screenSize.width * .06,
                              right: screenSize.width * .06,
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
                                for (var item in filteredTanods)
                                  MyTanodCard(
                                    name:
                                        "${item['Firstname']} ${item['Lastname']}",
                                    isUser: checkIsUser(item['TanodUID']),
                                    gender: item['Gender'],
                                    location: getLocationName(
                                        locations, item['LocationId']),
                                    status: item['Status'],
                                    onTap: () {
                                      _buildCreateUpdateConfirmaModal(
                                        context,
                                        item['TanodUID'],
                                        item['TanodId'],
                                        "${item['Firstname']} ${item['Lastname']}",
                                        item['Status'] != 'Disabled'
                                            ? false
                                            : true,
                                        item['Email'],
                                      );
                                    },
                                    isDisabled: item['Status'] != 'Disabled'
                                        ? false
                                        : true,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
