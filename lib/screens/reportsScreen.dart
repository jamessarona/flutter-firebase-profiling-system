import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tanood/net/authenticationService.dart';
import 'package:tanood/screens/detailReportScreen.dart';
import 'package:tanood/screens/notificationScreen.dart';
import 'package:tanood/screens/reportScreens/activeScreen.dart';
import 'package:tanood/shared/constants.dart';
import 'package:tanood/shared/loadingWidgets.dart';
import 'package:tanood/shared/myAppbar.dart';
import 'package:tanood/shared/myBottomSheet.dart';
import 'package:tanood/shared/myDrawers.dart';
import 'reportScreens/droppedScreen.dart';
import 'reportScreens/taggedScreen.dart';

class ReportsScreen extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignOut;
  final String userUID;
  final String tanodId;
  final String name;
  final String email;
  final String profileImage;
  final int defaultIndex;
  final String role;
  const ReportsScreen({
    required this.auth,
    required this.onSignOut,
    required this.userUID,
    required this.tanodId,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.defaultIndex,
    required this.role,
  });

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

late BaseAuth auth;
late VoidCallback onSignOut;
var reports;
var locations;
var userData;

final List locationsAdded = [];

late Size screenSize;
final dbRef = FirebaseDatabase.instance.reference();
int notifCount = 0;
int currentIndex = 0;
GlobalKey<ScaffoldState> _scaffoldKeyReports = GlobalKey<ScaffoldState>();
String userUID = '';
bool isResponding = false;

int addLocationCycle = 0;
void addLocationToList() {
  for (int i = 0; i < locations.length; i++) {
    locationsAdded.insert(0, {locations[i]['Name'].toString(): false});
  }
}

String _getCurrentAssignReport() {
  String id = '';
  for (int i = 0; i < reports.length; i++) {
    if (reports[i]['AssignedTanod'] != null &&
        reports[i]['AssignedTanod'] != null) {
      if (reports[i]['AssignedTanod'][reports[i]['AssignedTanod'].length - 1]
                      ['TanodId']
                  .toString() ==
              userData['TanodId'].toString() &&
          reports[i]['AssignedTanod'][reports[i]['AssignedTanod'].length - 1]
                  ['Status'] ==
              'Responding') {
        id = reports[i]['Id'];
      }
    }
  }
  return id;
}

