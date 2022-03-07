import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanood/net/authenticationService.dart';
import 'package:tanood/shared/constants.dart';
import 'package:tanood/shared/myButtons.dart';
import 'package:tanood/shared/mySpinKits.dart';
import 'package:tanood/shared/myTextFormFields.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onSignIn;
  final BaseAuth auth;
  const LoginScreen({required this.auth, this.onSignIn});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

FocusNode myPasswordNode = new FocusNode();
FocusNode myEmailNode = new FocusNode();
late Size screenSize;
final dbRef = FirebaseDatabase.instance.reference();
String email = "", password = "";
bool isobscureText = true, _isLoading = false, _authIsNotValid = false;
String authMessage = '';
String regEx =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
var tanods;

class _LoginScreenState extends State<LoginScreen> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void firebaseCloudMessaginglisteners(String userUID, bool isDisabled) async {
    await _firebaseMessaging.getToken().then((token) {
      if (token != null) {
        getUserID(userUID).then((userId) {
          saveToken(token, userId, isDisabled);
        });
      }
    });
  }

  Future<String> getUserID(String userUID) async {
    String userId = '';
    for (int i = 0; i < tanods.length; i++) {
      if (tanods[i]['TanodUID'] == userUID) {
        userId = tanods[i]['TanodId'];
      }
    }
    return userId;
  }

  Future<void> saveToken(String token, String userId, bool isDisabled) async {
    await dbRef.child('Tanods').child(userId).update({
      'Token': isDisabled ? '?' : token,
    });
  }

  void validation() async {
    String userUID;
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        setState(() {
          _authIsNotValid = false;
        });

        userUID = await widget.auth.signInWithEmailAndPassword(email, password);
        // ignore: unnecessary_null_comparison
        if (userUID != null) {
          bool isDisabled = checkAccountIsDisabled(userUID);
          if (isDisabled) {
            setState(() {
              firebaseCloudMessaginglisteners(userUID, isDisabled);
              authMessage = 'Account is disabled!';
              widget.auth.signOut();
              _authIsNotValid = true;
            });
          } else {
            firebaseCloudMessaginglisteners(userUID, isDisabled);
            widget.onSignIn!();
          }
        }
      } on FirebaseAuthException catch (e) {
        print(e.code);
        if (e.code == 'wrong-password') {
          setState(() {
            _authIsNotValid = true;

            authMessage = 'Password is incorrect!';
          });
        } else {
          setState(() {
            _authIsNotValid = true;
            authMessage = 'Email does not exist!';
          });
        }
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool checkAccountIsDisabled(String userUID) {
    bool isDisabled = false;
    for (int i = 0; i < tanods.length; i++) {
      if (tanods[i]['TanodUID'] == userUID) {
        if (tanods[i]['Status'] == 'Disabled') {
          isDisabled = true;
        }
      }
    }
    return isDisabled;
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(bottom: 30, top: 50),
      child: Text(
        "Welcome to Tanood App",
        style: tertiaryText.copyWith(
          fontSize: 16,
          letterSpacing: 1,
          color: Colors.white,
        ),
        maxLines: 2,
      ),
    );
  }

  Widget _buildContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(29),
          ),
          child: Container(
            width: screenSize.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 20,
                      top: 30,
                    ),
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(),
                    child: Image.asset(
                      'assets/images/app-logo.png',
                    ),
                  ),
                  Text(
                    "Sign in",
                    style: secandaryText.copyWith(fontSize: 25),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 10,
                    ),
                    child: Text(
                      'Get authenticated and apprehend violators!',
                      style: secandaryText.copyWith(fontSize: 12),
                    ),
                  ),
                  Container(
                    height: 20,
                  ),
                  _buildEmailRow(),
                  _buildPasswordRow(),
                  _buildAuthenticationMessage(),
                  _buildLoginButton(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailRow() {
    return Padding(
      padding: EdgeInsets.all(screenSize.height / 80),
      child: MyTextFormField(
        inputType: TextInputType.emailAddress,
        isObscureText: false,
        validation: (value) {
          if (value == '')
            return 'Please enter your email';
          else if (!RegExp(regEx).hasMatch(value!))
            return 'Invalid email format';

          return null;
        },
        onChanged: (value) {
          setState(() {
            email = value!;
          });
        },
        prefixIcon: Icon(
          Icons.email_outlined,
          color: customColor[130],
        ),
        labelText: "E-mail",
        hintText: "something@email.com",
        focusNode: myEmailNode,
      ),
    );
  }

  Widget _buildPasswordRow() {
    return Padding(
      padding: EdgeInsets.all(screenSize.height / 80),
      child: MyTextFormField(
        inputType: TextInputType.text,
        isObscureText: isobscureText,
        validation: (value) {
          if (value == "") return "Please enter your password";

          return null;
        },
        onChanged: (value) {
          setState(() {
            password = value!;
          });
        },
        prefixIcon: Icon(
          Icons.lock_outline,
          color: customColor[130],
        ),
        labelText: "Password",
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              isobscureText = !isobscureText;
            });
          },
          child: Icon(
            isobscureText ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
            color: myPasswordNode.hasFocus ? customColor[130] : Colors.grey,
          ),
        ),
        focusNode: myPasswordNode,
      ),
    );
  }

  Widget _buildAuthenticationMessage() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      height: screenSize.height * 0.03,
      child: _authIsNotValid == true
          ? Text(
              authMessage,
              style: tertiaryText.copyWith(
                fontSize: screenSize.height / 60,
                color: Colors.red,
              ),
            )
          : null,
    );
  }

  Widget _buildLoginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 1.4 * (screenSize.height / 20),
          width: 5 * (screenSize.width / 10),
          margin: EdgeInsets.only(bottom: 20),
          child: IgnorePointer(
            ignoring: _isLoading,
            child: MyRaisedButton(
              elavation: 5.0,
              color: Color(0xff1c52dd),
              radius: 30.0,
              onPressed: () {
                validation();
              },
              isLoading: _isLoading,
              text: Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.5,
                  fontSize: screenSize.height / 40,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildFooterMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 100),
          // ignore: deprecated_member_use
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Powered by: ",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: "TDP Corp.",
                  style: TextStyle(
                    color: customColor[130]!.withOpacity(.75),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xfff2f3f7),
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

              return ListView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 500,
                            width: screenSize.width,
                            child: Container(
                              decoration: BoxDecoration(
                                color: customColor[130],
                                borderRadius: BorderRadius.only(
                                  bottomLeft: const Radius.circular(70),
                                  bottomRight: const Radius.circular(70),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _buildHeader(),
                              _buildContainer(),
                            ],
                          ),
                        ],
                      ),
                      _buildFooterMessage(),
                    ],
                  ),
                ],
              );
            }),
      ),
    );
  }
}
