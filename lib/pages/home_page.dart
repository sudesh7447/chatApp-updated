// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/profile_page.dart';
import 'package:chat_app/pages/search_page.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/database_services.dart';
import 'package:chat_app/widgets/group_tile.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  String email = "";
  AuthServices authServices = AuthServices();
  Stream? groups;
  bool _isLoading = false;
  String GroupName = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }

  getId(String res)
  {
    return res.substring(0 ,res.indexOf("_"));
  }
  getName(String res)
  {
    return res.substring(res.indexOf("_")+1);
  }

  gettingUserData() async {
    await HelperFunctions.GetUserNameSF().then((val) {
      setState(() {
        // print(val);
        userName = val!;
      });
    });
    await HelperFunctions.GetUserEmailSF().then((value) {
      setState(() {
        // print(value);
        email = value!;
      });
    });
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshots) {
      setState(() {
        groups = snapshots;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, SearchPage());
              },
              icon: Icon(Icons.search))
        ],
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text("Groups",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 27,
                color: Colors.white)),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50),
          children: [
            Icon(
              Icons.account_circle,
              color: Colors.black,
              size: 150,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              userName,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 30,
            ),
            Divider(
              height: 2,
            ),
            ListTile(
              onTap: () {},
              selected: true,
              selectedColor: Theme.of(context).primaryColor,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.group),
              title: Text(
                "Groups",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
                nextScreenReplace(
                    context,
                    ProfilePage(
                      userName: userName,
                      userEmail: email,
                    ));
              },
              selected: false,
              selectedColor: Theme.of(context).primaryColor,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.account_circle),
              title: Text(
                "Profile",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("LogOut"),
                        content: Text("Are You Sure to logout?"),
                        actions: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.red,
                              )),
                          IconButton(
                              onPressed: () async {
                                await authServices.SignOut().whenComplete(() {
                                  nextScreenReplace(context, LoginPage());
                                });
                              },
                              icon: Icon(
                                Icons.done,
                                color: Colors.green,
                              )),
                        ],
                      );
                    });
              },
              selected: false,
              selectedColor: Theme.of(context).primaryColor,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.logout),
              title: Text(
                "LogOut",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog();
        },
        elevation: 0,
        child: (Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        )),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  popUpDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context , setState){
            return AlertDialog(
              title: Text(
                "Create Group",
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true
                      ? CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        )
                      : TextField(
                          onChanged: (val) {
                            setState(() {
                              GroupName = val;
                            });
                          },
                    style: TextStyle(color: Colors.black),

                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(20)),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(20)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                  borderRadius: BorderRadius.circular(20))),
                        ),

                ],
              ),
              actions: [
                ElevatedButton(onPressed: (){Navigator.of(context).pop();},style: ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor), child: Text("Cancel")),
                ElevatedButton(onPressed: ()async{
                  if(GroupName!="")
                    {
                      setState(() {
                        _isLoading = true;

                      });
                      DatabaseService(uid:  FirebaseAuth.instance.currentUser!.uid).AddGroup(userName, FirebaseAuth.instance.currentUser!.uid, GroupName).whenComplete((){_isLoading=false;});
                      Navigator.of(context).pop();
                      showSnackbar(context, Colors.green  , "Group Created Successfully");
                    }
                },style: ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor), child: Text("Create"))
              ],
            );}
          );
        });
  }

  groupList() {
    return StreamBuilder(
        stream: groups,
        builder: (context, AsyncSnapshot snapshots) {
          if (snapshots.hasData) {
            if (snapshots.data['groups'] != null) {
              if (snapshots.data['groups'].length != 0) {
                return ListView.builder(itemCount:snapshots.data['groups'].length , itemBuilder: (context ,index){
                  int reverseIndex = (snapshots.data['groups'].length - 1 - index);
                  return GroupTile(userName: snapshots.data['FullName'], groupId: getId(snapshots.data['groups'][reverseIndex]), groupName: getName(snapshots.data['groups'][reverseIndex]), uid:  FirebaseAuth.instance.currentUser!.uid,);
                });
              } else {
                return noGroupWidget();
              }
            } else {
              return noGroupWidget();
            }
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }
        });
  }

  noGroupWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.add_circle,
            size: 70,
            color: Colors.grey,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "You have not joined any group yet , click here to create one or search for one from top search button",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
