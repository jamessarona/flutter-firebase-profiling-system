import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tanod_apprehension/net/authenticationService.dart';
import 'package:tanod_apprehension/screens/notificationScreen.dart';
import 'package:tanod_apprehension/screens/reportScreens/activeScreen.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/myAppbar.dart';
import 'package:tanod_apprehension/shared/myBottomSheet.dart';
import 'package:tanod_apprehension/shared/myDrawers.dart';
import 'package:tanod_apprehension/shared/mySpinKits.dart';
import 'reportScreens/droppedScreen.dart';
import 'reportScreens/taggedScreen.dart';

class ReportsScreen extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignOut;
  final String userUID;
  final String name;
  final String email;
  final String profileImage;
  const ReportsScreen({
    required this.auth,
    required this.onSignOut,
    required this.userUID,
    required this.name,
    required this.email,
    required this.profileImage,
  });

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

var reports;
late Size screenSize;
final dbRef = FirebaseDatabase.instance.reference();
int notifCount = 0;
GlobalKey<ScaffoldState> _scaffoldKeyReports = GlobalKey<ScaffoldState>();
int currentIndext = 0;
String userUID = '';
List<StatefulWidget> screens = [
  ActiveScreen(
    userUID: userUID,
  ),
  DroppedScreen(
    userUID: userUID,
  ),
  TaggedScreen(
    userUID: userUID,
  ),
];

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    userUID = widget.userUID;
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: StreamBuilder(
          stream: dbRef.child("Reports").onValue,
          builder: (context, reportsSnapshot) {
            if (reportsSnapshot.hasData &&
                !reportsSnapshot.hasError &&
                (reportsSnapshot.data! as Event).snapshot.value != null) {
              reports = (reportsSnapshot.data! as Event).snapshot.value;
            } else {
              return Center(
                child: MySpinKitLoadingScreen(),
              );
            }
            int notifCount = countReportsByLocation(reports);

            return Scaffold(
              key: _scaffoldKeyReports,
              drawer: BuildDrawer(
                leading: "Reports",
                auth: widget.auth,
                onSignOut: widget.onSignOut,
                userUID: widget.userUID,
                name: widget.name,
                email: widget.email,
                profileImage: widget.profileImage,
                backgroundImage: "https://wallpaperaccess.com/full/1397098.jpg",
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
                  style: primaryText.copyWith(fontSize: 18, letterSpacing: 1),
                ),
                actions: [
                  MyAppBarAction(
                    notifCount: notifCount,
                    color: Colors.black,
                    onPressed: () {
                      Reset.filter();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => NotificationScreen(),
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
                    child: screens[currentIndext],
                  ),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: currentIndext,
                onTap: (index) {
                  setState(() {
                    currentIndext = index;
                  });
                },
                type: BottomNavigationBarType.fixed,
                selectedItemColor: customColor[130],
                selectedLabelStyle: tertiaryText.copyWith(fontSize: 12),
                unselectedItemColor: Colors.black38,
                showUnselectedLabels: false,
                items: [
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/hot-sale.png',
                      width: 25,
                      height: 25,
                      fit: BoxFit.cover,
                      color: currentIndext == 0
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
                      color: currentIndext == 1
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
                      color: currentIndext == 2
                          ? customColor[130]
                          : Colors.black38,
                    ),
                    //Icon(FontAwesomeIcons.userTag),
                    label: "Tagged",
                    tooltip: "Apprehended Violator",
                  ),
                ],
              ),
            );
          }),
    );
  }
}
