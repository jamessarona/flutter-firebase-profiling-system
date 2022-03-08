import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_restart/flutter_app_restart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanood/net/authenticationService.dart';
import 'package:tanood/shared/constants.dart';
import 'package:tanood/shared/myButtons.dart';
import 'package:tanood/shared/mySpinKits.dart';
import 'package:tanood/shared/myTextFormFields.dart';

class DetailAccountScreen extends StatefulWidget {
  final String userUID;
  final String method;
  final String defaultValue;
  final String email;
  final bool isEditable;
  final BaseAuth auth;
  final VoidCallback onSignOut;
  const DetailAccountScreen({
    required this.userUID,
    required this.method,
    required this.defaultValue,
    required this.email,
    required this.isEditable,
    required this.auth,
    required this.onSignOut,
  });

  @override
  _DetailAccountScreenState createState() => _DetailAccountScreenState();
}

class _DetailAccountScreenState extends State<DetailAccountScreen> {
  late Size screenSize;
  final dbRef = FirebaseDatabase.instance.reference();

  final currentUser = FirebaseAuth.instance.currentUser;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _fieldTextEditingController = TextEditingController();
  TextEditingController _oldPasswordTextEditingController =
      TextEditingController();
  TextEditingController _newPasswordTextEditingController =
      TextEditingController();
  TextEditingController _confirmPasswordTextEditingController =
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

  var tanods;
  var userData;
  late Timer _timer;

  bool isObscureOldPassword = true;
  bool isObscureNewPassword = true;
  bool isObscureConfirmPassword = true;

  bool isLoading = false;
  bool isSaveable = false;
  bool isCurrentPasswordCorrect = true;
  String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';

  bool _checkIfReadOnly() {
    bool isReadOnly = false;
    if (widget.method == 'Email' || widget.method == 'Birthday') {
      isReadOnly = true;
    }
    return isReadOnly;
  }

  bool _checkValidToSave(String value) {
    bool isValid = false;
    if (value != widget.defaultValue) {
      isValid = true;
    }
    return isValid;
  }

  String getValidation(String value) {
    RegExp regExp = new RegExp(patttern);
    String message = '';
    if (widget.method == "Contact") {
      if (value.length != 11) {
        message = 'Contact Number must be of 11 digit';
      } else if (!regExp.hasMatch(value)) {
        message = 'Please enter valid mobile number';
      }
    }

    return message;
  }

  Future<void> _validateUpdate() async {
    if (widget.method == 'Password') {
      isCurrentPasswordCorrect = await validateCurrentPassword();
      setState(() {});
    }
    if (_formKey.currentState!.validate()) {
      _buildCreateUpdateConfirmaModal(context);
    }
  }

