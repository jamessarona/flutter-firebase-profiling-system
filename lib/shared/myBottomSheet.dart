import 'package:flutter/material.dart';
import 'package:tanod_apprehension/screens/loginScreen.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/myButtons.dart';
import 'globals.dart' as globals;
import 'package:intl/intl.dart';

class BuildBottomSheet extends StatelessWidget {
  final String page;
  const BuildBottomSheet({required this.page});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
        padding: EdgeInsets.only(
            top: 20,
            left: screenSize.width / 30,
            right: screenSize.width / 30,
            bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  'Search Filter',
                  style: tertiaryText.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                // page != "Reports"
                //     ? Container(
                //         margin: EdgeInsets.only(bottom: 5),
                //         padding: EdgeInsets.only(top: 15),
                //         height: 40,
                //         width: screenSize.width,
                //         child: Text(
                //           'Category',
                //           style: tertiaryText.copyWith(fontSize: 15),
                //         ),
                //       )
                //     : Container(),
                // page != "Reports"
                //     ? Container(
                //         margin: EdgeInsets.only(left: 10),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           children: [
                //             MyCategoryButton(
                //               text: 'Recent',
                //               color: globals.filters['Category']['Latest']
                //                   ? Color(0xffdd901c)
                //                   : Color(0xff7d7d7d),
                //               onTap: () {
                //                 setState(() {
                //                   globals.filters['Category']['Latest'] =
                //                       !globals.filters['Category']['Latest'];
                //                 });
                //               },
                //               padding: 3,
                //               height: 28,
                //               width: screenSize.width * .26,
                //             ),
                //             Container(
                //               width: 8,
                //             ),
                //             MyCategoryButton(
                //               text: 'Dropped',
                //               color: globals.filters['Category']['Dropped']
                //                   ? Color(0xffdd901c)
                //                   : Color(0xff7d7d7d),
                //               onTap: () {
                //                 setState(() {
                //                   globals.filters['Category']['Dropped'] =
                //                       !globals.filters['Category']['Dropped'];
                //                 });
                //               },
                //               padding: 3,
                //               height: 28,
                //               width: screenSize.width * .26,
                //             ),
                //             Container(
                //               width: 8,
                //             ),
                //             MyCategoryButton(
                //               text: 'Tagged',
                //               color: globals.filters['Category']['Tagged']
                //                   ? Color(0xffdd901c)
                //                   : Color(0xff7d7d7d),
                //               onTap: () {
                //                 setState(() {
                //                   globals.filters['Category']['Tagged'] =
                //                       !globals.filters['Category']['Tagged'];
                //                 });
                //               },
                //               padding: 3,
                //               height: 28,
                //               width: screenSize.width * .26,
                //             ),
                //           ],
                //         ),
                //       )
                //     : Container(),
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  padding: EdgeInsets.only(top: 15),
                  height: 40,
                  width: screenSize.width,
                  child: Text(
                    'Date',
                    style: tertiaryText.copyWith(fontSize: 15),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      MyCategoryButton(
                        text: globals.start == null
                            ? 'Start'
                            : DateFormat('MM/dd/yyyy').format(globals.start!),
                        color: globals.filters['Date']['Start']
                            ? Color(0xffdd901c)
                            : Color(0xff7d7d7d),
                        onTap: () {
                          setState(() {
                            globals.filters['Date']['Start'] = true;
                            showDatePicker(
                              context: context,
                              initialDate: globals.start == null
                                  ? DateTime.now()
                                  : globals.start!,
                              firstDate: DateTime(2021, 1, 1, 1, 0, 0),
                              lastDate: globals.end != null
                                  ? DateTime.fromMicrosecondsSinceEpoch(
                                      globals.end!.microsecondsSinceEpoch,
                                    )
                                  : DateTime.now(),
                            ).then((dateStart) {
                              setState(() {
                                if (dateStart != null) {
                                  globals.start = dateStart;
                                  print(globals.start);
                                } else {
                                  globals.filters['Date']['Start'] = false;
                                  globals.start = null;
                                }
                              });
                            });
                          });
                        },
                        padding: 3,
                        height: 28,
                        width: screenSize.width * .3,
                      ),
                      Container(
                        width: 25,
                        child: Text(
                          '-',
                          style: tertiaryText.copyWith(
                            fontSize: 25,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      MyCategoryButton(
                        text: globals.end == null
                            ? 'End'
                            : DateFormat('MM/dd/yyyy').format(globals.end!),
                        color: globals.filters['Date']['End']
                            ? Color(0xffdd901c)
                            : Color(0xff7d7d7d),
                        onTap: () {
                          if (globals.start != null) {
                            setState(() {
                              showDatePicker(
                                context: context,
                                initialDate: globals.end == null
                                    ? DateTime.now()
                                    : globals.end!,
                                firstDate: globals.start != null
                                    ? DateTime.fromMicrosecondsSinceEpoch(
                                        globals.start!.microsecondsSinceEpoch,
                                      )
                                    : DateTime(2001),
                                lastDate: DateTime.now(),
                              ).then((dateStart) {
                                setState(() {
                                  if (dateStart != null) {
                                    globals.filters['Date']['End'] = true;
                                    globals.end = dateStart;
                                    print(globals.end);
                                  } else {
                                    globals.filters['Date']['End'] = false;
                                    globals.end = null;
                                  }
                                });
                              });
                            });
                          }
                        },
                        padding: 3,
                        height: 28,
                        width: screenSize.width * .3,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  padding: EdgeInsets.only(top: 15),
                  height: 40,
                  width: screenSize.width,
                  child: Text(
                    'Area',
                    style: tertiaryText.copyWith(fontSize: 15),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, bottom: 30),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          MyCategoryButton(
                            text: 'Tarape\'s Store',
                            color: globals.filters['Area']['Tarape\'s Store']
                                ? Color(0xffdd901c)
                                : Color(0xff7d7d7d),
                            onTap: () {
                              setState(() {
                                globals.filters['Area']['Tarape\'s Store'] =
                                    !globals.filters['Area']['Tarape\'s Store'];
                              });
                            },
                            padding: 3,
                            height: 28,
                            width: screenSize.width * .4,
                          ),
                          Container(
                            width: 8,
                          ),
                          MyCategoryButton(
                            text: 'ShopStrutt.ph',
                            color: globals.filters['Area']['ShopStrutt.ph']
                                ? Color(0xffdd901c)
                                : Color(0xff7d7d7d),
                            onTap: () {
                              setState(() {
                                globals.filters['Area']['ShopStrutt.ph'] =
                                    !globals.filters['Area']['ShopStrutt.ph'];
                              });
                            },
                            padding: 3,
                            height: 28,
                            width: screenSize.width * .4,
                          ),
                        ],
                      ),
                      Container(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          MyCategoryButton(
                            text: 'Melchor\'s Store',
                            color: globals.filters['Area']['Melchor\'s Store']
                                ? Color(0xffdd901c)
                                : Color(0xff7d7d7d),
                            onTap: () {
                              setState(() {
                                globals.filters['Area']['Melchor\'s Store'] =
                                    !globals.filters['Area']
                                        ['Melchor\'s Store'];
                              });
                            },
                            padding: 3,
                            height: 28,
                            width: screenSize.width * .4,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 90,
                  child: MyOutlineButton(
                    color: Color(0xff1c52dd),
                    elavation: 1,
                    isLoading: false,
                    radius: 10,
                    text: Text('Reset'),
                    onPressed: () {
                      setState(() {
                        Reset.filter();
                      });
                    },
                  ),
                ),
                Container(
                  width: 5,
                ),
                Container(
                  width: 90,
                  child: MyRaisedButton(
                    color: Color(0xff1640ac),
                    elavation: 5,
                    isLoading: false,
                    radius: 10,
                    text: Text(
                      'Apply',
                      style: tertiaryText.copyWith(
                          fontSize: 14, color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}

class Reset {
  static void filter() {
    globals.filters = {
      'Category': {
        'Latest': false,
        'Dropped': false,
        'Tagged': false,
      },
      'Date': {
        'Start': false,
        'End': false,
      },
      'Area': {
        'Tarape\'s Store': false,
        'ShopStrutt.ph': false,
        'Melchor\'s Store': false,
      }
    };

    globals.start = null;
    globals.end = null;
  }
}
