import 'package:flutter/material.dart';
import 'package:tanod_apprehension/screens/loginScreen.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/myButtons.dart';
import 'globals.dart' as globals;
import 'package:intl/intl.dart';

DateTime? start;
DateTime? end;

class BuildBottomSheet extends StatelessWidget {
  const BuildBottomSheet({Key? key}) : super(key: key);

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
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  padding: EdgeInsets.only(top: 15),
                  height: 40,
                  width: screenSize.width,
                  child: Text(
                    'Category',
                    style: tertiaryText.copyWith(fontSize: 15),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      MyCategoryButton(
                        text: 'Recent',
                        color: globals.filters['Category']['Recent']
                            ? Color(0xffdd901c)
                            : Color(0xff7d7d7d),
                        onTap: () {
                          setState(() {
                            globals.filters['Category']['Recent'] =
                                !globals.filters['Category']['Recent'];
                          });
                        },
                        padding: 3,
                        height: 28,
                        width: screenSize.width * .26,
                      ),
                      Container(
                        width: 8,
                      ),
                      MyCategoryButton(
                        text: 'Dropped',
                        color: globals.filters['Category']['Dropped']
                            ? Color(0xffdd901c)
                            : Color(0xff7d7d7d),
                        onTap: () {
                          setState(() {
                            globals.filters['Category']['Dropped'] =
                                !globals.filters['Category']['Dropped'];
                          });
                        },
                        padding: 3,
                        height: 28,
                        width: screenSize.width * .26,
                      ),
                      Container(
                        width: 8,
                      ),
                      MyCategoryButton(
                        text: 'Tagged',
                        color: globals.filters['Category']['Tagged']
                            ? Color(0xffdd901c)
                            : Color(0xff7d7d7d),
                        onTap: () {
                          setState(() {
                            globals.filters['Category']['Tagged'] =
                                !globals.filters['Category']['Tagged'];
                          });
                        },
                        padding: 3,
                        height: 28,
                        width: screenSize.width * .26,
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
                        text: start == null
                            ? 'Start'
                            : DateFormat('MM/dd/yyyy').format(start!),
                        color: globals.filters['Date']['Start']
                            ? Color(0xffdd901c)
                            : Color(0xff7d7d7d),
                        onTap: () {
                          setState(() {
                            globals.filters['Date']['Start'] = true;
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2021, 1, 1, 1, 0, 0),
                              lastDate: end != null
                                  ? DateTime.fromMicrosecondsSinceEpoch(
                                      end!.microsecondsSinceEpoch,
                                    )
                                  : DateTime.now(),
                            ).then((dateStart) {
                              setState(() {
                                if (dateStart != null) {
                                  start = dateStart;
                                  print(start);
                                } else {
                                  globals.filters['Date']['Start'] = false;
                                  start = null;
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
                        text: end == null
                            ? 'End'
                            : DateFormat('MM/dd/yyyy').format(end!),
                        color: globals.filters['Date']['End']
                            ? Color(0xffdd901c)
                            : Color(0xff7d7d7d),
                        onTap: () {
                          if (start != null) {
                            setState(() {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: start != null
                                    ? DateTime.fromMicrosecondsSinceEpoch(
                                        start!.microsecondsSinceEpoch,
                                      )
                                    : DateTime(2001),
                                lastDate: DateTime.now(),
                              ).then((dateStart) {
                                setState(() {
                                  if (dateStart != null) {
                                    globals.filters['Date']['End'] = true;
                                    end = dateStart;
                                    print(end);
                                  } else {
                                    globals.filters['Date']['End'] = false;
                                    end = null;
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
                            text: 'Silver St. San Rafael',
                            color: globals.filters['Area']
                                    ['Silver St. San Rafael']
                                ? Color(0xffdd901c)
                                : Color(0xff7d7d7d),
                            onTap: () {
                              setState(() {
                                globals.filters['Area']
                                        ['Silver St. San Rafael'] =
                                    !globals.filters['Area']
                                        ['Silver St. San Rafael'];
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
                            text: 'Juario Compound',
                            color: globals.filters['Area']['Juario Compound']
                                ? Color(0xffdd901c)
                                : Color(0xff7d7d7d),
                            onTap: () {
                              setState(() {
                                globals.filters['Area']['Juario Compound'] =
                                    !globals.filters['Area']['Juario Compound'];
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
                            text: 'Maharlika NHA Maa',
                            color: globals.filters['Area']['Maharlika NHA Maa']
                                ? Color(0xffdd901c)
                                : Color(0xff7d7d7d),
                            onTap: () {
                              setState(() {
                                globals.filters['Area']['Maharlika NHA Maa'] =
                                    !globals.filters['Area']
                                        ['Maharlika NHA Maa'];
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
        'Recent': false,
        'Dropped': false,
        'Tagged': false,
      },
      'Date': {
        'Start': false,
        'End': false,
      },
      'Area': {
        'Silver St. San Rafael': false,
        'Juario Compound': false,
        'Maharlika NHA Maa': false,
      }
    };

    start = null;
    end = null;
  }
}
