import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tanod_apprehension/net/authenticationService.dart';
import 'package:tanod_apprehension/shared/constants.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onSignIn;
  final BaseAuth auth;
  const LoginScreen({required this.auth, required this.onSignIn});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

String email = "", password = "";
bool isobscureText = true;
String regEx =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _LoginScreenState extends State<LoginScreen> {
  late Size screenSize;

  void validation() async {
    String userId;
    if (_formKey.currentState!.validate()) {
      setState(() {
        //   _isLoading = true;
      });
      try {
        setState(() {
          //   authIsNotValid = false;
        });
        userId = await widget.auth.signInWithEmailAndPassword(email, password);
        // ignore: unnecessary_null_comparison
        if (userId != null) {
          widget.onSignIn();
        }
        //widget.onSignIn();
      } on FirebaseAuthException catch (e) {
        print(e.code);
        if (e.code == 'wrong-password') {
          setState(() {
            //   errorOnLogIn = 'Password is incorrect!';
            //   authIsNotValid = true;
          });
        } else {
          setState(() {
            //   errorOnLogIn = 'Email does not exist!';
            //   authIsNotValid = true;
          });
        }
      }
      setState(() {
        //  _isLoading = false;
      });
    }
  }

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 70),
          child: Text(
            "Give me Logo sir",
            style: TextStyle(
                fontSize: screenSize.height / 25,
                fontWeight: FontWeight.bold,
                color: Colors.white),
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
                        style: TextStyle(fontSize: screenSize.height / 30),
                      ),
                    ],
                  ),
                  _buildEmailRow(),
                  _buildPasswordRow(),
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
      padding: EdgeInsets.all(8),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == '')
            return 'Please Fill Email';
          else if (!RegExp(regEx).hasMatch(value!)) return 'Invalid Email';

          return null;
        },
        onChanged: (value) {
          setState(() {
            email = value;
          });
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.email_outlined,
            color: customColor,
          ),
          labelText: "E-mail",
        ),
      ),
    );
  }

  Widget _buildPasswordRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        keyboardType: TextInputType.text,
        obscureText: isobscureText,
        validator: (value) {
          if (value == "") return "Please fill the password";

          return null;
        },
        onChanged: (value) {
          setState(() {
            password = value;
          });
        },
        decoration: InputDecoration(
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
      ),
    );
  }

  Widget _buildForgetPasswordButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FlatButton(
          onPressed: () {},
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
          child: RaisedButton(
            elevation: 5.0,
            color: customColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            onPressed: () {
              validation();
            },
            child: Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: screenSize.height / 40,
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
          child: FlatButton(
            onPressed: () {},
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
