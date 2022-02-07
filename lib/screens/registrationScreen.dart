import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanod_apprehension/net/authenticationService.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/myButtons.dart';
import 'package:tanod_apprehension/shared/mySpinKits.dart';
import 'package:tanod_apprehension/shared/myTextFormFields.dart';

class RegistrationScreen extends StatefulWidget {
  final VoidCallback? onSignIn;
  final BaseAuth auth;
  const RegistrationScreen({required this.auth, this.onSignIn});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late Size screenSize;

  final dbRef = FirebaseDatabase.instance.reference();
  var tanods;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _firstnameTextEditingController =
      TextEditingController();
  TextEditingController _lastnameTextEditingController =
      TextEditingController();
  TextEditingController _emailTextEditingController = TextEditingController();
  TextEditingController _birthdayTextEditingController =
      TextEditingController();
  TextEditingController _addressTextEditingController = TextEditingController();
  TextEditingController _contactNumberTextEditingController =
      TextEditingController();

  String selectedGender = "Male";
  static const _DropGender = [
    "Male",
    "Female",
    "Others",
  ];
  String selectedRole = "Barangay Tanod";
  static const _DropRole = [
    "Barangay Tanod",
    "Chief Tanod",
  ];
  bool isLoading = false;
  late Timer _timer;
  void _validateRegistration() {
    if (_formKey.currentState!.validate()) {
      _buildCreateSubmissionConfirmaModal(context);
    }
  }

