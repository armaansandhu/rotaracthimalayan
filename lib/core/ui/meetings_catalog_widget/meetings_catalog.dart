import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:rotaract_app/core/constants/constants.dart';
import 'package:rotaract_app/core/ui/meetings_catalog_widget/pastmeetings.dart';
import 'package:rotaract_app/core/ui/meetings_catalog_widget/upcomingmeetings.dart';

class MeetingCatalog extends StatefulWidget {
  MeetingCatalog(this.category, this.id);

  final category;
  final id;

  @override
  _MeetingCatalogState createState() => _MeetingCatalogState();
}

class _MeetingCatalogState extends State<MeetingCatalog> {
  final firestore = Firestore.instance;
  final AsyncMemoizer memoizer = AsyncMemoizer();
  var _pastMeetings;
  var _upcomingMeetings;

  _getAllMeetingList() async {
    await firestore
        .collection('/meetings')
        .where('category', isEqualTo: widget.category)
        .where('period', isEqualTo: 'upcoming')
        .getDocuments()
        .then((data) {
      if (data == null)
        _upcomingMeetings = null;
      else
        _upcomingMeetings = data.documents;
    });
    await firestore
        .collection('/meetings')
        .where('category', isEqualTo: widget.category)
        .where('period', isEqualTo: 'past')
        .getDocuments()
        .then((data) {
      if (data == null)
        _pastMeetings = null;
      else
        _pastMeetings = data.documents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: themeColor,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: "Upcoming",
              ),
              Tab(
                text: "Past",
              ),
            ],
          ),
          title: Text('Meetings'),
        ),
        body: FutureBuilder(
          future: _getAllMeetingList(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return TabBarView(
                children: [
                  UpcomingMeetings(_upcomingMeetings, widget.id),
                  PastMeetings(_pastMeetings, widget.id)
                ],
              );
            } else {
              return listPlaceholder(context);
            }
          },
        ),
      ),
    );
  }
}
