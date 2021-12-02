import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tanod_apprehension/screens/reportsScreen.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/myCards.dart';

class ActiveScreen extends StatefulWidget {
  const ActiveScreen({Key? key}) : super(key: key);

  @override
  _ActiveScreenState createState() => _ActiveScreenState();
}

class _ActiveScreenState extends State<ActiveScreen> {
  late Size screenSize;
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return ListView(
        shrinkWrap: true,
        dragStartBehavior: DragStartBehavior.start,
        children: [
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.spaceEvenly,
            children: [
              MyReportCard(),
              MyReportCard(),
              MyReportCard(),
              MyReportCard(),
              MyReportCard(),
              MyReportCard(),
              MyReportCard(),
            ],
          )
        ]);
  }
}

// Container(
//           height: screenSize.height * .18,
//           child: Card(
//             color: customColor[20],
//             child: ListTile(
//               title: Row(children: [
//                 Container(
//                   height: screenSize.height * .15,
//                   width: screenSize.width * .4,
//                   child: Image.network(
//                     url,
//                     fit: BoxFit.fitHeight,
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.only(left: screenSize.width / 70),
//                   height: screenSize.height * .15,
//                   width: screenSize.width * .35,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '19 mins ago',
//                         style: tertiaryText.copyWith(fontSize: 14),
//                       ),
//                       Text(
//                         'Silver St. San Rafel, Davao City',
//                         style: secandaryText.copyWith(fontSize: 13),
//                       ),
//                       Text('data'),
//                     ],
//                   ),
//                 ),
//               ]),
//             ),
//           ),
//         )