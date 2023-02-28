import 'package:chat_app/services/database_services.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'group_info.dart';

class ChatPage extends StatefulWidget {
  String groupId, GroupName, userName, uid;

  ChatPage(
      {Key? key,
      required this.groupId,
      required this.GroupName,
      required this.userName,
      required this.uid})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  Stream<QuerySnapshot>? participants;
  String admin = "";

  @override
  void initState() {
    // TODO: implement initState
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    DatabaseService(uid: widget.uid).getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseService(uid: widget.uid).getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.GroupName),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(
                    context,
                    GroupInfo(
                      GroupID: widget.groupId,
                      GroupName: widget.GroupName,
                      AdminName: admin,
                    ));
              },
              icon: Icon(Icons.info)),
        ],
      ),
      body: Center(child: Text("CHat Page")),
    );
  }
}
