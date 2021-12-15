import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanod_apprehension/net/authenticationService.dart';
import 'package:tanod_apprehension/screens/reportScreens/activeScreen.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/myAppbar.dart';
import 'package:tanod_apprehension/shared/myDrawers.dart';
import 'package:tanod_apprehension/shared/mySpinKits.dart';
import 'reportScreens/droppedScreen.dart';
import 'reportScreens/taggedScreen.dart';

class ReportsScreen extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignOut;

  final String name;
  final String email;
  final String profileImage;

  const ReportsScreen({
    required this.auth,
    required this.onSignOut,
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

class _ReportsScreenState extends State<ReportsScreen> {
  final screens = [
    ActiveScreen(),
    DroppedScreen(),
    TaggedScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: StreamBuilder(
          stream: dbRef.child("Reports").onValue,
          builder: (context, preportsSnapshot) {
            if (preportsSnapshot.hasData &&
                !preportsSnapshot.hasError &&
                (preportsSnapshot.data! as Event).snapshot.value != null) {
              reports = (preportsSnapshot.data! as Event).snapshot.value;
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
                name: widget.name,
                email: widget.email,
                profileImage: widget.profileImage,
                backgroundImage: "https://wallpaperaccess.com/full/1397098.jpg",
              ),
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(80),
                child: AppBar(
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
                      style:
                          primaryText.copyWith(fontSize: 18, letterSpacing: 1),
                    ),
                    actions: [
                      MyAppBarAction(
                        notifCount: notifCount,
                        color: Colors.black,
                        onPressed: () {},
                      )
                    ],
                    flexibleSpace: Container(
                      margin: EdgeInsets.only(
                        top: 45,
                      ),
                      width: screenSize.width,
                      height: 80,
                      color: Colors.red,
                      child: Row(
                        children: [],
                      ),
                    )),
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
                type: BottomNavigationBarType.shifting,
                selectedItemColor: customColor,
                selectedLabelStyle: tertiaryText.copyWith(fontSize: 12),
                unselectedItemColor: Colors.black38,
                showUnselectedLabels: false,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.fire),
                    label: "Active",
                    tooltip: "New Violator",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.archive),
                    label: "Dropped",
                    tooltip: "Missed Violator",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.userTag),
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
//  Container(
//               height: screenSize.height * 5,
//               width: screenSize.width,
//               child: Row(
//                 children: [
//                   DropdownButton<String>(
//                     items: <String>['Maa', 'San Rafael', 'Roxas', 'Matina']
//                         .map((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                     onChanged: (_) {},
//                   )
//                 ],
//               ),
//             ),