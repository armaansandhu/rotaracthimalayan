import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rotaract_app/ui/help.dart';
import 'package:rotaract_app/ui/meetingdescription/goinguserlistwidget.dart';
import 'package:rotaract_app/ui/meetingdescription/descriptiontext.dart';
import 'package:intl/intl.dart';

class MeetingDescription extends StatefulWidget {
  MeetingDescription(this.meetingSnapshot, this.id);
  final DocumentSnapshot meetingSnapshot;
  final id;

  @override
  _MeetingDescriptionState createState() => _MeetingDescriptionState();
}

class _MeetingDescriptionState extends State<MeetingDescription> {
  final Firestore firestore = Firestore.instance;
  Map<String,dynamic> meeting;
  String id;
  bool containGoing;
  bool containNotGoing;

  Size screenSize(BuildContext context) => MediaQuery.of(context).size;

  _getMeetingData() async{
    await widget.meetingSnapshot.reference.get().then((snapshot) {
      meeting = snapshot.data;
    });}

  _updateGoingList(){
    return FutureBuilder(
        future: _getMeetingData(),
        builder: (BuildContext context,AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            return GoingUserList(meeting);
          else
            return Container(height: 30.0,);
        }
    );
  }

  @override
  void initState() {
    id = widget.id;
    meeting = widget.meetingSnapshot.data;
    containGoing = meeting['going'].contains('users/$id');
    containNotGoing = meeting['notgoing'].contains('users/$id');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        backgroundColor: Colors.white,
        body: _buildContent()
    );
  }

  Widget _buildContent(){
    return ListView(
              children: <Widget>[
                _title(),
                _descriptionText(),
                _dateAndPlace(),
                _confirmationButtons(),
                Divider(height: 0.0,),
                _updateGoingList()
              ],
            );
  }

  Widget _appBar(){
    return AppBar(
      title: Text(meeting['category']),
      backgroundColor: Colors.red,
    );
  }

  Widget _title(){
    return Padding(
      padding: const EdgeInsets.only(top : 24.0),
      child: Center(
        child: InkWell(
          onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Home())),
          child: Text(
            meeting['title'],
            style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _descriptionText(){
    return Padding(
        padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
        child: DescriptionTextWidget(text: meeting['agenda'])
    );
  }

  Widget _dateAndPlace(){
    final dateFormatter = new DateFormat('EEEE, d MMMM');
    final timeFormatter = new DateFormat('jm');
    return Column(
      children: <Widget>[
        Divider(),
        ListTile(
          leading: Icon(Icons.access_time, color: Colors.blue,),
          title: Text(dateFormatter.format(meeting['time'])),
          subtitle: Text(timeFormatter.format(meeting['time'])),
        ),
        ListTile(
          leading: Icon(Icons.location_on, color: Colors.blue,),
          title: Text(meeting['location']),
          subtitle: Text('Sector 14, Chandigarh'),
        ),
        Divider(height: 0.0,)
      ],
    );
  }

  Widget _confirmationButtons(){
    if(meeting['date']=='past')
      return Center();
    if(containGoing==true)
      return _goingConfirmation();
    if(containNotGoing==true)
      return _notGoingConfirmation();
    else
      return _undecidedConfirmation();
  }

  _undecidedConfirmation(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
              children: <Widget>[
                InkWell(
                    onTap: ()=> going(),
                    borderRadius: BorderRadius.circular(50.0),
                    child: CircleAvatar(
                      radius: 30.0,
                      child: Icon(
                        Icons.thumb_up,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.green,
                    )),
                SizedBox(height: 8.0,),
                Text('Going', style: TextStyle(fontSize: 16.0),),

              ]),
          Column(
            children: <Widget>[
              InkWell(
                onTap: notGoing,
                child: CircleAvatar(
                  radius: 30.0,
                  child: Icon(
                    Icons.thumb_down,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.red,
                ),
              ),
              SizedBox(height: 8.0),
              Text('Not Going')
            ],
          )
        ],
      ),
    );
  }

  _goingConfirmation(){
    return Container(
      height: 116.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: screenSize(context).width,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.green, Colors.white,])
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Hurray! You're coming.", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0,color: Colors.white),),
                Container(
                  width: screenSize(context).width*.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                          borderRadius: BorderRadius.circular(30.0),
                          onTap: ()=>notGoing(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30.0,
                              child: Icon(Icons.cancel),
                            ),
                          )
                      ),
                      Text('Not Going')
                    ]))]))]));
  }

  _notGoingConfirmation(){
    return Container(
      height: 116.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: screenSize(context).width,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.red, Colors.white,])
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("You're not coming", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0,color: Colors.white),),
                Container(
                  width: screenSize(context).width*.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                          borderRadius: BorderRadius.circular(30.0),
                          onTap: ()=>going(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30.0,
                              child: Icon(Icons.check),
                            ),
                          )
                      ),
                      Text('Going')
                    ],
                  ),
                )
              ],
            ),
          ),

        ],
      ),
    );
  }

  going() async{
    var newGoing = new List<String>.from(meeting['going']);
    newGoing.add('users/$id');
    var newNotGoing = new List<String>.from(meeting['notgoing']);
    newNotGoing.remove('users/$id');
    var newMap = {
      'going' : newGoing,
      'notgoing': newNotGoing
    };
    await widget.meetingSnapshot.reference
        .updateData(newMap)
        .then((_){
      setState(() {
        containGoing = true;
        containNotGoing = false;
      });
    })
        .catchError((e)=>debugPrint(e));
  }

  notGoing() async{
    var newGoing = new List<String>.from(meeting['going']);
    newGoing.remove('users/$id');
    var newNotGoing = new List<String>.from(meeting['notgoing']);
    newNotGoing.add('users/$id');
    var newMap = {
      'going' : newGoing,
      'notgoing': newNotGoing
    };
    await widget.meetingSnapshot.reference
        .updateData(newMap).then((_){
      setState(() {
        containNotGoing = true;
        containGoing = false;
      });
    })
        .catchError((e)=>debugPrint(e));
  }

}
