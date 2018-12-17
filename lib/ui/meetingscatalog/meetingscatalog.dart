import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';

import 'package:rotaract_app/ui/meetingscatalog/pastmeetings.dart';
import 'package:rotaract_app/ui/meetingscatalog/upcomingmeetings.dart';
import 'package:rotaract_app/utils/authprovider.dart';


class MeetingCatalog extends StatefulWidget {
  MeetingCatalog(this.id);
  final id;

  @override
  _MeetingCatalogState createState() => _MeetingCatalogState();
}

class _MeetingCatalogState extends State<MeetingCatalog> {
  final firestore = Firestore.instance;
  AsyncMemoizer memoizer = AsyncMemoizer();
  var _pastMeetings;
  var _upcomingMeetings;
  var id;

  _getAllMeetingList() async{
    id = await AuthProvider.of(context).auth.currentUser();
    print(id);
      await firestore.collection('/meetings/committees/${widget.id}').where('date', isEqualTo: 'upcoming')
          .getDocuments().then((snapshot){
        _upcomingMeetings = snapshot.documents;
          });
      await firestore.collection('/meetings/committees/${widget.id}').where('date', isEqualTo: 'past')
          .getDocuments().then((snapshot){
        _pastMeetings = snapshot.documents;
      });
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: "Upcoming",),
              Tab(text: "Past",),
            ],
          ),
          title: Text('Meetings'),
        ),
        body: FutureBuilder(
          future: _getAllMeetingList(),
          builder: (BuildContext context,AsyncSnapshot snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              return TabBarView(
                children: [
                  UpcomingMeetings(_upcomingMeetings, id),
                  PastMeetings(_pastMeetings, id)
                ],
              );
            } else{
              return Center(child: CircularProgressIndicator(),);
            }
          },
        ),
      ),
    );
  }
}
