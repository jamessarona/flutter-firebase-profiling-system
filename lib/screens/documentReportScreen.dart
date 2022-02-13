import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/myButtons.dart';
import 'package:tanod_apprehension/shared/mySpinKits.dart';
import 'package:tanod_apprehension/shared/myTextFormFields.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

class ReportDocumentation extends StatefulWidget {
  final String id;
  final String tanodId;
  final String? selectedViolatorId;
  const ReportDocumentation({
    required this.id,
    required this.tanodId,
    this.selectedViolatorId,
  });

  @override
  _ReportDocumentationState createState() => _ReportDocumentationState();
}

class _ReportDocumentationState extends State<ReportDocumentation> {
  late Size screenSize;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final dbRef = FirebaseDatabase.instance.reference();
  var violators;
  var reports;
  var selectedReport;
  static const fines = [
    300.00,
    500.00,
    1000.00,
  ];
  int process = 0;
  int updateProcess = 0;
  int updateProcess2 = 0;
  String violatorId = "";
  int violationCount = 0;
  double violationFine = 0.00;

  bool isLoading = false;
  bool isSaveable = false;
  late Timer _timer;
  bool isTagged = false;
  TextEditingController _nameTextEditingController = TextEditingController();
  TextEditingController _birthdayTextEditingController =
      TextEditingController();
  TextEditingController _contactNumberTextEditingController =
      TextEditingController();
  TextEditingController _addressTextEditingController = TextEditingController();
  TextEditingController _violationCountTextEditingController =
      TextEditingController();
  TextEditingController _fineTextEditingController = TextEditingController();

  static List<String> violatorNames = [];

  String selectedGender = "Male";
  static const _DropGender = [
    "Male",
    "Female",
    "Others",
  ];

  void _checkValidToSave() {
    bool isValid = false;
    if (_nameTextEditingController.text != '') {
      isValid = true;
    }
    if (_birthdayTextEditingController.text != '') {
      isValid = true;
    }

    if (_contactNumberTextEditingController.text != '') {
      isValid = true;
    }
    if (_addressTextEditingController.text != '') {
      isValid = true;
    }
    isSaveable = isValid;
  }

  void _checkValidToSaveDropDown() {
    if (selectedGender != '') {
      isSaveable = true;
    }
  }

  void _setViolatorInformation() {
    if (updateProcess < 1) {
      _nameTextEditingController.text = getViolatorSpecifiedInformation(
          violators, widget.selectedViolatorId, 'Name');

      _autoSetViolationDocumentation(
          _calculateViolatorViolationHistory(_nameTextEditingController.text));
      updateProcess++;
    }
  }

  void _getViolatorNames() {
    if (process < 1) {
      for (int i = 0; i < violators.length; i++) {
        violatorNames.add(violators[i]['Name']);
      }
      violatorNames.sort((a, b) => a.toString().compareTo(b.toString()));
      process++;
    }
  }

  int _calculateViolatorViolationHistory(String selectedName) {
    int count = 0;
    violatorId = "";
    for (int i = 0; i < violators.length; i++) {
      if (violators[i]["Name"] == selectedName) {
        violatorId = violators[i]['ViolatorId'].toString();
      }
    }
    for (int i = 0; i < reports.length; i++) {
      if (reports[i]['AssignedTanod'] != null) {
        for (int x = 0; x < reports[i]['AssignedTanod'].length; x++) {
          if (reports[i]['AssignedTanod'][x]['Documentation'] != null) {
            for (int y = 0;
                y < reports[i]['AssignedTanod'][x]['Documentation'].length;
                y++) {
              if (reports[i]['AssignedTanod'][x]['Documentation'][y]
                          ['ViolatorId']
                      .toString() ==
                  violatorId) {
                count++;
              }
            }
          }
        }
      }
    }
    return count;
  }

  int _calculateNeededApprehension() {
    num apprehendCount = selectedReport[0]['ViolatorCount'];
    for (int i = 0; i < selectedReport[0]['AssignedTanod'].length; i++) {
      if (selectedReport[0]['AssignedTanod'][i]['Documentation'] != null) {
        apprehendCount -=
            selectedReport[0]['AssignedTanod'][i]['Documentation'].length;
      }
    }

    return apprehendCount.toInt();
  }

