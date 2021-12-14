import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanod_apprehension/shared/constants.dart';

class MyUserDetail extends StatelessWidget {
  final String image;
  final String firstname;
  final VoidCallback onTap;
  final String selectedArea;
  const MyUserDetail(
      {required this.image,
      required this.firstname,
      required this.onTap,
      required this.selectedArea});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
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
              Container(
                margin: EdgeInsets.only(left: 16),
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: customColor[50],
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
            top: 9,
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
                    Text(
                      firstname,
                      style: secandaryText.copyWith(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
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
                      Icon(
                        FontAwesomeIcons.streetView,
                        color: customColor[170],
                      ),
                      Container(
                        height: 8,
                      ),
                      Text(
                        ' $selectedArea ',
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
