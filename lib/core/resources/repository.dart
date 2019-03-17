import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rotaract_app/core/models/userInfo.dart';
import 'api_call.dart';

class Repository {
  final apiCall = ApiCall();

  Future<BasicUser> fetchUserInfo(BuildContext context) =>
      apiCall.getUserInfo(context);

  fetchNotificationDocuments(String user, String event) =>
      apiCall.getDocuments(user, event);

  fetchMeetingData(String reference) => apiCall.getMeetingData(reference);

  Future<List<String>> fetchGoingList(DocumentReference reference) =>
      apiCall.getGoingUser(reference);
}
