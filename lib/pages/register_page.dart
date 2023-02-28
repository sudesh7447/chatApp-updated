import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../shared/constants.dart';
import '../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formkey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String FullName = "";
  AuthServices authService = AuthServices();
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(
          body: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
                backgroundColor: Colors.white,
              ),
            ),
        )
        : Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                child: Form(
                  key: formkey,
                  child: Column(
                    children: [
                      Text(
                        "Groupie",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Create your Account now to chat and explore!",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      Image.asset("assets/register.png"),
                      TextFormField(
                        decoration: textInputDecorations.copyWith(
                            labelText: "Full Name",
                            labelStyle:
                                TextStyle(color: Constants().primaryColor),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Constants().primaryColor,
                            )),
                        // check tha validation
                        validator: (val) {
                          if (val!.isNotEmpty) {
                            return null;
                          }
                          return "Name field can't be empty";
                        },
                        onChanged: (val) {
                          setState(() {
                            FullName = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: textInputDecorations.copyWith(
                            labelText: "Email",
                            labelStyle:
                                TextStyle(color: Constants().primaryColor),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Constants().primaryColor,
                            )),
                        // check tha validation
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val!)
                              ? null
                              : "Please enter a valid email";
                        },
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: textInputDecorations.copyWith(
                            labelText: "Password",
                            labelStyle:
                                TextStyle(color: Constants().primaryColor),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Constants().primaryColor,
                            )),
                        validator: (val) {
                          if (val!.length < 6) {
                            return "Password must be at least 6 characters";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          onPressed: () {
                            register();
                          },
                          child: Text(
                            "Submit",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text.rich(TextSpan(
                          text: "Already have an Account?",
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          children: [
                            TextSpan(
                                text: "Login Here!",
                                style: TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(context, LoginPage());
                                  }),
                          ]))
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  register() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserwithEmailandPassword(FullName, email, password)
          .then((value) async {
        if (value == true) {
          //saving the shared preference state
          await HelperFunctions.SaveUSerLoggedInStatus(true);
          await HelperFunctions.SaveUserNameSF(FullName);
          await HelperFunctions.SaveUserEmailSF(email);
          nextScreenReplace(context, HomePage());
        } else {

          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });

        }
      });
    }
  }
}
