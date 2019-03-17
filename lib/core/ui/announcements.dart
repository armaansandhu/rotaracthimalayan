import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rotaract_app/core/constants/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class Announcements extends StatefulWidget {
  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  Future<List<DocumentSnapshot>> getAnnouncements() async {
    var announcements =
        await Firestore.instance.collection('announcements').getDocuments();
    print(announcements.documents[0].data['link']);
    return announcements.documents;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcements'),
        backgroundColor: themeColor,
      ),
      body: FutureBuilder(
          future: getAnnouncements(),
          builder: (BuildContext context,
              AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done)
              return ListView(
                children: snapshot.data
                    .map((announcement) => ListTile(
                          title: Text(announcement.data['title']),
                          subtitle: Text(announcement.data['description']),
                          onTap: () async {
                            if (await canLaunch(announcement.data['link'][0])) {
                              await launch(announcement.data['link'][0]);
                            }
                          },
                        ))
                    .toList(),
              );
            else
              return listPlaceholder(context);
          }),
    );
  }
}
