// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../helper/helper_function.dart';
import '../shared/constants.dart';
import '../widgets/widgets.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  AuthServices authServices = AuthServices();
  final formkey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return _isLoading ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),) : Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                Text(
                  "Groupie",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Login now to see what they are talking!",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                Image.asset("assets/login.png"),
                TextFormField(
                  decoration: textInputDecorations.copyWith(
                      labelText: "Email",
                      labelStyle: TextStyle(color: Constants().primaryColor),
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
                      labelStyle: TextStyle(color: Constants().primaryColor),
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
                    onPressed: () {login();},
                    child: Text("Submit",style: TextStyle(fontSize: 16),),
                  ),
                )
                ,
                SizedBox(height: 15,),
                Text.rich(
                  TextSpan(
                    text: "Don't have an Account?",
                    style: TextStyle(color: Colors.black , fontSize: 14 ),
                    children: [
                      TextSpan(text: "Register Here!",                      style: TextStyle(color: Colors.black , decoration: TextDecoration.underline ),
                          recognizer: TapGestureRecognizer()..onTap= () {nextScreen(context, RegisterPage());}  ),

                    ]
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  login() async{
    if (formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authServices
          .LoginUserwithEmailandPassword( email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
          await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
              .getUserData(email);
          // saving values to out sf
          await HelperFunctions.SaveUSerLoggedInStatus(true);
          await HelperFunctions.SaveUserNameSF(snapshot.docs[0]["FullName"]);
          await HelperFunctions.SaveUserEmailSF(snapshot.docs[0]["email"]);
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
