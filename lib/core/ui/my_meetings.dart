import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rotaract_app/core/ui/meeting_description_widget/meeting_description.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rotaract_app/core/constants/constants.dart';

class MyMeetings extends StatelessWidget {
  MyMeetings(this.id,this.myMeetings);
  final String id;
  final myMeetings;
  Future<List<DocumentSnapshot>> getMyMeetings() async{
  List<DocumentSnapshot> meetingsDocuments = List();
    for(int i=0;i<myMeetings.length;i++){
      await myMeetings[i].get().then((snapshot){
        meetingsDocuments.add(snapshot);
      });
    }
    return meetingsDocuments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Meetings'),
        backgroundColor: themeColor,
      ),
      body: FutureBuilder(
        future: getMyMeetings(),
        builder: (BuildContext context,AsyncSnapshot<List<DocumentSnapshot>> snapshot){
          if(snapshot.connectionState == ConnectionState.done)
            return ListView(
              children: snapshot.data.map((meeting) => _meetingTile(context, meeting)).toList(),
            );
          else
            return _listPlaceholder(context);
        }),
    );
  }

  Widget _meetingTile(BuildContext context, DocumentSnapshot meeting) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: InkWell(
          onTap: () => null,
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MeetingDescription(meeting.reference, id))),
                child: ListTile(
                  title: Row(
                    children: <Widget>[
                      Text(
                        meeting.data['title'],
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Chip(
                        label: Text(
                          'Full Body',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.lightGreen,
                      )
                    ],
                  ),
                  isThreeLine: true,
                  contentPadding: EdgeInsets.all(16.0),
                  subtitle: Text(
                    meeting.data['agenda'],
                    maxLines: 2,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  trailing: Icon(Icons.navigate_next),
                ),
              ))),
    );
  }

  _listPlaceholder(BuildContext context){
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
