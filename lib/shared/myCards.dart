import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanood/shared/constants.dart';
import 'package:tanood/shared/myContainers.dart';

class MyReportCard extends StatelessWidget {
  final String id;
  final String image;
  final int violator;
  final String location;
  final String date;
  final String category;
  final Color color;
  final bool isAssigned;
  const MyReportCard({
    required this.id,
    required this.image,
    required this.violator,
    required this.location,
    required this.date,
    required this.category,
    required this.color,
    required this.isAssigned,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: customColor[130],
      color: isAssigned ? Colors.grey[200] : Colors.white,
      elevation: 1,
      child: Container(
        padding: EdgeInsets.all(7),
        width: 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Hero(
              tag: 'report_$id',
              child: Container(
                height: 145,
                width: 170,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                      image,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 4,
              ),
              width: 170,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          calculateTimeOfOccurence(date),
                          style: tertiaryText.copyWith(fontSize: 14),
                        ),
                        Container(
                          width: 10,
                        ),
                        category != 'Tagged'
                            ? MyReportStatusIndicator(
                                height: 10, width: 10, color: color)
                            : Container(),
                      ],
                    ),
                  ),
                  Text(
                    location,
                    style: tertiaryText.copyWith(fontSize: 13),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    height: 10,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MySummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int number;

  const MySummaryCard(
      {required this.icon, required this.label, required this.number});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(29),
      ),
      child: Container(
        height: screenSize.height * .23,
        width: screenSize.width * .28,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                const Color(0xFF7e9af6),
                const Color(0xFFe5d5ec),
              ],
              begin: const FractionalOffset(0.0, 1.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: screenSize.height * .08,
              width: screenSize.width * .15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(40),
                ),
                border: Border.all(
                  width: 1,
                  color: Colors.white,
                  style: BorderStyle.solid,
                ),
              ),
              child: Icon(
                icon,
                color: Colors.black,
                size: 30,
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: label,
                style: secandaryText.copyWith(fontSize: 13),
                children: <TextSpan>[
                  TextSpan(
                    text: '\n$number',
                    style: TextStyle(fontSize: 40),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyInformationCard extends StatelessWidget {
  final String icon;
  final String text;
  final VoidCallback onTap;
  const MyInformationCard(
      {required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: customColor[110],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: ListTile(
          leading: Image.asset(
            'assets/images/$icon',
            width: 25,
            height: 25,
            fit: BoxFit.cover,
            color: customColor[130],
          ),
          // icon,
          title: Text(
            text,
            style: tertiaryText.copyWith(fontSize: 16),
          ),
          trailing: Icon(
            FontAwesomeIcons.chevronRight,
          ),
          onTap: onTap,
        ));
  }
}

class MyAccountInformationCard extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;
  const MyAccountInformationCard(
      {required this.title, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: customColor[110],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: tertiaryText.copyWith(fontSize: 16),
              ),
              Expanded(
                child: Text(
                  value,
                  style:
                      tertiaryText.copyWith(fontSize: 14, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          trailing: Icon(
            FontAwesomeIcons.chevronRight,
          ),
          onTap: onTap,
        ));
  }
}

class MyStatusCard extends StatelessWidget {
  final String status;
  final String location;
  final VoidCallback onTap;
  final String date;
  const MyStatusCard({
    required this.status,
    required this.location,
    required this.onTap,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        top: 23,
        left: 20,
        right: 20,
      ),
      padding: EdgeInsets.only(
        top: 28,
        bottom: 25,
        left: 23,
        right: 23,
      ),
      height: 180,
      width: screenSize.width * .9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        color: customColor[130],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Status,',
                      style: tertiaryText.copyWith(
                          fontSize: 15, color: Colors.white70),
                    ),
                    Container(
                      height: screenSize.height / 80,
                    ),
                    Text.rich(
                      TextSpan(
                        style: tertiaryText.copyWith(
                            fontSize: 19, color: Colors.white),
                        children: [
                          TextSpan(text: status),
                          status != "Standby"
                              ? TextSpan(
                                  text: ' to\n$location',
                                )
                              : TextSpan()
                        ],
                      ),
                    ),
                    Text(
                      status != "Standby"
                          ? "${calculateTimeOfOccurence(date)}"
                          : "",
                      style: tertiaryText.copyWith(
                          fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Text(
                status != "Standby"
                    ? 'Respond as quickly as possible'
                    : "You can assign report",
                style:
                    tertiaryText.copyWith(fontSize: 11, color: Colors.white70),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              status != "Standby"
                  ? SpinKitPouringHourGlassRefined(
                      color: Color(0xffdd901c),
                      size: 50,
                      strokeWidth: 1,
                    )
                  : Image.asset(
                      'assets/images/target.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      color: customColor[170],
                    ),
              // : Icon(
              //     FontAwesomeIcons.crosshairs,
              //     size: 30,
              //     color: customColor[80],
              //   ),
              GestureDetector(
                  // child: Icon(
                  //   FontAwesomeIcons.angleDoubleRight,
                  //   size: 25,
                  //   color: Colors.white70,
                  // ),
                  child: Image.asset(
                    'assets/images/two-arrows.png',
                    width: 25,
                    height: 25,
                    fit: BoxFit.cover,
                    color: Colors.white,
                  ),
                  onTap: onTap),
            ],
          )
        ],
      ),
    );
  }
}

