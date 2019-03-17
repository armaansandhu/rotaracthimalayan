import 'package:flutter/material.dart';
import 'package:rotaract_app/core/models/user.dart';
import 'package:rotaract_app/core/ui/admin/manage_users.dart';
import 'package:rotaract_app/core/ui/announcements.dart';
import 'package:rotaract_app/core/ui/meeting_management/manage_meetings.dart';
import 'package:rotaract_app/core/ui/meeting_management/meeting_schedule.dart';
import 'package:rotaract_app/core/ui/help.dart';
import 'package:rotaract_app/core/ui/mainlist.dart';
import 'package:rotaract_app/core/ui/meeting_description_widget/meeting_description.dart';
import 'package:rotaract_app/core/ui/meeting_management/view_scheduled_meetings.dart';
import 'package:rotaract_app/core/ui/profile/profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:async/async.dart';
import 'package:rotaract_app/core/utils/authprovider.dart';
import 'package:rotaract_app/core/constants/constants.dart';

class HomePage extends StatefulWidget {
  HomePage({this.onSignedOut});
  final VoidCallback onSignedOut;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Size screenSize(BuildContext context) => MediaQuery.of(context).size;
  final msg = new FirebaseMessaging();
  final firestore = Firestore.instance;
  final memoizer = AsyncMemoizer();
  String userId;
  User user;
  _getSubscribtion() {
    return memoizer.runOnce(() async{
      Map<String,dynamic> data = {'userInfo' : null, 'projects' : null,'events' : null,'committees' : null,};
      userId = await AuthProvider.of(context).auth.currentUser();
      await Firestore.instance.collection('users').document(userId).get().then((snapshot) {
        if (snapshot.exists) {
          data['userInfo'] = snapshot.data;
        }
      });
      await Firestore.instance.collection('users/$userId/projects').getDocuments().then((snapshot) {
        if (snapshot.documents.isNotEmpty) {
          data['projects'] = snapshot.documents;
        }
      });
      await Firestore.instance.collection('users/$userId/events').getDocuments().then((snapshot) {
        if (snapshot.documents.isNotEmpty) {
          data['events'] = snapshot.documents;
        }
      });

      await Firestore.instance.collection('users/$userId/committees').getDocuments().then((snapshot) {
        if (snapshot.documents.isNotEmpty) {
          data['committees'] = snapshot.documents;
        }
      });
      user = User.fromJson(data);
      print(user.projects);
      user.projects.forEach((f) => FirebaseMessaging().subscribeToTopic(f.toLowerCase().replaceAll(' ', '_')));
      user.committees.forEach((f) => FirebaseMessaging().subscribeToTopic(f.toLowerCase().replaceAll(' ', '_')));
      user.events.forEach((f) => FirebaseMessaging().subscribeToTopic(f.toLowerCase().replaceAll(' ', '_')));
      return Future.delayed(Duration(seconds: 0));
    });
  }

  @override
  void initState() {
    msg.requestNotificationPermissions();
    msg.configure(
        onLaunch: (mssg) async{
          print('onLaunch : $mssg');
          await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Help(mssg)));
        },
        onResume: (mssg) async{
          print('onResume : $mssg');
          await getRoutes(mssg);
        },
        onMessage: (mssg) async{
          print('onMessage : $mssg');
          await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Help(mssg)));
        }
    );
    super.initState();
  }

  getRoutes(mssg) async{
    if(mssg['type'] == 'meeting'){
      var snapshot  = await firestore.document(mssg['reference']).get();
      await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MeetingDescription(snapshot.reference,userId)));
    }
  }
  options(BuildContext context){
    return FutureBuilder(future: _getSubscribtion(),builder: (BuildContext context,AsyncSnapshot snapshot){
      if(snapshot.connectionState == ConnectionState.done)
        return Scaffold(
            drawer: drawer(),
            body: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.red, const Color(0xFFE64C85)
                    ])
                  ),
                  height: 100.0,
                ),
                ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        AppBar(elevation: 0.0,backgroundColor: Colors.transparent,),
                        SizedBox(height: 10.0,),
                        content()
                      ],
                    ),
                  ],
                ),

              ],
            )
        );
      else
        return CircularProgressIndicator();
    });
  }

  content(){
    var cardColor = Colors.white ;
    var textColor = Colors.black;
    return Column(
      children: <Widget>[
        Container(
          height: screenSize(context).height * .7,
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Card(
                  color: cardColor,
                  child: InkWell(
                    radius: 20.0,
                    onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> MainList('projects'))),
                    child: Container(
                        child: Center(child: Text('Meetings',style: TextStyle(
                            color: textColor,
                            fontSize: 24.0
                        ),))),
                  )),
              Card(
                  color: cardColor,
                  child: InkWell(
                    onTap: ()=> getRoute(context, Announcements()),
                    child: Container(
                        child: Center(child: Text('Announcements',style: TextStyle(
                            color: textColor,
                            fontSize: 24.0
                        ),))),
                  )),
              Card(
                  color: cardColor,
                  child: InkWell(
                    onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> MainList('events'))),
                    child: Container(
                        child: Center(child: Text('Events',style: TextStyle(
                            color: textColor,
                            fontSize: 24.0
                        ),))),
                  )),
              Card(
                  color: cardColor,
                  child: InkWell(
                      onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MyProfile(onSignedOut: widget.onSignedOut, id: userId,user: user))),
                      child: Container(
                          child: Center(child: Text('Profile',style: TextStyle(
                              color: textColor,
                              fontSize: 24.0
                          ),))))),
            ],
          ),
        ),
      ],
    );
  }

  Widget drawer(){
    if(user.designation == 'Team Leader')
      return Drawer(
        child: Column(
            children: <Widget>[
              ListTile(title: Text('Admin Options',style: Theme.of(context).textTheme.title.copyWith(color: themeColor),),),
              ListTile(
                title: Text('Schedule Meeting'),
                onTap: () => getRoute(context, ScheduleMeeting(user.id)),
              ),
              ListTile(
                onTap: () => getRoute(context, ViewScheduledMeetings(user.id)),
                title: Text('View Scheduled Meetings'),
              ),
              ListTile(
                onTap: () => getRoute(context, ManageUsers()),
                title: Text('Manage Users'),
              ),
            ]
        ),
      );
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/profile' : (context) => MyProfile(onSignedOut: widget.onSignedOut,)
      },
      debugShowCheckedModeBanner: false,
      title: 'Rotaract Himalayan',
      theme: ThemeData(
          primaryColor: themeColor),
      home: SafeArea(
        child: options(context)
      ),
    );
  }
}
