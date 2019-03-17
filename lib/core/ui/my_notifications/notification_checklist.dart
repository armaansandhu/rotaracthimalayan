import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rotaract_app/core/ui/notification_list_widget/checkbox_reactive_tile.dart';
import 'package:rotaract_app/core/blocs/notificationbloc.dart';

class NotificationList extends StatefulWidget {
  NotificationList({this.user, this.event});
  final String user;
  final String event;

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  List<DocumentSnapshot> tmp = List();

  sortList(List<DocumentSnapshot> docs, List<String> subscription){
    docs.forEach((doc){
      if(subscription.contains(doc['id']) == true)
        tmp.add(doc);
    });
    docs.forEach((doc){
      if(subscription.contains(doc['id']) == false)
        tmp.add(doc);
    });
  }
  List<String> subscription;
  getSubsciption()async{
    var docs;
    await Firestore.instance.collection(widget.event).getDocuments().then((snap){
      docs = snap.documents;
      print(docs[0].data);
    });
    await Firestore.instance.document('users/${widget.user}').get().then((snap){
      subscription = List.from(snap.data['subscription']);
    });
    sortList(docs,subscription);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.toUpperCase()),
        elevation: 0.0,
        backgroundColor: Colors.primaries[widget.event.length],
      ),
        body: FutureBuilder(
          future: getSubsciption(),
          builder: (BuildContext context,AsyncSnapshot snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              print(subscription);
              return ListView(
                children: tmp.map((doc) => EventCheckBoxTile(doc: doc,subscription: subscription,id : widget.user)).toList(),
              );
            }
            else
              return Center(child: CircularProgressIndicator(),);
          },
        )
    );
  }

}