  void _autoSetViolationDocumentation(int violationInstance) {
    violationCount = violationInstance;
    if (widget.selectedViolatorId != null && updateProcess2 < 1) {
      violationCount -= 1;
      updateProcess2++;
    }
    if (violationCount < 1) {
      violationFine = fines[0];
    } else if (violationCount == 1) {
      violationFine = fines[1];
    } else {
      violationFine = fines[2];
    }
    _birthdayTextEditingController.text =
        _getSelectedViolatoInformation('Birthday');
    selectedGender = _getSelectedViolatoInformation('Gender');
    _contactNumberTextEditingController.text =
        _getSelectedViolatoInformation('Contact');
    selectedGender = _getSelectedViolatoInformation('Gender') != ''
        ? _getSelectedViolatoInformation('Gender')
        : 'Male';
    _addressTextEditingController.text =
        _getSelectedViolatoInformation('Address');
    _violationCountTextEditingController.text = violationCount.toString();
    _fineTextEditingController.text =
        '${violationFine.toStringAsFixed(2).toString()}';
  }

  String _getSelectedViolatoInformation(String search) {
    String data = '';
    for (int i = 0; i < violators.length; i++) {
      if (violators[i]['ViolatorId'].toString() == violatorId) {
        data = violators[i][search];
      }
    }
    return data;
  }

