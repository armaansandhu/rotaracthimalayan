import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rotaract_app/core/constants/constants.dart';
import 'package:rotaract_app/core/ui/meeting_description_widget/meeting_description.dart';

class ToString {
  final dateFormatter = new DateFormat('EEEE, d MMMM');
  final timeFormatter = new DateFormat('jm');
  String dateString;
  String timeString;

  ToString(input) {
    dateString = dateFormatter.format(input);
    timeString = timeFormatter.format(input);
  }

  String get date => dateString;
  String get time => timeString;
}

class MeetingIndex extends StatelessWidget {
  MeetingIndex(this.id);
  final id;
  Future<List<DocumentSnapshot>> getNewMeetings()async{
    var newMeetings;
    await Firestore.instance.collection('meetings')
        .where('period',isEqualTo: 'upcoming')
        .orderBy('dateTime',descending: true)
        .getDocuments().then((snapshot){
          newMeetings = snapshot.documents;
    });
    return newMeetings;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meetings'),
        backgroundColor: themeColor,
      ),
      body: FutureBuilder(
        future: getNewMeetings(),
        builder: (BuildContext context,AsyncSnapshot<List<DocumentSnapshot>> snapshot){
          if(snapshot.connectionState == ConnectionState.done)
            return ListView(
              children: snapshot.data.map((doc){
                return meetingTile(context, doc);
              }).toList(),
            );
          else
            return listPlaceholder(context);
        },
      ),
    );
  }

  Widget meetingTile(BuildContext context, DocumentSnapshot meeting) {
    print(id);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: InkWell(
          onTap: () => null,
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MeetingDescription(meeting.data['reference'], id))),
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          meeting.data['category'],
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.primaries[meeting.data['category'].length],
                      )
                    ],
                  ),
                  isThreeLine: true,
                  contentPadding: EdgeInsets.all(16.0),
                  subtitle: Text(
                    ToString(meeting.data['dateTime']).date,
                    maxLines: 2,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  trailing: Icon(Icons.navigate_next),
                ),
              ))),
    );
  }
}
