import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rotaract_app/core/models/meeting.dart';
import '../attending_list_widget/attendinglist.dart';

class GoingUserList extends StatefulWidget {
  GoingUserList(this.meeting);
  final Meeting meeting;

  @override
  _GoingUserListState createState() => _GoingUserListState();
}


class _GoingUserListState extends State<GoingUserList> {
  DocumentReference reference;
  @override
  void initState() {
    reference = Firestore.instance.document(widget.meeting.reference);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _attendingList();
  }

  _dateAndPluralCheck(listLength){
    if(widget.meeting.period=='past')
      return '$listLength Person attended';
    else
      return '$listLength Person will be attending';
  }

  Widget _attendingList(){
    return _buildAttendees();
  }

  Widget _buildAttendees(){
    return StreamBuilder(
        stream: reference.collection('going').snapshots(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            return InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AttendingList(snapshot.data.documents))),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 12.0,),
                  ListTile(
                    title: Text(_dateAndPluralCheck(snapshot.data.documents.length),
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold
                        )),
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        height: 35.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data.documents.map((item){
                            return Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Container(
                                  width: 35.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(image: NetworkImage(item.data['dp']),
                                      fit: BoxFit.fill,),
                                    borderRadius:
                                    new BorderRadius.all(new Radius.circular(30.0)),
                                  ),
                                ));
                          }).toList(),
                        ),
                      ),
                    ),
                    trailing: Text('See More'),
                  ),
                ],
              ),
            );
          } else
            return Container();
        });
  }
}
