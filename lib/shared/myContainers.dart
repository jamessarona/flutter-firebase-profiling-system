import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanood/shared/constants.dart';
import 'package:tanood/shared/globals.dart';
import 'package:intl/intl.dart';

class MyUserDetail extends StatelessWidget {
  final String image;
  final String firstname;
  final VoidCallback onTap;
  const MyUserDetail({
    required this.image,
    required this.firstname,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          height: 100,
          width: screenSize.width,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffbbcdfb),
                ),
              ),
              image == 'default'
                  ? Container(
                      margin: EdgeInsets.only(left: 16),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: customColor[130],
                      ),
                      child: Image.asset(
                        "assets/images/default.png",
                        width: 10,
                        height: 10,
                        fit: BoxFit.fitHeight,
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.only(left: 16),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: customColor[130],
                        image: new DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            image,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: 14,
            left: 20,
            right: 30,
          ),
          height: 85,
          width: screenSize.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 85,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello',
                      style: tertiaryText.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                        letterSpacing: 1,
                      ),
                    ),
                    Container(
                      width: screenSize.width * .55,
                      child: Text(
                        '$firstname,',
                        style: secandaryText.copyWith(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    Text(
                      'welcome back!',
                      style: tertiaryText.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                        letterSpacing: 1,
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  height: 85,
                  width: screenSize.width * .3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: customColor[110],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icon(
                      //   FontAwesomeIcons.streetView,
                      //   color: customColor[170],
                      // ),
                      Image.asset(
                        'assets/images/map-location.png',
                        width: 25,
                        height: 25,
                        fit: BoxFit.cover,
                        color: customColor[170],
                      ),
                      Container(
                        height: 8,
                      ),
                      Text(
                        ' $selectedLocation ',
                        style: tertiaryText.copyWith(
                            fontSize: 15, color: Colors.black),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MyReportStatusIndicator extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  const MyReportStatusIndicator(
      {required this.height, required this.width, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class PageResultMessage extends StatelessWidget {
  final double height;
  final double width;
  final String message;
  const PageResultMessage(
      {required this.height, required this.width, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.bottomCenter,
      child: Text(
        message,
        style: secandaryText.copyWith(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class MyStatisticsCountsContainer extends StatelessWidget {
  final String title;
  final int count;
  const MyStatisticsCountsContainer({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('#,##,#00');
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      height: 150,
      width: screenSize.width * .4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: title == 'Documented' ? customColor[130] : customColor[110],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 8,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: Container(
        width: screenSize.width * .35,
        margin: EdgeInsets.only(
          top: 20,
          left: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              title == 'Documented'
                  ? FontAwesomeIcons.userCheck
                  : FontAwesomeIcons.userTimes,
              size: 20,
              color: title == 'Documented' ? Colors.white : Colors.black,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Text(
                title,
                style: tertiaryText.copyWith(
                  fontSize: 15,
                  color:
                      title == 'Documented' ? customColor[110] : Colors.black,
                ),
              ),
            ),
            Container(
              height: 50,
              padding: EdgeInsets.only(left: 10),
              width: screenSize.width * .35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15)),
                color:
                    title == 'Documented' ? customColor[140] : customColor[120],
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                '${formatter.format(count)}',
                style: tertiaryText.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color:
                      title == 'Documented' ? customColor[110] : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
