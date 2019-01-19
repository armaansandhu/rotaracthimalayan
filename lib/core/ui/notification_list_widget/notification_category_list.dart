import 'package:flutter/material.dart';
import 'package:rotaract_app/core/constants/constants.dart';
import 'package:rotaract_app/core/ui/notification_list_widget/notification_checklist.dart';

class NotificationCategoryList extends StatelessWidget {

  NotificationCategoryList({this.id});
  final id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: Text('My Notifications'),
      ),
      body: ListView(
        children: <Widget>[
          _listTile(id, 'projects',context),
          _listTile(id, 'committees',context),
          _listTile(id, 'events',context)
        ],
      ),
    );
  }

   _listTile(String id, String event,BuildContext context){
    return ListTile(
      contentPadding: EdgeInsets.all(8.0),
          onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) => NotificationList(user: id, event: event,))),
          title: Text(event[0].toUpperCase() + event.substring(1))
      );
  }
}
