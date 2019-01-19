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

  sortList(List<DocumentSnapshot> docs){
    docs.forEach((checkedDoc){
      if(checkedDoc['checked'] == true)
        tmp.add(checkedDoc);
    });
    docs.forEach((notCheckedDoc){
      if(notCheckedDoc['checked'] == false)
        tmp.add(notCheckedDoc);
    });
  }

  @override
  void initState() {
    notificationBloc.fetchNotificationDocuments(widget.user,widget.event);
    super.initState();
  }

  @override
  void dispose() {
    notificationBloc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.toUpperCase()),
        elevation: 0.0,
        backgroundColor: Colors.primaries[widget.event.length],
      ),
        body: StreamBuilder(
          stream: notificationBloc.notificationDocumentStream,
          builder: (BuildContext context,AsyncSnapshot snapshot){
            if(snapshot.hasData){
              sortList(snapshot.data);
              return ListView(
                children: tmp.map((doc) => EventCheckBoxTile(name: doc['name'],value: doc['checked'],reference: doc.reference)).toList(),
              );
            }
            else
              return Center(child: CircularProgressIndicator(),);
          },
        )
    );
  }

}
