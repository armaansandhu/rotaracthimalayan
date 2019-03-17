import 'package:flutter/material.dart';
import 'package:rotaract_app/core/constants/constants.dart';
import 'package:rotaract_app/core/ui/meeting_management/meeting_schedule.dart';
import 'package:rotaract_app/core/ui/admin/manage_users.dart';
import 'package:rotaract_app/core/ui/meeting_management/view_scheduled_meetings.dart';
import 'package:rotaract_app/core/ui/announcements.dart';

class ManageMeetings extends StatefulWidget {
  ManageMeetings(this.id);
  String id;
  @override
  _ManageMeetingsState createState() => _ManageMeetingsState();
}

class _ManageMeetingsState extends State<ManageMeetings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Schedule Meeting'),
            onTap: () => getRoute(context, ScheduleMeeting(widget.id)),
          ),
          ListTile(
            onTap: () => getRoute(context, ViewScheduledMeetings(widget.id)),
            title: Text('View Scheduled Meetings'),
          ),
          ListTile(
            onTap: () => getRoute(context, ManageUsers()),
            title: Text('Safa'),
          ),
          ListTile(
            onTap: () => getRoute(context, Announcements()),
            title: Text('Announcements'),
          )
        ],
      ),
    );
  }
}
