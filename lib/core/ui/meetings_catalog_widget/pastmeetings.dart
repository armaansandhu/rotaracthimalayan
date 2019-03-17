import 'package:flutter/material.dart';
import 'package:rotaract_app/core/ui/meeting_description_widget/meeting_description.dart';

class PastMeetings extends StatefulWidget {
  PastMeetings(this.data, this.id);
  final data;
  final id;

  @override
  _PastMeetingsState createState() => _PastMeetingsState();
}

class _PastMeetingsState extends State<PastMeetings> with AutomaticKeepAliveClientMixin<PastMeetings> {
  @override
  Widget build(BuildContext context) {
    print(widget.id);
    return Scaffold(
        body: widget.data == null ? Text('Empty',style: TextStyle(color: Colors.black),) : _buildUpcomingMeetingsList()
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildUpcomingMeetingsList() {
    return ListView.builder(
      itemCount: widget.data.length,
      itemBuilder: (BuildContext context, int i) => _upcomingMeetingTile(i),
    );
  }

  _upcomingMeetingTile(int i) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: InkWell(
          onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MeetingDescription(widget.data[i]['reference'], widget.id))),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                title: Row(
                  children: <Widget>[
                    Text(
                    '${widget.data[i].data['title']}',
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
                  '${widget.data[i].data['agenda']}',
                  maxLines: 2,
                  style: TextStyle(fontSize: 16.0),
                ),
              ))),
    );
  }
}

