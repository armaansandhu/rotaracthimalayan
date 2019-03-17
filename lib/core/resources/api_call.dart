import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rotaract_app/core/models/meeting.dart';
import 'package:rotaract_app/core/models/userInfo.dart';
import 'package:rotaract_app/core/utils/authprovider.dart';

class ApiCall {
  //Retrieve user information for 'Profile'
  Future<BasicUser> getUserInfo(BuildContext context) async {
    BasicUser user;
    var userId = await AuthProvider.of(context).auth.currentUser();
    await Firestore.instance
        .collection('users')
        .document(userId)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        user = BasicUser.fromJson(snapshot.data);
      }
    });
    return user;
  }

  //Retrieve Notification Items of User for 'NotificationCheckList'
  Future<List<DocumentSnapshot>> getDocuments(String user, String event) async {
    List<DocumentSnapshot> docs;
    await Firestore.instance
        .collection('/users/$user/$event')
        .getDocuments()
        .then((snapshot) {
      docs = snapshot.documents;
    });
    return docs;
  }

  //Retrieve Meeting Data for 'MeetingDescription'
  getMeetingData(String reference) async {
    var snapshot = await Firestore.instance.document(reference).get();
    Meeting meeting = Meeting.fromJson(snapshot.data);
    return meeting;
  }

  //Fetch all user in MeetingDescription going list.
  Future<List<String>> getGoingUser(DocumentReference reference) async {
    var snapshot = await reference.get();
    var goingListDocument = snapshot.data['going'];
    List<String> goingListDp = List();
    for (int i = 0; i < goingListDocument.length; i++) {
      await Firestore.instance
          .document(goingListDocument[i])
          .get()
          .then((snapshot) {
        goingListDp.add(snapshot.data['dp']);
      });
    }
    return goingListDp;
  }
}
