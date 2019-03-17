import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rotaract_app/core/constants/constants.dart';
import 'package:rotaract_app/core/ui/meeting_management/edit_meeting.dart';

class ViewScheduledMeetings extends StatefulWidget {
  ViewScheduledMeetings(this.id);
  final id;
  @override
  _ViewScheduledMeetingsState createState() => _ViewScheduledMeetingsState();
}

class _ViewScheduledMeetingsState extends State<ViewScheduledMeetings> {
  final firestore = Firestore.instance;

  getMeetings() async{
    QuerySnapshot s = await firestore.collection('meetings').where('appointedById',isEqualTo: widget.id).getDocuments();
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Scheduled Meetings'),
          backgroundColor: themeColor,
          elevation: 0.0,
        ),
        body: FutureBuilder(
            future: getMeetings(),
            builder: (BuildContext context,AsyncSnapshot snapshot){
          if(snapshot.hasData)
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int i) => _upcomingMeetingTile(i,snapshot.data.documents),
            );
          else
            return listPlaceholder(context);
        }),
      ),
    );
  }

  _upcomingMeetingTile(int i, List<DocumentSnapshot> data) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: InkWell(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                child: ListTile(
                  title: Row(
                    children: <Widget>[
                      Text(
                        '${data[i].data['title']}',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Chip(
                        label: Text(
                          data[i].data['type'],
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.lightGreen,
                      )
                    ],
                  ),
                  isThreeLine: true,
                  contentPadding: EdgeInsets.all(16.0),
                  subtitle: Text(
                    data[i].data['agenda'],
                    maxLines: 2,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => getRoute(context,EditMeeting(data[i],widget.id),fullscreen: true)),
                ),
              ))),
    );
  }
}
