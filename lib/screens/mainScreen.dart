import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanod_apprehension/net/authenticationService.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/myAppbar.dart';
import 'package:tanod_apprehension/shared/myButtons.dart';
import 'package:tanod_apprehension/shared/myCards.dart';
import 'package:tanod_apprehension/shared/myContainers.dart';
import 'package:tanod_apprehension/shared/myDrawers.dart';
import 'package:tanod_apprehension/shared/mySpinKits.dart';

class MainScreen extends StatefulWidget {
  final String? leading;
  final BaseAuth auth;
  final VoidCallback onSignOut;
  MainScreen({this.leading, required this.auth, required this.onSignOut});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Size screenSize;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final dbRef = FirebaseDatabase.instance.reference();

  var reports;
  var userData;
  String userUID = '';
  String selectedArea = 'Maharlika NHA Maa';
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<String> getCurrentUserUID() async {
    final User? user = auth.currentUser;
    return user!.uid.toString();
  }

  void saveSelectedArea() async {
    dbRef.child('Tanods').child(userUID).update({
      'Area': selectedArea,
    });
  }

  _buildCreateOrderModal(BuildContext context) {
    String tempSelectedArea = selectedArea;
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: Text(
                'Set Location',
                style: tertiaryText.copyWith(fontSize: 18),
              ),
              content: DropdownButton<String>(
                value: selectedArea,
                items: <String>[
                  'Maharlika NHA Maa',
                  'Silver St. San Rafael',
                  'Juario Compound'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    tempSelectedArea = newValue!;
                  });
                },
              ),
              actions: [
                MyOutlineButton(
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
                MyRaisedButton(
                  color: Color(0xff1640ac),
                  elavation: 5,
                  isLoading: false,
                  radius: 10,
                  text: Text(
                    'Save',
                    style: tertiaryText.copyWith(
                        fontSize: 14, color: Colors.white),
                  ),
                  onPressed: () {
                    selectedArea = tempSelectedArea;
                    saveSelectedArea();
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
        });
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    setState(() {
      getCurrentUserUID().then((valueID) {
        setState(() {
          userUID = valueID;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: userUID.isNotEmpty
          ? StreamBuilder(
              stream: dbRef.child('Tanods').child(userUID).onValue,
              builder: (context, userSnapshot) {
                if (userSnapshot.hasData &&
                    !userSnapshot.hasError &&
                    (userSnapshot.data! as Event).snapshot.value != null) {
                  userData = (userSnapshot.data! as Event).snapshot.value;
                  if (userData['Area'] != null) {
                    selectedArea = userData['Area'];
                  }
                } else {
                  return Scaffold(
                    body: Center(
                      child: MySpinKitLoadingScreen(),
                    ),
                  );
                }
                return StreamBuilder(
                    stream: dbRef.child('Reports').onValue,
                    builder: (context, reportsSnapshot) {
                      if (reportsSnapshot.hasData &&
                          !reportsSnapshot.hasError &&
                          (reportsSnapshot.data! as Event).snapshot.value !=
                              null) {
                        reports =
                            (reportsSnapshot.data! as Event).snapshot.value;
                      } else {
                        return Scaffold(
                          body: Center(
                            child: MySpinKitLoadingScreen(),
                          ),
                        );
                      }
                      int notifCount =
                          countReportsByLocation(reports, selectedArea);
                      return Scaffold(
                        key: _scaffoldKey,
                        extendBodyBehindAppBar: true,
                        resizeToAvoidBottomInset: false,
                        drawer: BuildDrawer(
                          leading: "Home",
                          auth: widget.auth,
                          onSignOut: widget.onSignOut,
                          name:
                              "${userData['Firstname']} ${userData['Lastname']}",
                          email: userData['Email'],
                          profileImage: userData['Image'],
                          backgroundImage:
                              "https://wallpaperaccess.com/full/1397098.jpg",
                          selectedArea: selectedArea,
                        ),
                        body: Container(
                          height: screenSize.height,
                          width: screenSize.width,
                          color: customColor[110],
                          child: ListView(
                            children: [
                              MyMainAppBar(
                                onPressendDrawer: () {
                                  _scaffoldKey.currentState!.openDrawer();
                                },
                                notifCount: notifCount,
                              ),
                              MyUserDetail(
                                  image: userData['Image'],
                                  firstname: userData['Firstname'],
                                  selectedArea: selectedArea,
                                  onTap: () {
                                    _buildCreateOrderModal(context);
                                  }),
                              MyStatusCard(
                                name:
                                    "${userData['Firstname']} ${userData['Lastname']}",
                                image: userData['Image'],
                                status: userData['Status'],
                                email: userData['Email'],
                                auth: widget.auth,
                                onSignOut: widget.onSignOut,
                                selectedArea: selectedArea,
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 25,
                                  left: 20,
                                  right: 20,
                                ),
                                width: screenSize.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        left: 4,
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        "Information",
                                        style: tertiaryText.copyWith(
                                            fontSize: 16, letterSpacing: 0),
                                      ),
                                    ),
                                    MyInformationCard(
                                      icon: Icon(
                                        FontAwesomeIcons.folderOpen,
                                        color: customColor[130],
                                      ),
                                      text: "Assignment History",
                                      onTap: () {},
                                    ),
                                    MyInformationCard(
                                      icon: Icon(
                                        FontAwesomeIcons.addressBook,
                                        color: customColor[130],
                                      ),
                                      text: "Violators",
                                      onTap: () {},
                                    ),
                                    MyInformationCard(
                                      icon: Icon(
                                        FontAwesomeIcons.user,
                                        color: customColor[130],
                                      ),
                                      text: "My Account",
                                      onTap: () {},
                                    ),
                                    Container(height: 10),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              })
          : Scaffold(
              body: Center(
                child: MySpinKitLoadingScreen(),
              ),
            ),
    );
  }
}
