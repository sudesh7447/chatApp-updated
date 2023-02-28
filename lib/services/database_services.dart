import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  // save user data
  Future saveUserData(String FullName, String Email) async {
    return await userCollection.doc(uid).set({
      "FullName": FullName,
      "email": Email,
      "groups": [],
      "profilepic": "",
      "uid": uid
    });
  }

  // get user data

  Future getUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // get user groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  // creating a group
  Future AddGroup(String UserName, String id, String GroupName) async {
    DocumentReference GroupDocumentReference = await groupCollection.add({
      "groupName": GroupName,
      "groupIcon": "",
      "admin": "${id}_$UserName",
      "members": [],
      "groupId": "",
      "recentMsg": "",
      "recentMsgSender": "",
      "recentMsgTime": ""
    });
    await GroupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$UserName"]),
      "groupId": GroupDocumentReference.id
    });

    DocumentReference UserDocumentReference = userCollection.doc(uid);
    return await UserDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${GroupDocumentReference.id}_$GroupName"]),
    });
  }

  // getting the chatscollectionPath
  getChats(String groupID) async {
    return groupCollection
        .doc(groupID)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  // get group Admin

  Future getGroupAdmin(String GroupId) async {
    DocumentReference documentReference = groupCollection.doc(GroupId);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    return documentSnapshot['admin'];
  }

  getGroupMembers(String GroupID) async {
    return groupCollection.doc(GroupID).snapshots();
  }
}
