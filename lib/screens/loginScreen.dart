import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tanod_apprehension/net/authenticationService.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/myButtons.dart';
import 'package:tanod_apprehension/shared/myTextFormFields.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onSignIn;
  final BaseAuth auth;
  const LoginScreen({required this.auth, this.onSignIn});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

late Size screenSize;
String email = "", password = "";
bool isobscureText = true, _isLoading = false, _authIsNotValid = false;
String authMessage = '';
String regEx =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class _LoginScreenState extends State<LoginScreen> {
  void validation() async {
    String userId;
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        setState(() {
          _authIsNotValid = false;
        });

        userId = await widget.auth.signInWithEmailAndPassword(email, password);
        // ignore: unnecessary_null_comparison
        if (userId != null) {
          widget.onSignIn!();
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

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: screenSize.height / 30),
          child: Text(
            "Facemask Apprehension",
            style: secandaryText.copyWith(
              fontSize: screenSize.height / 35,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: Colors.white,
            ),
          ),
        ),
      ],
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
            height: screenSize.height * 0.6,
            width: screenSize.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Login",
                        style: secandaryText.copyWith(
                            fontSize: screenSize.height / 30),
                      ),
                    ],
                  ),
                  _buildEmailRow(),
                  _buildPasswordRow(),
                  _buildAuthenticationMessage(),
                  _buildForgetPasswordButton(),
                  _buildLoginButton()
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
        prefixIcon: GestureDetector(
          onTap: () {},
          child: Icon(
            Icons.email_outlined,
            color: customColor,
          ),
        ),
        labelText: "E-mail",
        hintText: "vince@email.com",
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
        prefixIcon: GestureDetector(
          onTap: () {
            setState(() {
              isobscureText = !isobscureText;
            });
          },
          child: Icon(
            isobscureText == true ? Icons.lock_outline : Icons.lock_open,
            color: customColor,
          ),
        ),
        labelText: "Password",
      ),
    );
  }

  Widget _buildAuthenticationMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
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
        ),
      ],
    );
  }

  Widget _buildForgetPasswordButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ignore: deprecated_member_use
        FlatButton(
          onPressed: () {
            // ignore: deprecated_member_use
            _scaffoldKey.currentState!.showSnackBar(
              SnackBar(
                content: Text(
                  'Contact Administrator: abc@gmail.com',
                ),
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: Text("Forgot Password"),
        ),
      ],
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
              color: customColor,
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

  Widget _buildSignUpButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 40),
          // ignore: deprecated_member_use
          child: FlatButton(
            onPressed: () {
              // ignore: deprecated_member_use
              _scaffoldKey.currentState!.showSnackBar(
                SnackBar(
                  content: Text(
                    'Contact Administrator: abc@gmail.com',
                  ),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Dont have an account? ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenSize.height / 40,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: "Sign up",
                    style: TextStyle(
                      color: customColor,
                      fontSize: screenSize.height / 40,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff2f3f7),
      body: Stack(
        children: [
          Container(
            height: screenSize.height * .7,
            width: screenSize.width,
            child: Container(
              decoration: BoxDecoration(
                color: customColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: const Radius.circular(70),
                  bottomRight: const Radius.circular(70),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLogo(),
              _buildContainer(),
              _buildSignUpButton(),
            ],
          )
        ],
      ),
    );
  }
}
