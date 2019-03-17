import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rotaract_app/core/constants/constants.dart';
import 'package:rotaract_app/core/models/meeting.dart';
import 'package:rotaract_app/core/blocs/goinglist_bloc.dart';
import 'package:rotaract_app/core/ui/meeting_description_widget/confirmation_button.dart';
import 'package:rotaract_app/core/ui/meeting_description_widget/descriptiontext.dart';
import 'package:rotaract_app/core/ui/meeting_description_widget/going_user_list_widget.dart';

class MeetingDescription extends StatefulWidget {
  MeetingDescription(this.meetingReference, this.id);
  final String meetingReference;
  final id;
  @override
  _MeetingDescriptionState createState() => _MeetingDescriptionState();
}

class _MeetingDescriptionState extends State<MeetingDescription> {
  final Firestore firestore = Firestore.instance;
  Meeting meeting;
  String id;

  Size screenSize(BuildContext context) =>
      MediaQuery
          .of(context)
          .size;

  _updateGoingList() {
    return StreamBuilder(
        stream: meetingBloc.notificationDocumentStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            meeting = snapshot.data;
            return Scaffold(
                appBar: _appBar(),
                backgroundColor: Colors.white,
                body: _buildContent()
            );
          }
          else
            return Scaffold(body: Center(child: CircularProgressIndicator(),),);
        }
    );
  }

  @override
  void initState() {
    meetingBloc.fetchNotificationDocuments(widget.meetingReference);
    print(widget.id);
    id = widget.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _updateGoingList();
  }

  Widget _buildContent() {
    return ListView(
      children: <Widget>[
        _title(),
        _descriptionText(),
        Divider(height: 0,),
        _dateAndPlace(),
        ConfirmationButton(meeting, id),
        Divider(height: 0.0,),
        GoingUserList(meeting)
      ],
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Text("${meeting.category} Meeting"),
      backgroundColor: themeColor,
    );
  }

  Widget _title() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Center(
        child: InkWell(
          child: Text(
            meeting.title,
            style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _descriptionText() {
    return Padding(
        padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
        child: DescriptionTextWidget(text: meeting.agenda)
    );
  }

  Widget _dateAndPlace() {
    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.05),
      child: Column(
        children: <Widget>[

          ListTile(
            leading: Icon(Icons.access_time, color: Colors.blue,),
            title: Text(meeting.date),
            subtitle: Text(meeting.time),
          ),
          ListTile(
            leading: Icon(Icons.location_on, color: Colors.blue,),
            title: Text(meeting.location),
            subtitle: Text('Sector 14, Chandigarh'),
          ),
          Divider(height: 0.0,)
        ],
      ),
    );
  }


}