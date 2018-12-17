import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rotaract_app/ui/attendinglist/attendinglist.dart';

class GoingUserList extends StatefulWidget {
  GoingUserList(this.meeting);
  final Map<String,dynamic> meeting; //Map

  @override
  _GoingUserListState createState() => _GoingUserListState();
}

class _GoingUserListState extends State<GoingUserList> {
  final Firestore firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return _attendingList();
  }

  _dateAndPluralCheck(){
    if(widget.meeting['date']=='past')
      return '${widget.meeting['going'].length} Person attended';
    else
      return '${widget.meeting['going'].length} Person will be attending';
  }

  Widget _attendingList(){
    return InkWell(
      onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AttendingList(widget.meeting))),
      child: Column(
        children: <Widget>[
          SizedBox(height: 12.0,),
          ListTile(
            title: Text(_dateAndPluralCheck(),
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                )),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: _buildAttendees(),
            ),
            trailing: Text('See More'),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendees(){
    return Container(
        height: 35.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.meeting['going'].length<=5 ? widget.meeting['going'].length : 5,
          itemBuilder: (BuildContext context, int i) => FutureBuilder(
              future: userInfo(i),
              builder: (BuildContext context,AsyncSnapshot snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  return Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Container(
                        width: 35.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: NetworkImage(snapshot.data),
                            fit: BoxFit.fill,),
                          borderRadius:
                          new BorderRadius.all(new Radius.circular(30.0)),
                        ),
                      ));
                } else
                  return Container();
              }),
        ));
  }

  userInfo(int i) async{
    var tmp;
    await firestore.document(widget.meeting['going'][i]).get().then((snapshot){
      tmp = snapshot.data['dp'];
    });
    return tmp;
  }
}
