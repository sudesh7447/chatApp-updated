import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../pages/Chat_page.dart';

class GroupTile extends StatefulWidget {
  String userName;
  String groupId;
  String groupName;
  String uid;
   GroupTile({Key? key , required this.userName ,required this.uid , required this.groupId , required this.groupName}) : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()
      {
        nextScreen(context, ChatPage(groupId: widget.groupId, GroupName: widget.groupName, userName: widget.userName, uid: widget.uid,));
      },
      child: Container(
      padding: EdgeInsets.symmetric(vertical: 10 , horizontal: 5)
      ,

        child: ListTile(
         leading: CircleAvatar(
           backgroundColor: Theme.of(context).primaryColor,
           radius: 30,
           child: Text(widget.groupName.substring(0,1).toUpperCase() , textAlign: TextAlign.center,style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),),

         ),
          title: Text(widget.groupName , style:  TextStyle(fontWeight: FontWeight.bold),),
          subtitle: Text("Join the conversion as chutya"),
        ),



      ),
    );
  }
}