  bool isEmailExisting() {
    bool isExisting = false;
    for (int i = 0; i < tanods.length; i++) {
      if (tanods[i]['Email'] == _emailTextEditingController.text) {
        isExisting = true;
      }
    }
    return isExisting;
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
                      text: 'Check your registration\n',
                      style: secandaryText.copyWith(
                          fontSize: 14, letterSpacing: 0),
                    ),
                    TextSpan(
                      text:
                          'Firstname: ${titleCase(_firstnameTextEditingController.text)}\n',
                    ),
                    TextSpan(
                      text:
                          'Lastname: ${titleCase(_lastnameTextEditingController.text)}\n',
                    ),
                    TextSpan(
                      text: 'Email: ${_emailTextEditingController.text}\n',
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
                      text: 'Role: $selectedRole\n',
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
                        _saveRegistration().then((value) {
                          _firstnameTextEditingController.clear();
                          _lastnameTextEditingController.clear();
                          _emailTextEditingController.clear();
                          _birthdayTextEditingController.clear();
                          selectedGender = 'Male';
                          _contactNumberTextEditingController.clear();
                          _addressTextEditingController.clear();
                          selectedRole = 'Barangay Tanod';
                          Navigator.pop(context);

                          _buildModalSuccessMessage(context);
                          isLoading = false;
                        });
                      });
                    },
                  ),
                ),
              ],
            );
          });
        });
  }

  Future<String> _saveRegistration() async {
    await widget.auth
        .registerWithEmailPasswordAdmin(
            _emailTextEditingController.text, "tanod123")
        .then((value) async {
      if (value != '') {
        await dbRef.child('Tanods').update({
          tanods.length.toString(): {
            "Area": 'ShopStrutt.ph',
            "Address": titleCase(_addressTextEditingController.text.toString()),
            "Contact": _contactNumberTextEditingController.text.toString(),
            "Email": _emailTextEditingController.text.toString(),
            "Firstname":
                titleCase(_firstnameTextEditingController.text.toString()),
            "Gender": selectedGender.toString(),
            "Birthday": _birthdayTextEditingController.text.toString(),
            "Image": "default",
            "Lastname":
                titleCase(_lastnameTextEditingController.text.toString()),
            "Status": 'Standby',
            "Role": selectedRole == 'Barangay Tanod' ? '1' : '0',
            "TanodId": tanods.length.toString(),
            "TanodUID": value,
            "Token": "?",
          }
        });
      } else {
        return 'fail';
      }
    });

    return '';
  }

  Future<void> _buildModalSuccessMessage(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        _timer = Timer(Duration(seconds: 1), () {
          Navigator.of(context).pop();
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
                    "Registration has been saved",
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

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              FontAwesomeIcons.chevronLeft,
              color: Colors.black,
              size: 18,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text(
            'Registration',
            style: primaryText.copyWith(fontSize: 18, letterSpacing: 1),
          ),
        ),
        body: StreamBuilder<Object>(
            stream: dbRef.child('Tanods').onValue,
            builder: (context, tanodSnapshot) {
              if (tanodSnapshot.hasData &&
                  !tanodSnapshot.hasError &&
                  (tanodSnapshot.data! as Event).snapshot.value != null) {
                tanods = (tanodSnapshot.data! as Event).snapshot.value;
              } else {
                return Scaffold(
                  body: Center(
                    child: MySpinKitLoadingScreen(),
                  ),
                );
              }
              return Form(
                key: _formKey,
                child: Container(
                  height: screenSize.height,
                  width: screenSize.width,
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 15,
                          left: screenSize.width * .1,
                          right: screenSize.width * .1,
                        ),
                        child: Text(
                          'Information',
                          style: tertiaryText.copyWith(fontSize: 15),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 10,
                          left: screenSize.width * .1,
                          right: screenSize.width * .1,
                        ),
                        child: MyDocumentationTextFormField(
                          inputType: TextInputType.name,
                          isObscureText: false,
                          textAction: TextInputAction.next,
                          validation: (value) {
                            if (value == "") {
                              return "Firstname is empty";
                            }
                          },
                          onChanged: (value) {},
                          onTap: () {},
                          prefixIcon: GestureDetector(
                            onTap: () {},
                            child: Icon(
                              FontAwesomeIcons.userAlt,
                              size: 20,
                              color: customColor[130],
                            ),
                          ),
                          labelText: "Firstname",
                          hintText: "",
                          isReadOnly: false,
                          controller: _firstnameTextEditingController,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 15,
                          left: screenSize.width * .1,
                          right: screenSize.width * .1,
                        ),
                        child: MyDocumentationTextFormField(
                          inputType: TextInputType.name,
                          isObscureText: false,
                          textAction: TextInputAction.next,
                          validation: (value) {
                            if (value == "") {
                              return "Lastname is empty";
                            }
                          },
                          onChanged: (value) {},
                          onTap: () {},
                          prefixIcon: GestureDetector(
                            onTap: () {},
                            child: Icon(
                              FontAwesomeIcons.userAlt,
                              size: 20,
                              color: customColor[130],
                            ),
                          ),
                          labelText: "Lastname",
                          hintText: "",
                          isReadOnly: false,
                          controller: _lastnameTextEditingController,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 15,
                          left: screenSize.width * .1,
                          right: screenSize.width * .1,
                        ),
                        child: MyDocumentationTextFormField(
                          inputType: TextInputType.emailAddress,
                          isObscureText: false,
                          textAction: TextInputAction.next,
                          validation: (value) {
                            if (value == "") {
                              return "Email is empty";
                            }
                            bool emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value!);
                            if (!emailValid) {
                              return "Invalid Format";
                            }
                            if (isEmailExisting()) {
                              return "Email already registed";
                            }
                          },
                          onChanged: (value) {},
                          onTap: () {},
                          prefixIcon: GestureDetector(
                            onTap: () {},
                            child: Icon(
                              FontAwesomeIcons.solidEnvelope,
                              size: 20,
                              color: customColor[130],
                            ),
                          ),
                          labelText: "Email",
                          hintText: "",
                          isReadOnly: false,
                          controller: _emailTextEditingController,
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
                                    firstDate: DateTime(1900, 1, 1, 1, 0, 0),
                                    lastDate: DateTime.now())
                                .then((selectedDate) {
                              setState(() {
                                if (selectedDate != null) {
                                  _birthdayTextEditingController.text =
                                      "${numberFormat(selectedDate.year)}-${numberFormat(selectedDate.month)}-${numberFormat(selectedDate.month)}";
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
                                            : FontAwesomeIcons.transgenderAlt,
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
                                hintText: 'Please select a gender',
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
                          onChanged: (value) {},
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
                          onChanged: (value) {},
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
                                labelText: 'Role',
                                prefixIcon: GestureDetector(
                                  onTap: () {},
                                  child: Icon(
                                    FontAwesomeIcons.hatCowboy,
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
                                hintText: 'Please select a role',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ),
                                ),
                              ),
                              isEmpty: selectedRole == '',
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isDense: true,
                                  value: selectedRole,
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedRole = newValue!;
                                      state.didChange(newValue);
                                    });
                                  },
                                  items: _DropRole.map((String value) {
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
                            _validateRegistration();
                          },
                          radius: 30,
                          text: Text(
                            'Save',
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
              );
            }),
      ),
    );
  }
}
