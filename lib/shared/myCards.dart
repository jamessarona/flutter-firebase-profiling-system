import 'package:flutter/material.dart';
import 'package:tanod_apprehension/shared/constants.dart';

class MyReportCard extends StatelessWidget {
  final String id;
  final String image;
  final String location;
  final String date;
  final String status;
  const MyReportCard(
      {required this.id,
      required this.image,
      required this.location,
      required this.date,
      required this.status});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Card(
      child: Container(
        padding: EdgeInsets.all(7),
        width: screenSize.width < 450 ? screenSize.width * .47 : 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Hero(
              tag: 'report_$id',
              child: Container(
                height: 145,
                width: 170,
                decoration: BoxDecoration(
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
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              color: Colors.green, shape: BoxShape.circle),
                        )
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
            Container(
              width: 170,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 85,
                    // child: MyButton(
                    //   name: 'Buy Now',
                    //   color: Colors.green,
                    //   onPressed: onPressedBuy,
                    // ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: screenSize.width * .01),
                    width: 70,
                    // child: MyButton(
                    //   name: 'Cart',
                    //   color: customColors[30],
                    //   onPressed: onPressedCart,
                    // ),
                  ),
                ],
              ),
            )
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
