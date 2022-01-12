import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanod_apprehension/screens/loginScreen.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/myButtons.dart';
import 'package:tanod_apprehension/shared/mySpinKits.dart';
import 'package:tanod_apprehension/shared/myTextFormFields.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class ReportDocumentation extends StatefulWidget {
  final String id;
  const ReportDocumentation({required this.id});

  @override
  _ReportDocumentationState createState() => _ReportDocumentationState();
}

class _ReportDocumentationState extends State<ReportDocumentation> {
  late Size screenSize;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final dbRef = FirebaseDatabase.instance.reference();
  var violators;
  double fine = 0.00;
  int violationCount = 0;
  static const fines = [
    100.00,
    300.00,
    500.00,
  ];

  TextEditingController _nameTextEditingController = TextEditingController();
  static List<String> violatorNames = [];
  void _getViolatorNames() {
    for (int i = 0; i < violators.length; i++) {
      violatorNames.add(violators[i]['Name']);
    }
  }

  void _calculateFines() {
    violationCount = _getViolationInstance();
    if (violationCount == 0) {
      fine = fines[0];
    } else if (violationCount == 1) {
      fine = fines[1];
    } else {
      fine = fines[2];
    }
    setState(() {});
  }

  int _getViolationInstance() {
    return 2;
  }

  void _saveDocumentation() {
    if (_formKey.currentState!.validate()) {
      _calculateFines();
      print('object');
    }
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    print(fine);
    return SafeArea(
      child: StreamBuilder(
          stream: dbRef.child('Violators').onValue,
          builder: (context, tanodSnapshot) {
            if (tanodSnapshot.hasData &&
                !tanodSnapshot.hasError &&
                (tanodSnapshot.data! as Event).snapshot.value != null) {
              violators = (tanodSnapshot.data! as Event).snapshot.value;
            } else {
              return Scaffold(body: MySpinKitLoadingScreen());
            }
            _getViolatorNames();
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                leading: IconButton(
                  icon: Icon(FontAwesomeIcons.chevronLeft),
                  color: Colors.black,
                  iconSize: 20,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                centerTitle: true,
                title: Text(
                  'Documentation',
                  style: primaryText.copyWith(fontSize: 18, letterSpacing: 1),
                ),
                actions: [
                  IconButton(
                      iconSize: 25,
                      onPressed: () {
                        _saveDocumentation();
                      },
                      icon: Icon(
                        FontAwesomeIcons.solidSave,
                        color: customColor[130],
                      ))
                ],
              ),
              body: Form(
                key: _formKey,
                child: Container(
                  height: screenSize.height,
                  width: screenSize.width,
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: screenSize.width * .1,
                        ),
                        height: 80,
                        width: 80,
                        child: Image.asset(
                          'assets/images/man.png',
                          width: 20,
                          height: 20,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      Text(
                        'Record the Violator',
                        style: primaryText.copyWith(
                          fontSize: 16,
                          letterSpacing: 0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 40,
                          left: screenSize.width * .1,
                          right: screenSize.width * .1,
                        ),
                        child: TypeAheadFormField(
                          suggestionsCallback: (pattern) => violatorNames.where(
                            (item) => item.toLowerCase().contains(
                                  pattern.toLowerCase(),
                                ),
                          ),
                          itemBuilder: (_, String item) => ListTile(
                            title: Text(
                              item,
                            ),
                          ),
                          onSuggestionSelected: (String val) {
                            this._nameTextEditingController.text = val;
                            print(val);
                          },
                          getImmediateSuggestions: true,
                          hideSuggestionsOnKeyboardHide: false,
                          hideOnEmpty: false,
                          noItemsFoundBuilder: (context) => Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text('No Existing Violators Found'),
                          ),
                          textFieldConfiguration: TextFieldConfiguration(
                            decoration: InputDecoration(
                              isDense: true,
                              prefixIcon: GestureDetector(
                                onTap: () {},
                                child: Icon(
                                  FontAwesomeIcons.userAlt,
                                  size: 20,
                                  color: customColor[130],
                                ),
                              ),
                              labelText: "Name",
                              filled: true,
                              fillColor: Colors.white70,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            controller: this._nameTextEditingController,
                          ),
                          validator: (value) {
                            if (value == "") {
                              return "Name is empty";
                            }
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 15,
                          left: screenSize.width * .1,
                          right: screenSize.width * .1,
                        ),
                        child: MyDocumentationTextFormField(
                          inputType: TextInputType.datetime,
                          isObscureText: false,
                          validation: (value) {
                            if (value == "") {
                              return "Birthday is empty";
                            }
                          },
                          onChanged: (value) {},
                          prefixIcon: GestureDetector(
                            onTap: () {},
                            child: Icon(
                              FontAwesomeIcons.calendarAlt,
                              size: 20,
                              color: customColor[130],
                            ),
                          ),
                          labelText: "Birthday",
                          hintText: "01/01/2022",
                          isReadOnly: false,
                          initialValue: "",
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 15,
                          left: screenSize.width * .1,
                          right: screenSize.width * .1,
                        ),
                        child: MyDocumentationTextFormField(
                          inputType: TextInputType.phone,
                          isObscureText: false,
                          validation: (value) {
                            if (value == "") {
                              return "Contact Number is empty";
                            }
                          },
                          onChanged: (value) {},
                          prefixIcon: GestureDetector(
                            onTap: () {},
                            child: Icon(
                              FontAwesomeIcons.phone,
                              size: 20,
                              color: customColor[130],
                            ),
                          ),
                          labelText: "Contact Number",
                          hintText: "",
                          isReadOnly: false,
                          initialValue: "",
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 15,
                          left: screenSize.width * .1,
                          right: screenSize.width * .1,
                        ),
                        child: MyDocumentationTextFormField(
                          inputType: TextInputType.streetAddress,
                          isObscureText: false,
                          validation: (value) {
                            if (value == "") {
                              return "Address is empty";
                            }
                          },
                          onChanged: (value) {},
                          prefixIcon: GestureDetector(
                            onTap: () {},
                            child: Icon(
                              FontAwesomeIcons.mapMarkerAlt,
                              size: 20,
                              color: customColor[130],
                            ),
                          ),
                          labelText: "Address",
                          hintText: "",
                          isReadOnly: false,
                          initialValue: "",
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 15,
                          left: screenSize.width * .1,
                          right: screenSize.width * .1,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: screenSize.width * .39,
                              child: MyDocumentationTextFormField(
                                inputType: TextInputType.streetAddress,
                                isObscureText: false,
                                validation: (value) {},
                                onChanged: (value) {},
                                prefixIcon: GestureDetector(
                                  onTap: () {},
                                  child: Icon(
                                    FontAwesomeIcons.solidFlag,
                                    size: 20,
                                    color: customColor[130],
                                  ),
                                ),
                                labelText: "Count",
                                hintText: "",
                                isReadOnly: true,
                                initialValue: violationCount.toString(),
                              ),
                            ),
                            Container(
                              width: screenSize.width * .39,
                              child: MyDocumentationTextFormField(
                                inputType: TextInputType.streetAddress,
                                isObscureText: false,
                                validation: (value) {},
                                onChanged: (value) {},
                                prefixIcon: GestureDetector(
                                  onTap: () {},
                                  child: Icon(
                                    FontAwesomeIcons.coins,
                                    size: 20,
                                    color: customColor[130],
                                  ),
                                ),
                                labelText: "Fine",
                                hintText: "",
                                isReadOnly: true,
                                initialValue: "₱$fine",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
