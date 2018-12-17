import 'package:flutter/material.dart';
import 'package:rotaract_app/ui/attendinglist/going.dart';
import 'package:rotaract_app/ui/attendinglist/notgoing.dart';

class AttendingList extends StatelessWidget {

  AttendingList(this.allUsers);
  final allUsers;

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
                Tab(text: "Going (${allUsers['going'].length})",),
                Tab(text: "Not Going (${allUsers['notgoing'].length})",),
              ],
            ),
            title: Text('Attendees'),
          ),
          body: TabBarView(
                  children: [
                    Going(allUsers['going']),
                    NotGoing(allUsers['notgoing'])
                  ],
          )));
    }
}
