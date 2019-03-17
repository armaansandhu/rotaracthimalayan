import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventCheckBoxTile extends StatefulWidget {

  EventCheckBoxTile({this.doc, this.subscription, this.id,});
  final doc;
  final id;
  final subscription;
  DocumentReference reference;
  @override
  _EventCheckBoxTileState createState() => _EventCheckBoxTileState();
}

class _EventCheckBoxTileState extends State<EventCheckBoxTile> {
  bool value;
  List<String> subscription;
  @override
  void initState() {
    subscription = List.from(widget.subscription);
    value = widget.subscription.contains(widget.doc['id']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return ListTile(
      title: Text(widget.doc['name']),
      trailing: Checkbox(value: value, onChanged: (_) => changeValue(),),
    );
  }

  changeValue() async{
    setState(() {
      value = !value;
    });
    await Firestore.instance.document('users/${widget.id}').get().then((snap){
      subscription = List.from(snap.data['subscription']);
    });
    if(value == false)
      subscription.remove(widget.doc['id']);
    else if(value = true){
      subscription.add(widget.doc['id']);
    }
    value == true ? FirebaseMessaging().subscribeToTopic(widget.doc['id'].toLowerCase().replaceAll(' ', '_')) : FirebaseMessaging().unsubscribeFromTopic(widget.doc['id'].toLowerCase().replaceAll(' ', '_'));
    await Firestore.instance.document('users/${widget.id}').updateData({
      'subscription' : subscription
    });
  }
}

