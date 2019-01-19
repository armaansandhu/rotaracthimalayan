import 'package:flutter/material.dart';
import 'going.dart';

class AttendingList extends StatelessWidget {

  AttendingList(this.userDocuments);
  final userDocuments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Attendees (${userDocuments.length})'),centerTitle: true,backgroundColor: Colors.red,),
      body: Going(userDocuments),
    );
  }
}