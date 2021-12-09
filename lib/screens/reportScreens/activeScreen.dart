import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tanod_apprehension/screens/detailReportScreen.dart';
import 'package:tanod_apprehension/shared/myCards.dart';
import 'package:tanod_apprehension/shared/mySpinKits.dart';

class ActiveScreen extends StatefulWidget {
  const ActiveScreen({Key? key}) : super(key: key);

  @override
  _ActiveScreenState createState() => _ActiveScreenState();
}

class _ActiveScreenState extends State<ActiveScreen> {
  late Size screenSize;
  final dbRef = FirebaseDatabase.instance.reference().child("Reports");
  final list = <ListTile>[];
  var reports;
  String image =
      "https://scontent.fceb1-2.fna.fbcdn.net/v/t1.15752-9/262501487_600481991261895_6657576791388492822_n.jpg?_nc_cat=108&ccb=1-5&_nc_sid=ae9488&_nc_eui2=AeGLfAgYOwjWSU7I7PdN6aLRUlGyQAFmrtBSUbJAAWau0AwTNgCcxivLG0-lO7U4kysSpa9XX2-gzrcBI3vLfTmx&_nc_ohc=KhiTtW4aTRwAX9HqEcL&_nc_ht=scontent.fceb1-2.fna&oh=08b9589cb4d89e045c8ec7e926d7ed32&oe=61CD9F94";
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return StreamBuilder(
        stream: dbRef.onValue,
        builder: (context, productsSnapshot) {
          if (productsSnapshot.hasData &&
              !productsSnapshot.hasError &&
              (productsSnapshot.data! as Event).snapshot.value != null) {
            reports = (productsSnapshot.data! as Event).snapshot.value;
          } else {
            return MySpinKitFadingCube();
          }
          return ListView(
              shrinkWrap: true,
              dragStartBehavior: DragStartBehavior.start,
              children: [
                Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.spaceEvenly,
                  children: [
                    for (var item in reports)
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => DetailReportScreen(
                                id: item['Id'].toString(),
                                image: item['Image'],
                                location: item['Location'],
                                status: item['Status'],
                                date: item['Date'],
                              ),
                            ),
                          );
                        },
                        child: MyReportCard(
                          id: item['Id'].toString(),
                          image: item['Image'],
                          location: item['Location'],
                          status: item['Status'],
                          date: item['Date'],
                        ),
                      ),
                  ],
                )
              ]);
        });
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




// return ListView(
//               shrinkWrap: true,
//               dragStartBehavior: DragStartBehavior.start,
//               children: [
//                 Wrap(
//                   direction: Axis.horizontal,
//                   alignment: WrapAlignment.spaceEvenly,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (ctx) => DetailReportScreen(
//                               image: image,
//                               location:
//                                   "Silver Street, San Rafel, Marfori, Davao City",
//                               status: "Active",
//                               date: "2020-12-08 11:23:14",
//                             ),
//                           ),
//                         );
//                       },
//                       child: MyReportCard(
//                         image: image,
//                         location:
//                             "Silver Street, San Rafel, Marfori, Davao City",
//                         status: "Active",
//                         date: "2020-12-08 11:23:14",
//                       ),
//                     ),
//                   ],
//                 )
//               ]);