import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/myButtons.dart';
import 'package:tanod_apprehension/shared/myCards.dart';
import 'package:tanod_apprehension/shared/mySpinKits.dart';
import 'package:tanod_apprehension/shared/myTextFormFields.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen();

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late Size screenSize;
  final dbRef = FirebaseDatabase.instance.reference();
  TextEditingController _searchTextEditingController = TextEditingController();
  TextEditingController _locationTextEditingController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var tanods;
  var locations;
  var filteredLocations;
  bool isLoading = false;
  late Timer _timer;
  int _countTanodAssigned(String location) {
    int count = 0;
    for (int i = 0; i < tanods.length; i++) {
      if (tanods[i]['Area'] == location) {
        count++;
      }
    }
    return count;
  }

  _buildCreateAddLocationForm(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: Text(
                'Add Location',
                style: tertiaryText.copyWith(fontSize: 18),
              ),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyDocumentationTextFormField(
                      inputType: TextInputType.name,
                      isObscureText: false,
                      textAction: TextInputAction.done,
                      validation: (value) {
                        if (value == '') {
                          return 'Location is empty';
                        }
                        if (checkIsLocationExist()) {
                          return 'Location is already added';
                        }
                      },
                      onChanged: (value) {},
                      onTap: () {},
                      prefixIcon: null,
                      labelText: 'Location',
                      hintText: "",
                      isReadOnly: false,
                      controller: _locationTextEditingController,
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
                      'Save',
                      style: tertiaryText.copyWith(
                          fontSize: 14, color: Colors.white),
                    ),
                    onPressed: () {
                      _validateSubmission();
                    },
                  ),
                ),
              ],
            );
          });
        });
  }

  _buildCreateDeleteConfirmation(
      BuildContext context, String loc, String locId) {
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
                  text: 'Are sure you want to delete ',
                  style: secandaryText.copyWith(fontSize: 13, letterSpacing: 0),
                  children: [
                    TextSpan(
                      text: loc,
                      style: secandaryText.copyWith(
                        fontSize: 13,
                        letterSpacing: 0,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '?',
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
                      'Delete',
                      style: tertiaryText.copyWith(
                          fontSize: 14, color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                        _reAssignTanodWithSelectedLocation(locId).then((value) {
                          _deleteSelectedLocation(locId).then((value) {
                            Navigator.pop(context);

                            _buildModalSuccessMessage(
                                context, "Location has been deleted");
                            isLoading = false;
                          });
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

  Future<String> _reAssignTanodWithSelectedLocation(String locationId) async {
    for (int i = 0; i < tanods.length; i++) {
      if (locations[int.parse(locationId)]['Name'] == tanods[i]['Area']) {
        await dbRef.child('Tanods').child(i.toString()).update({
          'Area': 'N/A',
        });
      }
    }
    return '';
  }

  Future<String> _deleteSelectedLocation(String locId) async {
    await dbRef.child('Locations').update({
      locId: {
        'Name': filteredLocations[filteredLocations.length - 1]['Name'],
        'LocationId': locId,
      },
    });
    await dbRef
        .child('Locations')
        .child((filteredLocations.length - 1).toString())
        .remove();
    return '';
  }

  bool checkIsLocationExist() {
    bool result = false;
    for (int i = 0; i < locations.length; i++) {
      if (locations[i]['Name'].toLowerCase() ==
          _locationTextEditingController.text.toLowerCase()) {
        result = true;
      }
    }
    return result;
  }

  void _validateSubmission() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
        _saveLocation().then((value) {
          _locationTextEditingController.clear();
          Navigator.pop(context);
          _buildModalSuccessMessage(context, "Location has been added");
          isLoading = false;
        });
      });
    }
  }

  Future<String> _saveLocation() async {
    await dbRef.child('Locations').update({
      locations.length.toString(): {
        'Name': titleCase(_locationTextEditingController.text.toString()),
        'LocationId': locations.length.toString(),
      },
    });
    isLoading = false;
    return '';
  }

  Future<void> _buildModalSuccessMessage(
      BuildContext context, String message) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        _timer = Timer(Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });
        return AlertDialog(
          backgroundColor: customColor[130],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          content: Container(
            height: 80,
            width: screenSize.width * .8,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    message,
                    style: tertiaryText.copyWith(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ]),
          ),
        );
      },
    ).then((value) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    });
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
            'Locations',
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
              return StreamBuilder(
                  stream: dbRef.child('Locations').onValue,
                  builder: (context, locationsSnapshot) {
                    if (locationsSnapshot.hasData &&
                        !locationsSnapshot.hasError &&
                        (locationsSnapshot.data! as Event).snapshot.value !=
                            null) {
                      locations =
                          (locationsSnapshot.data! as Event).snapshot.value;
                    } else {
                      return MySpinKitLoadingScreen();
                    }
                    filteredLocations = filterLocations(
                        locations, _searchTextEditingController.text);
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
                                for (var item in filteredLocations)
                                  MyLocationCard(
                                      locId: item['LocationId'],
                                      name: item['Name'],
                                      assignCount:
                                          _countTanodAssigned(item['Name']),
                                      onTap: () {
                                        _buildCreateDeleteConfirmation(context,
                                            item['Name'], item['LocationId']);
                                      }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _buildCreateAddLocationForm(context);
          },
          backgroundColor: customColor[130],
          child: Icon(
            FontAwesomeIcons.plus,
          ),
        ),
      ),
    );
  }
}
