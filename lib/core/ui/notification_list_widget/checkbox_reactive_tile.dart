import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventCheckBoxTile extends StatefulWidget {

  EventCheckBoxTile({this.name, this.value, this.reference});
  final String name;
  bool value;
  DocumentReference reference;
  @override
  _EventCheckBoxTileState createState() => _EventCheckBoxTileState();
}

class _EventCheckBoxTileState extends State<EventCheckBoxTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.name),
      trailing: Checkbox(value: widget.value, onChanged: (_) => changeValue(),),
    );
  }

  changeValue() async{
    setState(() {
      widget.value = !widget.value;
    });
    widget.value == true ? FirebaseMessaging().subscribeToTopic(widget.name.toLowerCase().replaceAll(' ', '_')) : FirebaseMessaging().unsubscribeFromTopic(widget.name.toLowerCase().replaceAll(' ', '_'));
    await widget.reference.updateData({'checked': widget.value});
  }
}