List<StatefulWidget> screens = [
  ActiveScreen(
    userUID: userUID,
    auth: auth,
    onSignOut: onSignOut,
  ),
  DroppedScreen(
    userUID: userUID,
    auth: auth,
    onSignOut: onSignOut,
  ),
  TaggedScreen(
    userUID: userUID,
    auth: auth,
    onSignOut: onSignOut,
  ),
];

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  void initState() {
    super.initState();
    currentIndex = widget.defaultIndex;
    auth = widget.auth;
    onSignOut = widget.onSignOut;
  }

  @override
  Widget build(BuildContext context) {
    userUID = widget.userUID;
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: StreamBuilder(
          stream: dbRef.child('Tanods').child(widget.tanodId).onValue,
          builder: (context, userDataSnapshot) {
            if (userDataSnapshot.hasData &&
                !userDataSnapshot.hasError &&
                (userDataSnapshot.data! as Event).snapshot.value != null) {
              userData = (userDataSnapshot.data! as Event).snapshot.value;
              isResponding = userData['Status'] == 'Responding';
            } else {
              return Scaffold(
                body: Center(
                  child: MyLoadingScreenReportScreen(),
                ),
              );
            }

            return StreamBuilder(
                stream: dbRef.child("Reports").onValue,
                builder: (context, reportsSnapshot) {
                  if (reportsSnapshot.hasData &&
                      !reportsSnapshot.hasError &&
                      (reportsSnapshot.data! as Event).snapshot.value != null) {
                    reports = (reportsSnapshot.data! as Event).snapshot.value;
                  } else {
                    return MyLoadingScreenReportScreen();
                  }
                  int notifCount =
                      countReportsByLocation(reports, userData['LocationId']);

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
                          return MyLoadingScreenReportScreen();
                        }
                        if (addLocationCycle < 1) {
                          addLocationCycle++;
                          addLocationToList();
                        }
                        return Scaffold(
                          key: _scaffoldKeyReports,
                          drawer: BuildDrawer(
                            leading: "Reports",
                            auth: widget.auth,
                            onSignOut: widget.onSignOut,
                            userUID: widget.userUID,
                            tanodId: widget.tanodId,
                            name: widget.name,
                            email: widget.email,
                            profileImage: widget.profileImage,
                            backgroundImage:
                                "https://wallpaperaccess.com/full/1397098.jpg",
                            role: widget.role,
                          ),
                          appBar: AppBar(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            leading: MyAppBarLeading(
                              onPressendDrawer: () {
                                _scaffoldKeyReports.currentState!.openDrawer();
                              },
                            ),
                            centerTitle: true,
                            title: Text(
                              'Reports',
                              style: primaryText.copyWith(
                                  fontSize: 18, letterSpacing: 1),
                            ),
                            actions: [
                              MyAppBarAction(
                                notifCount: notifCount,
                                color: Colors.black,
                                onPressed: () {
                                  Reset.filter();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => NotificationScreen(
                                        tanodId: userData['TanodId'],
                                        auth: widget.auth,
                                        onSignOut: widget.onSignOut,
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                          body: ListView(
                            children: [
                              Container(
                                color: Colors.grey[110],
                                width: screenSize.width,
                                child: screens[currentIndex],
                              ),
                            ],
                          ),
                          bottomNavigationBar: BottomNavigationBar(
                            currentIndex: currentIndex,
                            onTap: (index) {
                              setState(() {
                                currentIndex = index;
                              });
                            },
                            type: BottomNavigationBarType.fixed,
                            selectedItemColor: customColor[130],
                            selectedLabelStyle:
                                tertiaryText.copyWith(fontSize: 12),
                            unselectedItemColor: Colors.black38,
                            showUnselectedLabels: false,
                            items: [
                              BottomNavigationBarItem(
                                icon: Image.asset(
                                  'assets/images/hot-sale.png',
                                  width: 25,
                                  height: 25,
                                  fit: BoxFit.cover,
                                  color: currentIndex == 0
                                      ? customColor[130]
                                      : Colors.black38,
                                ),
                                //Icon(FontAwesomeIcons.fire),
                                label: "Latest",
                                tooltip: "New Violator",
                              ),
                              BottomNavigationBarItem(
                                icon: Image.asset(
                                  'assets/images/rejected.png',
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.cover,
                                  color: currentIndex == 1
                                      ? customColor[130]
                                      : Colors.black38,
                                ),
                                //Icon(FontAwesomeIcons.archive),
                                label: "Dropped",
                                tooltip: "Missed Violator",
                              ),
                              BottomNavigationBarItem(
                                icon: Image.asset(
                                  'assets/images/mace.png',
                                  width: 28,
                                  height: 28,
                                  fit: BoxFit.cover,
                                  color: currentIndex == 2
                                      ? customColor[130]
                                      : Colors.black38,
                                ),
                                //Icon(FontAwesomeIcons.userTag),
                                label: "Tagged",
                                tooltip: "Apprehended Violator",
                              ),
                            ],
                          ),
                          floatingActionButtonLocation:
                              FloatingActionButtonLocation.endFloat,
                          floatingActionButton: isResponding
                              ? FloatingActionButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (ctx) => DetailReportScreen(
                                          id: _getCurrentAssignReport(),
                                          isFromNotification: false,
                                          onSignOut: widget.onSignOut,
                                          auth: widget.auth,
                                        ),
                                      ),
                                    );
                                  },
                                  backgroundColor: customColor[130],
                                  child: SpinKitPouringHourGlassRefined(
                                    color: Colors.white,
                                    size: 35,
                                    strokeWidth: 1,
                                  ))
                              : Container(),
                        );
                      });
                });
          }),
    );
  }
}
