import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserNotifications extends StatefulWidget {
  UserNotifications(this.id);

  final id;

  @override
  _UserNotificationsState createState() => _UserNotificationsState();
}

class _UserNotificationsState extends State<UserNotifications> {
  Future<QuerySnapshot> getNotification() async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('users/${widget.id}/notifications')
        .getDocuments();
    return querySnapshot;
  }

  notificationList(List<DocumentSnapshot> docs) {
    return ListView(
      children: docs.map((doc) => notificationTile(doc)).toList(),
    );
  }

  Widget notificationTile(doc) {
    return Column(
      children: <Widget>[
        Container(
          color: doc.data['seen']
              ? Colors.white
              : Color.fromRGBO(210, 236, 250, 1),
          child: ListTile(
            contentPadding: EdgeInsets.all(12.0),
            title: Text(
              doc.data['title'],
              style: Theme.of(context).textTheme.title,
            ),
            subtitle: Text(doc.data['body']),
            trailing: Image.network(
                'https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png'),
            onTap: () => null,
          ),
        ),
        Divider(
          height: 0.0,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: FutureBuilder(
          future: getNotification(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              print(snapshot.data.documents);
              return notificationList(snapshot.data.documents);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
