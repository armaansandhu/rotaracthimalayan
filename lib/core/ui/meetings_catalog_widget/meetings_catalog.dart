import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:rotaract_app/core/constants/constants.dart';
import 'package:rotaract_app/core/ui/meetings_catalog_widget/pastmeetings.dart';
import 'package:rotaract_app/core/ui/meetings_catalog_widget/upcomingmeetings.dart';
import 'package:rotaract_app/core/utils/authprovider.dart';
import 'package:shimmer/shimmer.dart';


class MeetingCatalog extends StatefulWidget {
  MeetingCatalog(this.id);
  final id;

  @override
  _MeetingCatalogState createState() => _MeetingCatalogState();
}

class _MeetingCatalogState extends State<MeetingCatalog> {
  final firestore = Firestore.instance;
  final AsyncMemoizer memoizer = AsyncMemoizer();
  var _pastMeetings;
  var _upcomingMeetings;
  var id;

  _getAllMeetingList() {
    return memoizer.runOnce(() async{
      id = await AuthProvider.of(context).auth.currentUser();
      await firestore.collection('/meetings/committees/${widget.id}').where('date', isEqualTo: 'upcoming')
          .getDocuments().then((snapshot){
        _upcomingMeetings = snapshot.documents;
      });
      await firestore.collection('/meetings/committees/${widget.id}').where('date', isEqualTo: 'past')
          .getDocuments().then((snapshot){
        _pastMeetings = snapshot.documents;
      });
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
              return _listPlaceholder();
            }
          },
        ),
      ),
    );
  }

  _listPlaceholder(){
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Column(
        children: [0, 1, 2, 3]
            .map((_) =>
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      height: 20.0,
                      width: MediaQuery.of(context).size.width*.4,
                      decoration: new BoxDecoration(
                          color: Colors.green,
                          borderRadius: new BorderRadius.all(Radius.circular(30.0))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:8.0),
                    child: Container(
                      height: 20.0,
                      width: MediaQuery.of(context).size.width*.7,
                      decoration: new BoxDecoration(
                          color: Colors.green,
                          borderRadius: new BorderRadius.all(Radius.circular(30.0))),
                    ),
                  ),
                ],
              ),
            )
        ).toList(),
      ),
    );
  }
}