class MyNotificationReportCard extends StatelessWidget {
  final String id;
  final String image;
  final int violators;
  final String location;
  final String date;
  final String category;
  final Color color;
  const MyNotificationReportCard({
    required this.id,
    required this.image,
    required this.violators,
    required this.location,
    required this.date,
    required this.category,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      height: 150,
      width: screenSize.width,
      child: Card(
        elevation: 3,
        child: ListTile(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: 'report_$id',
                child: Container(
                  height: 123,
                  width: 160,
                  margin: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                        image,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8),
                margin: EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location,
                      style: tertiaryText.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '$violators ${violators > 1 ? 'violators' : 'violator'}',
                      style: tertiaryText.copyWith(
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      calculateTimeOfOccurence(date),
                      style: tertiaryText.copyWith(
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Pending',
                      style: tertiaryText.copyWith(
                        fontSize: 13,
                        color: color,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
            ],
          ),
          trailing: Icon(
            FontAwesomeIcons.angleDoubleRight,
            color: Colors.grey,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class MyApprehenssionHistoryCard extends StatelessWidget {
  final String id;
  final String image;
  final String location;
  final String date;
  final String caughtCount;
  final String status;
  final String remarks;
  const MyApprehenssionHistoryCard({
    required this.id,
    required this.image,
    required this.location,
    required this.date,
    required this.caughtCount,
    required this.status,
    required this.remarks,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: ListTile(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: 140,
              margin: EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                    image,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location,
                    style: tertiaryText.copyWith(
                      fontSize: 15,
                    ),
                  ),
                  Container(
                    height: 5,
                  ),
                  Text(
                    setDateTime(date, 'Date'),
                    style: tertiaryText.copyWith(
                      fontSize: 13,
                    ),
                  ),
                  Container(
                    height: 1,
                  ),
                  Text(
                    'Caught($caughtCount)',
                    style: tertiaryText.copyWith(
                      fontSize: 13,
                    ),
                  ),
                  Container(
                    height: 1,
                  ),
                  Text(
                    status,
                    style: tertiaryText.copyWith(
                      fontSize: 13,
                    ),
                  ),
                  Container(
                    height: 1,
                  ),
                  Text(
                    remarks,
                    style: tertiaryText.copyWith(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyViolatorCard extends StatelessWidget {
  final String name;
  final String gender;
  final int age;
  final VoidCallback onTap;
  const MyViolatorCard({
    required this.name,
    required this.gender,
    required this.age,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        dense: true,
        leading: Container(
          height: 40,
          width: 40,
          child: Image.asset(
            "assets/images/${gender == 'Female' ? 'woman' : 'man'}.png",
            width: 20,
            height: 20,
            fit: BoxFit.fitHeight,
          ),
        ),
        title: Text(
          name,
          style: tertiaryText.copyWith(
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          "$age year's old",
          style: tertiaryText.copyWith(
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class MyTanodCard extends StatelessWidget {
  final String name;
  final bool isUser;
  final String gender;
  final String location;
  final String status;
  final VoidCallback onTap;
  final bool isDisabled;

  const MyTanodCard({
    required this.name,
    required this.isUser,
    required this.gender,
    required this.location,
    required this.status,
    required this.onTap,
    required this.isDisabled,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        dense: true,
        leading: Container(
          height: 40,
          width: 40,
          child: Image.asset(
            "assets/images/${gender == 'Female' ? 'woman' : 'man'}.png",
            width: 20,
            height: 20,
            fit: BoxFit.fitHeight,
          ),
        ),
        title: Text(
          "$name ${isUser ? '(You)' : ''}",
          style: tertiaryText.copyWith(
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          isDisabled
              ? 'Disabled'
              : "${location != 'N/A' ? location : 'No Location Assigned'} > $status",
          style: tertiaryText.copyWith(
            fontSize: 12,
          ),
        ),
        trailing: isUser
            ? Text('')
            : GestureDetector(
                onTap: onTap,
                child: Icon(
                  isDisabled
                      ? FontAwesomeIcons.timesCircle
                      : FontAwesomeIcons.checkCircle,
                  color: isDisabled ? Colors.red : Colors.green,
                  size: 15,
                ),
              ),
      ),
    );
  }
}

class MyLocationCard extends StatelessWidget {
  final String locId;
  final String name;
  final int assignCount;
  final bool isDisabled;
  final VoidCallback onTap;

  const MyLocationCard({
    required this.locId,
    required this.name,
    required this.assignCount,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        dense: true,
        leading: Container(
          height: 30,
          width: 30,
          child: Image.asset(
            "assets/images/map-location.png",
            width: 20,
            height: 20,
            color: customColor[130],
            fit: BoxFit.fitHeight,
          ),
        ),
        title: Text(
          locId != '0' ? name : 'No Location Assigned',
          style: tertiaryText.copyWith(
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          "$assignCount tanod${assignCount != 1 ? 's' : ''}",
          style: tertiaryText.copyWith(
            fontSize: 12,
          ),
        ),
        trailing: locId != '0'
            ? GestureDetector(
                onTap: onTap,
                child: Icon(
                  isDisabled
                      ? FontAwesomeIcons.timesCircle
                      : FontAwesomeIcons.checkCircle,
                  color: isDisabled ? Colors.red : Colors.green,
                  size: 15,
                ),
              )
            : Text(''),
      ),
    );
  }
}