  _buildCreateSubmissionConfirmaModal(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: Text(
                'Confirmation',
                style: tertiaryText.copyWith(fontSize: 18),
              ),
              content: Text.rich(
                TextSpan(
                  style: secandaryText.copyWith(fontSize: 13, letterSpacing: 0),
                  children: [
                    TextSpan(
                      text: 'Check your documentation\n',
                      style: secandaryText.copyWith(
                          fontSize: 14, letterSpacing: 0),
                    ),
                    TextSpan(
                      text:
                          'Name: ${titleCase(_nameTextEditingController.text)}\n',
                    ),
                    TextSpan(
                      text:
                          'Birthday: ${_birthdayTextEditingController.text}\n',
                    ),
                    TextSpan(
                      text: 'Gender: $selectedGender\n',
                    ),
                    TextSpan(
                      text:
                          'Contact Number: ${_contactNumberTextEditingController.text}\n',
                    ),
                    TextSpan(
                      text:
                          'Address: ${titleCase(_addressTextEditingController.text)}\n',
                    ),
                    TextSpan(
                      text: 'Fine: ₱${_fineTextEditingController.text}\n',
                    ),
                  ],
                ),
              ),
              actions: [
                Container(
                  width: 100,
                  child: MyOutlineButton(
                    color: Color(0xff1640ac),
                    elavation: 5,
                    isLoading: false,
                    radius: 10,
                    text: Text(
                      'Cancel',
                      style: tertiaryText.copyWith(
                          fontSize: 14, color: customColor[140]),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  width: 100,
                  child: MyRaisedButton(
                    color: Color(0xff1640ac),
                    elavation: 5,
                    isLoading: isLoading,
                    radius: 10,
                    text: Text(
                      'Confirm',
                      style: tertiaryText.copyWith(
                          fontSize: 14, color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                        if (widget.selectedViolatorId == null) {
                          _saveDocumentSubmission().then((value) {
                            _nameTextEditingController.clear();
                            _birthdayTextEditingController.clear();
                            selectedGender = 'Male';
                            _contactNumberTextEditingController.clear();
                            _addressTextEditingController.clear();
                            _violationCountTextEditingController.clear();
                            _fineTextEditingController.clear();
                            Navigator.pop(context);

                            _buildModalSuccessMessage(context);
                            isLoading = false;
                            isSaveable = false;
                          });
                        } else {
                          _updateDocumentSubmission().then((value) {
                            Navigator.pop(context);
                            _buildModalSuccessMessage(context);
                            isLoading = false;
                            isSaveable = false;
                          });
                        }
                      });
                    },
                  ),
                ),
              ],
            );
          });
        });
  }

  void _validateDocumentation() {
    if (_formKey.currentState!.validate()) {
      _buildCreateSubmissionConfirmaModal(context);
    }
  }

  bool _violatorIsAlreadyApprehended() {
    bool isApprehended = false;
    for (int i = 0; i < selectedReport[0]["AssignedTanod"].length; i++) {
      if (selectedReport[0]['AssignedTanod'][i]['Documentation'] != null) {
        for (int x = 0;
            x < selectedReport[0]['AssignedTanod'][i]['Documentation'].length;
            x++) {
          if (violatorId != '') {
            if (selectedReport[0]['AssignedTanod'][i]['Documentation'][x]
                    ['ViolatorId'] ==
                violatorId) {
              if (widget.selectedViolatorId != violatorId) {
                isApprehended = true;
              }
            }
          }
        }
      }
    }
    return isApprehended;
  }

  Future<String> _saveDocumentSubmission() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(now);

    _saveViolatorInformation();
    if (selectedReport[0]['AssignedTanod']
            [selectedReport[0]['AssignedTanod'].length - 1]['Documentation'] !=
        null) {
      await dbRef
          .child('Reports')
          .child(selectedReport[0]['Id'].toString())
          .child("AssignedTanod")
          .child((selectedReport[0]['AssignedTanod'].length - 1).toString())
          .child("Documentation")
          .update({
        selectedReport[0]['AssignedTanod']
                [selectedReport[0]['AssignedTanod'].length - 1]['Documentation']
            .length
            .toString(): {
          "Id": selectedReport[0]['AssignedTanod']
                      [selectedReport[0]['AssignedTanod'].length - 1]
                  ['Documentation']
              .length
              .toString(),
          "ViolatorId": violatorId,
          "Fine": _fineTextEditingController.text,
          "DateApprehended": formattedDate,
        }
      });
    } else {
      await dbRef
          .child('Reports')
          .child(selectedReport[0]['Id'].toString())
          .child("AssignedTanod")
          .child((selectedReport[0]['AssignedTanod'].length - 1).toString())
          .update({
        "Documentation": {
          0.toString(): {
            "Id": 0,
            "ViolatorId": violatorId,
            "Fine": _fineTextEditingController.text,
            "DateApprehended": formattedDate,
          }
        }
      });
    }

    _validateReportIsTagged();
    return '';
  }

  int _getSelectedRecord(String method) {
    int selectedRecord = -1;
    for (int i = 0; i < selectedReport[0]['AssignedTanod'].length; i++) {
      if (selectedReport[0]['AssignedTanod'][i]['Documentation'] != null) {
        for (int x = 0;
            x < selectedReport[0]['AssignedTanod'][i]['Documentation'].length;
            x++) {
          if (selectedReport[0]['AssignedTanod'][i]['Documentation'][x]
                  ['ViolatorId'] ==
              widget.selectedViolatorId) {
            if (method == "AssignedTanod") {
              selectedRecord = i;
            } else {
              selectedRecord = x;
            }
          }
        }
      }
    }
    return selectedRecord;
  }

  Future<String> _updateDocumentSubmission() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(now);
    String selectedAssignedTanod =
        _getSelectedRecord("AssignedTanod").toString();
    String selectedDocument = _getSelectedRecord("Document").toString();

    _saveViolatorInformation();
    await dbRef
        .child('Reports')
        .child(selectedReport[0]['Id'].toString())
        .child("AssignedTanod")
        .child(selectedAssignedTanod)
        .child("Documentation")
        .update({
      selectedDocument: {
        "Id": selectedDocument,
        "ViolatorId": violatorId,
        "Fine": _fineTextEditingController.text,
        "DateApprehended": formattedDate,
      }
    });

    return '';
  }

  Future<String> _saveViolatorInformation() async {
    if (violatorId == '') {
      violatorId = violators.length.toString();
      //inset new violator and its information
      await dbRef.child('Violators').update({
        violators.length.toString(): {
          "ViolatorId": violators.length.toString(),
          "Name": titleCase(_nameTextEditingController.text),
          "Birthday": _birthdayTextEditingController.text,
          "Gender": selectedGender,
          "Contact": _contactNumberTextEditingController.text,
          "Address": titleCase(_addressTextEditingController.text),
        }
      });
    } else {
      //update the existing violator information
      for (int i = 0; i < violators.length; i++) {
        if (_nameTextEditingController.text == violators[i]['Name']) {
          if (_birthdayTextEditingController.text != violators[i]['Birthday']) {
            await dbRef
                .child('Violators')
                .child(violators[i]['ViolatorId'].toString())
                .update({
              "Birthday": _birthdayTextEditingController.text,
            });
          }
          if (selectedGender != violators[i]['Gender']) {
            await dbRef
                .child('Violators')
                .child(violators[i]['ViolatorId'].toString())
                .update({
              "Gender": selectedGender,
            });
          }
          if (_contactNumberTextEditingController.text !=
              violators[i]['Contact']) {
            await dbRef
                .child('Violators')
                .child(violators[i]['ViolatorId'].toString())
                .update({
              "Contact": _contactNumberTextEditingController.text,
            });
          }
          if (_addressTextEditingController.text != violators[i]['Address']) {
            await dbRef
                .child('Violators')
                .child(violators[i]['ViolatorId'].toString())
                .update({
              "Address": titleCase(_addressTextEditingController.text),
            });
          }
        }
      }
    }
    return '';
  }

  Future<void> _buildModalSuccessMessage(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        _timer = Timer(Duration(seconds: 1), () {
          Navigator.of(context).pop();
          if (isTagged) {
            violatorNames.clear();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }
        });
        return AlertDialog(
          backgroundColor: customColor[130],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          content: Container(
            height: 80,
            width: screenSize.width * .8,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Documentation has been ${widget.selectedViolatorId == null ? 'saved' : 'updated'}",
                    style: tertiaryText.copyWith(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ]),
          ),
        );
      },
    ).then((value) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    });
  }

  Future<void> _validateReportIsTagged() async {
    num totalApprehendedViolator = 0;
    for (int i = 0; i < selectedReport[0]['AssignedTanod'].length; i++) {
      if (selectedReport[0]['AssignedTanod'][i]['Documentation'] != null) {
        totalApprehendedViolator +=
            selectedReport[0]['AssignedTanod'][i]['Documentation'].length;
      }
      print(totalApprehendedViolator);
    }
    if (selectedReport[0]['ViolatorCount'] - totalApprehendedViolator.toInt() <=
        0) {
      isTagged = true;
      await dbRef
          .child('Reports')
          .child(selectedReport[0]['Id'].toString())
          .update({
        "Category": "Tagged",
      });
      await dbRef
          .child('Reports')
          .child(selectedReport[0]['Id'].toString())
          .child("AssignedTanod")
          .child((selectedReport[0]['AssignedTanod'].length - 1).toString())
          .update({
        "Status": "Apprehended",
      });
      await dbRef.child('Tanods').child(widget.tanodId).update({
        'Status': 'Standby',
      });
    } else {
      isTagged = false;
    }
  }

  _buildCreateCancelDocumentationConfirmaModal(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: Text(
                'Discard unsaved changes?',
                style: tertiaryText.copyWith(fontSize: 18),
              ),
              content: Text.rich(
                TextSpan(
                  style: secandaryText.copyWith(fontSize: 13, letterSpacing: 0),
                  children: [
                    TextSpan(
                      text:
                          'You have unsaved changes, are sure you want to discard them?',
                      style: secandaryText.copyWith(
                          fontSize: 14, letterSpacing: 0),
                    ),
                  ],
                ),
              ),
              actions: [
                Container(
                  width: 100,
                  child: MyOutlineButton(
                    color: Color(0xff1640ac),
                    elavation: 5,
                    isLoading: false,
                    radius: 10,
                    text: Text(
                      'Cancel',
                      style: tertiaryText.copyWith(
                          fontSize: 14, color: customColor[140]),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  width: 100,
                  child: MyRaisedButton(
                    color: Color(0xff1640ac),
                    elavation: 5,
                    isLoading: isLoading,
                    radius: 10,
                    text: Text(
                      'Discard',
                      style: tertiaryText.copyWith(
                          fontSize: 14, color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        violatorNames.clear();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    },
                  ),
                ),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: StreamBuilder(
          stream: dbRef.child('Violators').onValue,
          builder: (context, violatSnapshot) {
            if (violatSnapshot.hasData &&
                !violatSnapshot.hasError &&
                (violatSnapshot.data! as Event).snapshot.value != null) {
              violators = (violatSnapshot.data! as Event).snapshot.value;
            } else {
              return Scaffold(body: MySpinKitLoadingScreen());
            }

            _getViolatorNames();

            return StreamBuilder(
                stream: dbRef.child('Reports').onValue,
                builder: (context, reportSnapshot) {
                  if (reportSnapshot.hasData &&
                      !reportSnapshot.hasError &&
                      (reportSnapshot.data! as Event).snapshot.value != null) {
                    reports = (reportSnapshot.data! as Event).snapshot.value;
                  } else {
                    return Scaffold(body: MySpinKitLoadingScreen());
                  }
                  selectedReport =
                      getSelectedReportInformation(reports, widget.id);
                  if (widget.selectedViolatorId != null) {
                    _setViolatorInformation();
                  }
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      leading: IconButton(
                        icon: Icon(FontAwesomeIcons.chevronLeft),
                        color: Colors.black,
                        iconSize: 20,
                        onPressed: () {
                          if (isSaveable) {
                            _buildCreateCancelDocumentationConfirmaModal(
                                context);
                          } else {
                            violatorNames.clear();
                            Navigator.pop(context);
                          }
                        },
                      ),
                      centerTitle: true,
                      title: Text(
                        'Documentation',
                        style: primaryText.copyWith(
                            fontSize: 18, letterSpacing: 1),
                      ),
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
                                "assets/images/${selectedGender == 'Female' ? 'woman' : 'man'}.png",
                                width: 20,
                                height: 20,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            Text(
                              widget.selectedViolatorId == null
                                  ? 'Record the Violator'
                                  : 'Violator Information',
                              style: primaryText.copyWith(
                                fontSize: 16,
                                letterSpacing: 0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              widget.selectedViolatorId == null
                                  ? 'Apprehend: ${_calculateNeededApprehension().toString()}'
                                  : '',
                              style: primaryText.copyWith(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
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
                                suggestionsCallback: (pattern) =>
                                    violatorNames.where(
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
                                  setState(() {
                                    _birthdayTextEditingController.clear();
                                    selectedGender = 'Male';
                                    _contactNumberTextEditingController.clear();
                                    _addressTextEditingController.clear();
                                    _violationCountTextEditingController
                                        .clear();
                                    _fineTextEditingController.clear();

                                    _autoSetViolationDocumentation(
                                        _calculateViolatorViolationHistory(
                                            val));
                                    _checkValidToSave();
                                  });
                                },
                                getImmediateSuggestions: true,
                                hideSuggestionsOnKeyboardHide: false,
                                hideOnEmpty: false,
                                noItemsFoundBuilder: (context) => Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text('No Existing Violators Found'),
                                ),
                                textFieldConfiguration: TextFieldConfiguration(
                                  textInputAction: TextInputAction.next,
                                  onChanged: (value) {
                                    setState(() {
                                      _birthdayTextEditingController.clear();
                                      selectedGender = "Male";
                                      _contactNumberTextEditingController
                                          .clear();
                                      _addressTextEditingController.clear();
                                      _violationCountTextEditingController
                                          .clear();
                                      _violationCountTextEditingController
                                          .clear();
                                      _fineTextEditingController.clear();

                                      _autoSetViolationDocumentation(
                                          _calculateViolatorViolationHistory(
                                              value));
                                      _checkValidToSave();
                                    });
                                  },
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
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        color: Color(0xff1c52dd),
                                      ),
                                    ),
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
                                  if (_violatorIsAlreadyApprehended()) {
                                    return "Violator is already apprehended";
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
                                textAction: TextInputAction.next,
                                validation: (value) {
                                  if (value == "") {
                                    return "Birthday is empty";
                                  }
                                },
                                onChanged: (value) {},
                                onTap: () {
                                  showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate:
                                              DateTime(1900, 1, 1, 1, 0, 0),
                                          lastDate: DateTime.now())
                                      .then((selectedDate) {
                                    setState(() {
                                      if (selectedDate != null) {
                                        _birthdayTextEditingController.text =
                                            "${numberFormat(selectedDate.year)}-${numberFormat(selectedDate.month)}-${numberFormat(selectedDate.day)}";

                                        _checkValidToSave();
                                      }
                                    });
                                  });
                                },
                                prefixIcon: GestureDetector(
                                  onTap: () {},
                                  child: Icon(
                                    FontAwesomeIcons.solidCalendarAlt,
                                    size: 20,
                                    color: customColor[130],
                                  ),
                                ),
                                labelText: "Birthday",
                                hintText: "",
                                isReadOnly: true,
                                controller: _birthdayTextEditingController,
                              ),
                            ),
                            Container(
                              height: 50,
                              margin: EdgeInsets.only(
                                top: 15,
                                left: screenSize.width * .1,
                                right: screenSize.width * .1,
                              ),
                              child: FormField<String>(
                                builder: (FormFieldState<String> state) {
                                  return InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'Gender',
                                      prefixIcon: GestureDetector(
                                        onTap: () {},
                                        child: Icon(
                                          selectedGender == 'Male'
                                              ? FontAwesomeIcons.mars
                                              : selectedGender == 'Female'
                                                  ? FontAwesomeIcons.venus
                                                  : FontAwesomeIcons
                                                      .transgenderAlt,
                                          size: 20,
                                          color: customColor[130],
                                        ),
                                      ),
                                      //      labelStyle: textStyle,
                                      errorStyle: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 16.0,
                                      ),
                                      isDense: true,
                                      hintText: 'Please select reason',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          20,
                                        ),
                                      ),
                                    ),
                                    isEmpty: selectedGender == '',
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        isDense: true,
                                        value: selectedGender,
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedGender = newValue!;
                                            state.didChange(newValue);

                                            _checkValidToSaveDropDown();
                                          });
                                        },
                                        items: _DropGender.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: tertiaryText.copyWith(
                                                fontSize: 16,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  );
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
                                inputType: TextInputType.phone,
                                isObscureText: false,
                                textAction: TextInputAction.next,
                                validation: (value) {
                                  if (value == "") {
                                    return "Contact Number is empty";
                                  }
                                  if (value!.length != 11)
                                    return 'Contact Number must be of 11 digit';
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _checkValidToSave();
                                  });
                                },
                                onTap: () {},
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
                                controller: _contactNumberTextEditingController,
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
                                textAction: TextInputAction.next,
                                validation: (value) {
                                  if (value == "") {
                                    return "Address is empty";
                                  }
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _checkValidToSave();
                                  });
                                },
                                onTap: () {},
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
                                controller: _addressTextEditingController,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: 15,
                                left: screenSize.width * .1,
                                right: screenSize.width * .1,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: screenSize.width * .39,
                                    child: MyDocumentationTextFormField(
                                      inputType: TextInputType.streetAddress,
                                      isObscureText: false,
                                      textAction: TextInputAction.next,
                                      validation: (value) {},
                                      onChanged: (value) {},
                                      onTap: () {},
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
                                      controller:
                                          _violationCountTextEditingController,
                                    ),
                                  ),
                                  Container(
                                    width: screenSize.width * .39,
                                    child: MyDocumentationTextFormField(
                                      inputType: TextInputType.streetAddress,
                                      isObscureText: false,
                                      textAction: TextInputAction.next,
                                      validation: (value) {},
                                      onChanged: (value) {},
                                      onTap: () {},
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
                                      controller: _fineTextEditingController,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: 40,
                                left: screenSize.width * .21,
                                right: screenSize.width * .21,
                              ),
                              height: 50,
                              child: MyRaisedButton(
                                color: Color(0xff1c52dd),
                                elavation: 5,
                                isLoading: false,
                                onPressed: () {
                                  _validateDocumentation();
                                },
                                radius: 30,
                                text: Text(
                                  widget.selectedViolatorId == null
                                      ? 'Save'
                                      : 'Update',
                                  style: tertiaryText.copyWith(
                                    fontSize: 19,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
