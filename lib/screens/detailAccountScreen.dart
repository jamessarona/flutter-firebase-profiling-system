import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/myButtons.dart';
import 'package:tanod_apprehension/shared/mySpinKits.dart';
import 'package:tanod_apprehension/shared/myTextFormFields.dart';

class DetailAccountScreen extends StatefulWidget {
  final String userUID;
  final String method;
  final String defaultValue;
  final bool isEditable;
  const DetailAccountScreen({
    required this.userUID,
    required this.method,
    required this.defaultValue,
    required this.isEditable,
  });

  @override
  _DetailAccountScreenState createState() => _DetailAccountScreenState();
}

class _DetailAccountScreenState extends State<DetailAccountScreen> {
  late Size screenSize;
  final dbRef = FirebaseDatabase.instance.reference();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _fieldTextEditingController = TextEditingController();
  TextEditingController _oldPasswordTextEditingController =
      TextEditingController();
  TextEditingController _newPasswordTextEditingController =
      TextEditingController();
  TextEditingController _confirmPasswordTextEditingController =
      TextEditingController();
  var tanods;
  var userData;
  late Timer _timer;
  bool isObscureOldPassword = true;
  bool isObscureNewPassword = true;
  bool isObscureConfirmPassword = true;

  bool isLoading = false;
  bool isSaveable = false;

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
        return 'Please enter valid mobile number';
      }
    }
    return message;
  }

  void _validateUpdate() {
    if (_formKey.currentState!.validate()) {
      _buildCreateUpdateConfirmaModal(context);
    }
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
                TextSpan(
                  style: secandaryText.copyWith(fontSize: 13, letterSpacing: 0),
                  children: [
                    TextSpan(
                      text: '${widget.method}\n',
                      style: secandaryText.copyWith(
                          fontSize: 14, letterSpacing: 0),
                    ),
                    TextSpan(
                      text: 'Old: ${widget.defaultValue}\n',
                    ),
                    TextSpan(
                      text:
                          'New: ${titleCase(_fieldTextEditingController.text)}\n',
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
                        _saveUpdate().then((value) {
                          _fieldTextEditingController.clear();
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

  Future<String> _saveUpdate() async {
    await dbRef.child('Tanods').child(userData['TanodId']).update({
      widget.method: titleCase(_fieldTextEditingController.text.toString()),
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
                    "Modification has been saved",
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
              isLoading ? print('Please wait') : Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text(
            'Edit ${widget.method}',
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
            userData = filterCurrentUserInformation(tanods, widget.userUID)[0];
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
                                        // if (value != '') {
                                        //   return getValidation(value) != ''
                                        //       ? getValidation(value)
                                        //       : null;
                                        // } else {
                                        //   return '${widget.method} is empty';
                                        // }
                                      },
                                      onChanged: (value) {
                                        if (_oldPasswordTextEditingController.text != '' &&
                                            _newPasswordTextEditingController
                                                    .text !=
                                                '' &&
                                            _confirmPasswordTextEditingController
                                                    .text !=
                                                '') {
                                          isSaveable =
                                              _checkValidToSave(value!);
                                        } else {
                                          isSaveable = false;
                                        }
                                      },
                                      onTap: () {},
                                      prefixIcon: null,
                                      labelText: 'Old ${widget.method}',
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
                                        // if (value != '') {
                                        //   return getValidation(value) != ''
                                        //       ? getValidation(value)
                                        //       : null;
                                        // } else {
                                        //   return '${widget.method} is empty';
                                        // }
                                      },
                                      onChanged: (value) {
                                        if (_oldPasswordTextEditingController.text != '' &&
                                            _newPasswordTextEditingController
                                                    .text !=
                                                '' &&
                                            _confirmPasswordTextEditingController
                                                    .text !=
                                                '') {
                                          isSaveable =
                                              _checkValidToSave(value!);
                                        } else {
                                          isSaveable = false;
                                        }
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
                                        // if (value != '') {
                                        //   return getValidation(value) != ''
                                        //       ? getValidation(value)
                                        //       : null;
                                        // } else {
                                        //   return '${widget.method} is empty';
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
                                            isSaveable =
                                                _checkValidToSave(value!);
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
                                ? Container()
                                : widget.method == 'Gender'
                                    ? Container()
                                    : Text('data'),
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
    );
  }
}
