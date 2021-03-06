import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tanood/net/authenticationService.dart';
import 'package:tanood/screens/detailAccountScreen.dart';
import 'package:tanood/shared/constants.dart';
import 'package:tanood/shared/myButtons.dart';
import 'package:tanood/shared/myCards.dart';
import 'package:tanood/shared/myListTile.dart';
import 'package:tanood/shared/mySpinKits.dart';

class MyAccountScreen extends StatefulWidget {
  final String userUID;
  final BaseAuth auth;
  final VoidCallback onSignOut;
  const MyAccountScreen({
    required this.userUID,
    required this.auth,
    required this.onSignOut,
  });

  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  late Size screenSize;
  final dbRef = FirebaseDatabase.instance.reference();
  final _storage = FirebaseStorage.instance.ref();
  var tanods;
  var userData;
  File? image;

  bool isLoading = false;
  bool isDeletePhoto = false;

  _buildCreateChooseModal(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyPhotoOptionListTile(
                    onTap: () {
                      pickImage(ImageSource.camera);
                    },
                    icon: FontAwesomeIcons.cameraRetro,
                    title: 'Camera',
                  ),
                  MyPhotoOptionListTile(
                    onTap: () {
                      pickImage(ImageSource.gallery);
                    },
                    icon: FontAwesomeIcons.images,
                    title: 'Gallery',
                  ),
                  MyPhotoOptionListTile(
                    onTap: () {
                      isDeletePhoto = true;
                      deletePhoto();
                      Navigator.pop(context);
                    },
                    icon: FontAwesomeIcons.trashAlt,
                    title: 'Delete Photo',
                  ),
                ],
              ),
            );
          });
        });
  }

  String deletePhoto() {
    image = null;
    setState(() {});
    return '';
  }

  Future pickImage(ImageSource choice) async {
    try {
      final image = await ImagePicker().pickImage(
        source: choice,
      );
      if (image != null) {
        setState(() {
          final imageTemporary = File(image.path);
          this.image = imageTemporary;
        });
        Navigator.pop(context);
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<String> uploadImage() async {
    var snapshot =
        await _storage.child('Tanods/${widget.userUID}').putFile(image!);

    var imageURL = await (snapshot).ref.getDownloadURL();

    saveToRealtimeDatabase(imageURL);
    return '';
  }

  Future<String> saveToRealtimeDatabase(String url) async {
    dbRef.child('Tanods').child(userData['TanodId']).update({
      'Image': url,
    });
    return '';
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

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          isLoading
              ? print('Please wait')
              : isDeletePhoto || image != null
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
                    : isDeletePhoto || image != null
                        ? _buildCreateCancelUpdateConfirmaModal(context)
                        : Navigator.of(context).pop();
              },
            ),
            centerTitle: true,
            title: Text(
              'My Account',
              style: primaryText.copyWith(fontSize: 18, letterSpacing: 1),
            ),
            actions: [
              image != null || isDeletePhoto
                  ? isLoading
                      ? Container(
                          margin:
                              EdgeInsets.only(right: screenSize.width * .04),
                          child: SpinKitRing(
                            size: 16,
                            color: Color(0xff1c52dd),
                            lineWidth: 2,
                          ),
                        )
                      : IconButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  if (isDeletePhoto) {
                                    setState(() {
                                      saveToRealtimeDatabase('default');
                                      isDeletePhoto = false;
                                      isLoading = false;
                                    });
                                  } else {
                                    uploadImage().then((value) {
                                      setState(() {
                                        isLoading = false;
                                        image = null;
                                      });
                                    });
                                  }
                                },
                          icon: Icon(
                            FontAwesomeIcons.save,
                            color: customColor[130],
                            size: 20,
                          ),
                        )
                  : Container(),
            ],
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
                return Container(
                  height: screenSize.height,
                  width: screenSize.width,
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 10,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            userData['Image'] == 'default' || isDeletePhoto
                                ? Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: customColor[130],
                                    ),
                                    child: image != null
                                        ? ClipOval(
                                            child: Image.file(
                                              image!,
                                              width: 10,
                                              height: 10,
                                              fit: BoxFit.fill,
                                            ),
                                          )
                                        : Image.asset(
                                            "assets/images/default.png",
                                            width: 10,
                                            height: 10,
                                            fit: BoxFit.fitHeight,
                                          ),
                                  )
                                : Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: customColor[130],
                                    ),
                                    child: ClipOval(
                                      child: image != null
                                          ? Image.file(
                                              image!,
                                              width: 10,
                                              height: 10,
                                              fit: BoxFit.fill,
                                            )
                                          : Image.network(
                                              userData['Image'],
                                              width: 10,
                                              height: 10,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                            Container(
                              margin: EdgeInsets.only(left: 60, top: 60),
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  _buildCreateChooseModal(context);
                                },
                                child: Icon(
                                  FontAwesomeIcons.camera,
                                  color: customColor[130],
                                  size: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                left: 4,
                                bottom: 5,
                              ),
                              child: Text(
                                'User Information',
                                style: tertiaryText.copyWith(
                                    fontSize: 16,
                                    letterSpacing: 0,
                                    color: Colors.grey[800]),
                              ),
                            ),
                            MyAccountInformationCard(
                              title: "First name",
                              value: userData['Firstname'],
                              onTap: () {
                                isLoading
                                    ? print('Please wait')
                                    : Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) => DetailAccountScreen(
                                            userUID: widget.userUID,
                                            method: 'Firstname',
                                            defaultValue: userData['Firstname'],
                                            email: userData['Email'],
                                            isEditable: true,
                                            auth: widget.auth,
                                            onSignOut: widget.onSignOut,
                                          ),
                                        ),
                                      );
                              },
                            ),
                            MyAccountInformationCard(
                              title: "Last name",
                              value: userData['Lastname'],
                              onTap: () {
                                isLoading
                                    ? print('Please wait')
                                    : Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) => DetailAccountScreen(
                                            userUID: widget.userUID,
                                            method: 'Lastname',
                                            defaultValue: userData['Lastname'],
                                            email: userData['Email'],
                                            isEditable: true,
                                            auth: widget.auth,
                                            onSignOut: widget.onSignOut,
                                          ),
                                        ),
                                      );
                              },
                            ),
                            MyAccountInformationCard(
                              title: "Email",
                              value: userData['Email'],
                              onTap: () {
                                isLoading
                                    ? print('Please wait')
                                    : Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) => DetailAccountScreen(
                                            userUID: widget.userUID,
                                            method: 'Email',
                                            defaultValue: userData['Email'],
                                            email: userData['Email'],
                                            isEditable: false,
                                            auth: widget.auth,
                                            onSignOut: widget.onSignOut,
                                          ),
                                        ),
                                      );
                              },
                            ),
                            MyAccountInformationCard(
                              title: "Password",
                              value: '',
                              onTap: () {
                                isLoading
                                    ? print('Please wait')
                                    : Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) => DetailAccountScreen(
                                            userUID: widget.userUID,
                                            method: 'Password',
                                            defaultValue: '',
                                            email: userData['Email'],
                                            isEditable: true,
                                            auth: widget.auth,
                                            onSignOut: widget.onSignOut,
                                          ),
                                        ),
                                      );
                              },
                            ),
                            MyAccountInformationCard(
                              title: "Birthday",
                              value:
                                  '${setDateTime(userData['Birthday'], 'Date')} / (${calculateAge(userData['Birthday'])})',
                              onTap: () {
                                isLoading
                                    ? print('Please wait')
                                    : Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) => DetailAccountScreen(
                                            userUID: widget.userUID,
                                            method: 'Birthday',
                                            defaultValue: userData['Birthday'],
                                            email: userData['Email'],
                                            isEditable: true,
                                            auth: widget.auth,
                                            onSignOut: widget.onSignOut,
                                          ),
                                        ),
                                      );
                              },
                            ),
                            MyAccountInformationCard(
                              title: "Gender",
                              value: userData['Gender'],
                              onTap: () {
                                isLoading
                                    ? print('Please wait')
                                    : Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) => DetailAccountScreen(
                                            userUID: widget.userUID,
                                            method: 'Gender',
                                            defaultValue: userData['Gender'],
                                            email: userData['Email'],
                                            isEditable: true,
                                            auth: widget.auth,
                                            onSignOut: widget.onSignOut,
                                          ),
                                        ),
                                      );
                              },
                            ),
                            MyAccountInformationCard(
                              title: "Contact",
                              value: userData['Contact'],
                              onTap: () {
                                isLoading
                                    ? print('Please wait')
                                    : Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) => DetailAccountScreen(
                                            userUID: widget.userUID,
                                            method: 'Contact',
                                            defaultValue: userData['Contact'],
                                            email: userData['Email'],
                                            isEditable: true,
                                            auth: widget.auth,
                                            onSignOut: widget.onSignOut,
                                          ),
                                        ),
                                      );
                              },
                            ),
                            MyAccountInformationCard(
                              title: "Address",
                              value: userData['Address'],
                              onTap: () {
                                isLoading
                                    ? print('Please wait')
                                    : Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) => DetailAccountScreen(
                                            userUID: widget.userUID,
                                            method: 'Address',
                                            defaultValue: userData['Address'],
                                            email: userData['Email'],
                                            isEditable: true,
                                            auth: widget.auth,
                                            onSignOut: widget.onSignOut,
                                          ),
                                        ),
                                      );
                              },
                            ),
                            MyAccountInformationCard(
                              title: "Role",
                              value: userData['Role'] == '0'
                                  ? 'Chief Tanod'
                                  : 'Barangay Tanod',
                              onTap: () {
                                isLoading
                                    ? print('Please wait')
                                    : Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) => DetailAccountScreen(
                                            userUID: widget.userUID,
                                            method: 'Role',
                                            defaultValue: userData['Role'],
                                            email: userData['Email'],
                                            isEditable: false,
                                            auth: widget.auth,
                                            onSignOut: widget.onSignOut,
                                          ),
                                        ),
                                      );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