  Future<bool> validateCurrentPassword() async {
    User? firebaseUser = currentUser;

    if (firebaseUser != null) {
      var authCredential = EmailAuthProvider.credential(
        email: widget.email,
        password: _oldPasswordTextEditingController.text,
      );
      try {
        var authResult =
            await firebaseUser.reauthenticateWithCredential(authCredential);
        return authResult.user != null;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  _buildCreateUpdateConfirmaModal(BuildContext context) {
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
                widget.method != 'Password'
                    ? TextSpan(
                        style: secandaryText.copyWith(
                            fontSize: 13, letterSpacing: 0),
                        children: [
                          TextSpan(
                            text: '${widget.method}\n',
                            style: secandaryText.copyWith(
                                fontSize: 14, letterSpacing: 0),
                          ),
                          TextSpan(
                            text:
                                'Old: ${widget.method != 'Role' ? widget.defaultValue : widget.defaultValue == '0' ? 'Chief Tanod' : 'Barangay Tanod'}\n',
                          ),
                          TextSpan(
                            text:
                                'New: ${widget.method == 'Gender' ? selectedGender : widget.method == 'Role' ? selectedRole : titleCase(_fieldTextEditingController.text)}\n',
                          ),
                        ],
                      )
                    : TextSpan(
                        text: 'You will be ',
                        style: secandaryText.copyWith(
                            fontSize: 13, letterSpacing: 0),
                        children: [
                          TextSpan(
                            text: 'redirected ',
                            style: secandaryText.copyWith(
                              fontSize: 13,
                              letterSpacing: 0,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'in the login page after this process.',
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
                      'Update',
                      style: tertiaryText.copyWith(
                          fontSize: 14, color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                        if (widget.method != 'Password') {
                          _saveUpdate().then((value) {
                            _fieldTextEditingController.clear();
                            Navigator.pop(context);

                            _buildModalSuccessMessage(context);
                            isLoading = false;
                          });
                        } else {
                          _updatePassword().then((value) {
                            _oldPasswordTextEditingController.clear();
                            _newPasswordTextEditingController.clear();
                            _confirmPasswordTextEditingController.clear();
                            Navigator.pop(context);
                            _buildModalSuccessMessage(context);
                            isLoading = false;
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

  _buildCreateCancelUpdateConfirmaModal(BuildContext context) {
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

  Future<String> _saveUpdate() async {
    await dbRef.child('Tanods').child(userData['TanodId']).update({
      widget.method: widget.method == 'Gender'
          ? selectedGender
          : titleCase(_fieldTextEditingController.text.toString()),
    });
    return '';
  }

  Future<String> _updatePassword() async {
    User? firebaseUser = currentUser;
    firebaseUser!
        .updatePassword(_newPasswordTextEditingController.text)
        .then((_) {
      print("Successfully changed password");
    }).catchError((error) {
      print("Password can't be changed" + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
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
          Navigator.of(context).pop();
          if (widget.method == 'Password') {
            widget.auth
                .signOut()
                .then((value) async => await FlutterRestart.restartApp());
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
                    widget.method != 'Password'
                        ? "Modification has been saved."
                        : "Password has been changed.",
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
  void initState() {
    super.initState();
    _fieldTextEditingController.text = widget.defaultValue;
    setState(() {
      if (widget.method == 'Gender') {
        selectedGender = widget.defaultValue;
      }
      if (widget.method == 'Role') {
        selectedRole =
            widget.defaultValue == '1' ? 'Barangay Tanod' : 'Chief Tanod';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          isLoading
              ? print('Please wait')
              : isSaveable
                  ? _buildCreateCancelUpdateConfirmaModal(context)
                  : Navigator.of(context).pop();
          return false;
        },
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
                isLoading
                    ? print('Please wait')
                    : isSaveable
                        ? _buildCreateCancelUpdateConfirmaModal(context)
                        : Navigator.of(context).pop();
              },
            ),
            centerTitle: true,
            title: Text(
              "Edit ${widget.method == 'Firstname' ? 'First name' : widget.method == 'Lastname' ? 'Last name' : widget.method}",
              style: primaryText.copyWith(fontSize: 18, letterSpacing: 1),
            ),
            actions: [],
          ),
          body: StreamBuilder(
            stream: dbRef.child('Tanods').onValue,
            builder: (context, tanodSnapshot) {
              if (tanodSnapshot.hasData &&
                  !tanodSnapshot.hasError &&
                  (tanodSnapshot.data! as Event).snapshot.value != null) {
                tanods = (tanodSnapshot.data! as Event).snapshot.value;
              } else {
                return MySpinKitLoadingScreen();
              }
              userData =
                  filterCurrentUserInformation(tanods, widget.userUID)[0];
              return Form(
                key: _formKey,
                child: Container(
                  height: screenSize.height,
                  width: screenSize.width,
                  child: ListView(
                    children: [
                      widget.method == 'Firstname' ||
                              widget.method == 'Lastname' ||
                              widget.method == 'Email' ||
                              widget.method == 'Contact' ||
                              widget.method == 'Address'
                          ? Container(
                              margin: EdgeInsets.only(
                                top: 10,
                                left: screenSize.width * .1,
                                right: screenSize.width * .1,
                              ),
                              child: MyDocumentationTextFormField(
                                inputType: TextInputType.name,
                                isObscureText: false,
                                textAction: TextInputAction.done,
                                validation: (value) {
                                  if (value != null) {
                                    return getValidation(value) != ''
                                        ? getValidation(value)
                                        : null;
                                  } else {
                                    return '${widget.method} is empty';
                                  }
                                },
                                onChanged: (value) {
                                  setState(() {
                                    if (value != '') {
                                      isSaveable = _checkValidToSave(value!);
                                    } else {
                                      isSaveable = false;
                                    }
                                  });
                                },
                                onTap: () {},
                                prefixIcon: null,
                                labelText: widget.method,
                                hintText: "",
                                isReadOnly: _checkIfReadOnly(),
                                controller: _fieldTextEditingController,
                              ),
                            )
                          : widget.method == 'Password'
                              ? Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 10,
                                        left: screenSize.width * .1,
                                        right: screenSize.width * .1,
                                      ),
                                      child: MyPasswordTextFormField(
                                        inputType: TextInputType.name,
                                        isObscureText: isObscureOldPassword,
                                        textAction: TextInputAction.next,
                                        validation: (value) {
                                          if (value == '') {
                                            return 'Password is Empty';
                                          }

                                          if (!isCurrentPasswordCorrect) {
                                            return 'Password is incorrect';
                                          }
                                          // validatePassword(value!);
                                          // print('Answer: $isInCorrectPassword');
                                          // if (isInCorrectPassword) {
                                          //   return 'Incorrect Password';
                                          // }
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            if (_oldPasswordTextEditingController.text != '' &&
                                                _newPasswordTextEditingController
                                                        .text !=
                                                    '' &&
                                                _confirmPasswordTextEditingController
                                                        .text !=
                                                    '') {
                                              isSaveable = true;
                                            } else {
                                              isSaveable = false;
                                            }
                                          });
                                        },
                                        onTap: () {},
                                        prefixIcon: null,
                                        labelText: 'Current ${widget.method}',
                                        hintText: "",
                                        isReadOnly: _checkIfReadOnly(),
                                        controller:
                                            _oldPasswordTextEditingController,
                                        onTapSuffixIcon: () {
                                          setState(() {
                                            isObscureOldPassword =
                                                !isObscureOldPassword;
                                          });
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 10,
                                        left: screenSize.width * .1,
                                        right: screenSize.width * .1,
                                      ),
                                      child: MyPasswordTextFormField(
                                        inputType: TextInputType.name,
                                        isObscureText: isObscureNewPassword,
                                        textAction: TextInputAction.next,
                                        validation: (value) {
                                          if (value == '') {
                                            return 'Password is Empty';
                                          } else if (value!.length < 6) {
                                            return 'Password is to short';
                                          } else if (value ==
                                              _oldPasswordTextEditingController
                                                  .text) {
                                            return 'Password is the same from current password';
                                          }
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            if (_oldPasswordTextEditingController.text != '' &&
                                                _newPasswordTextEditingController
                                                        .text !=
                                                    '' &&
                                                _confirmPasswordTextEditingController
                                                        .text !=
                                                    '') {
                                              isSaveable = true;
                                            } else {
                                              isSaveable = false;
                                            }
                                          });
                                        },
                                        onTap: () {},
                                        prefixIcon: null,
                                        labelText: 'New ${widget.method}',
                                        hintText: "",
                                        isReadOnly: _checkIfReadOnly(),
                                        controller:
                                            _newPasswordTextEditingController,
                                        onTapSuffixIcon: () {
                                          setState(() {
                                            isObscureNewPassword =
                                                !isObscureNewPassword;
                                          });
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 10,
                                        left: screenSize.width * .1,
                                        right: screenSize.width * .1,
                                      ),
                                      child: MyPasswordTextFormField(
                                        inputType: TextInputType.name,
                                        isObscureText: isObscureConfirmPassword,
                                        textAction: TextInputAction.done,
                                        validation: (value) {
                                          if (value == '') {
                                            return 'Password is Empty';
                                          } else if (_newPasswordTextEditingController
                                                  .text !=
                                              _confirmPasswordTextEditingController
                                                  .text) {
                                            return 'New Password is not matched';
                                          }
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            if (_oldPasswordTextEditingController.text != '' &&
                                                _newPasswordTextEditingController
                                                        .text !=
                                                    '' &&
                                                _confirmPasswordTextEditingController
                                                        .text !=
                                                    '') {
                                              isSaveable = true;
                                            } else {
                                              isSaveable = false;
                                            }
                                          });
                                        },
                                        onTap: () {},
                                        prefixIcon: null,
                                        labelText: 'Confirm ${widget.method}',
                                        hintText: "",
                                        isReadOnly: _checkIfReadOnly(),
                                        controller:
                                            _confirmPasswordTextEditingController,
                                        onTapSuffixIcon: () {
                                          setState(() {
                                            isObscureConfirmPassword =
                                                !isObscureConfirmPassword;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : widget.method == 'Birthday'
                                  ? Container(
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
                                                  firstDate: DateTime(
                                                      1900, 1, 1, 1, 0, 0),
                                                  lastDate: DateTime.now())
                                              .then((selectedDate) {
                                            setState(() {
                                              if (selectedDate != null) {
                                                _fieldTextEditingController
                                                        .text =
                                                    "${numberFormat(selectedDate.year)}-${numberFormat(selectedDate.month)}-${numberFormat(selectedDate.day)}";

                                                isSaveable = _checkValidToSave(
                                                    _fieldTextEditingController
                                                        .text);
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
                                        controller: _fieldTextEditingController,
                                      ),
                                    )
                                  : widget.method == 'Gender'
                                      ? Container(
                                          height: 50,
                                          margin: EdgeInsets.only(
                                            top: 15,
                                            left: screenSize.width * .1,
                                            right: screenSize.width * .1,
                                          ),
                                          child: FormField<String>(
                                            builder:
                                                (FormFieldState<String> state) {
                                              return InputDecorator(
                                                decoration: InputDecoration(
                                                  labelText: 'Gender',
                                                  prefixIcon: GestureDetector(
                                                    onTap: () {},
                                                    child: Icon(
                                                      selectedGender == 'Male'
                                                          ? FontAwesomeIcons
                                                              .mars
                                                          : selectedGender ==
                                                                  'Female'
                                                              ? FontAwesomeIcons
                                                                  .venus
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
                                                  hintText:
                                                      'Please select a gender',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      20,
                                                    ),
                                                  ),
                                                ),
                                                isEmpty: selectedGender == '',
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton<String>(
                                                    isDense: true,
                                                    value: selectedGender,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        selectedGender =
                                                            newValue!;
                                                        state.didChange(
                                                            newValue);
                                                        isSaveable =
                                                            _checkValidToSave(
                                                                newValue);
                                                      });
                                                    },
                                                    items: _DropGender.map(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(
                                                          value,
                                                          style: tertiaryText
                                                              .copyWith(
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
                                        )
                                      : Container(
                                          height: 50,
                                          margin: EdgeInsets.only(
                                            top: 15,
                                            left: screenSize.width * .1,
                                            right: screenSize.width * .1,
                                          ),
                                          child: FormField<String>(
                                            builder:
                                                (FormFieldState<String> state) {
                                              return InputDecorator(
                                                decoration: InputDecoration(
                                                  labelText: 'Role',
                                                  prefixIcon: GestureDetector(
                                                    onTap: () {},
                                                    child: Icon(
                                                      FontAwesomeIcons
                                                          .hatCowboy,
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
                                                  hintText:
                                                      'Please select a role',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      20,
                                                    ),
                                                  ),
                                                ),
                                                isEmpty: selectedRole == '',
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton<String>(
                                                    isDense: true,
                                                    value: selectedRole,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        if (widget
                                                                .defaultValue ==
                                                            '0') {
                                                          selectedRole =
                                                              newValue!;
                                                          state.didChange(
                                                              newValue);
                                                          // isSaveable =
                                                          //     _checkValidToSave(
                                                          //         selectedRole);
                                                        }
                                                      });
                                                    },
                                                    items: _DropRole.map(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(
                                                          value,
                                                          style: tertiaryText
                                                              .copyWith(
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
                    ],
                  ),
                ),
              );
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: isSaveable
              ? FloatingActionButton(
                  onPressed: () {
                    isLoading ? print('Please wait') : _validateUpdate();
                  },
                  backgroundColor: customColor[130],
                  child: Icon(FontAwesomeIcons.save),
                )
              : Container(),
        ),
      ),
    );
  }
}
