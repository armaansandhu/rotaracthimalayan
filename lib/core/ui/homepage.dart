import 'package:flutter/material.dart';
import 'package:rotaract_app/core/models/user.dart';
import 'package:rotaract_app/core/ui/help.dart';
import 'package:rotaract_app/core/ui/mainlist.dart';
import 'package:rotaract_app/core/ui/meeting_description_widget/meeting_description.dart';
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

  _getSubscribtion() {
    memoizer.runOnce(() async{
      User user;
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
          await getRoute(mssg);
        },
        onMessage: (mssg) async{
          print('onMessage : $mssg');
          await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Help(mssg)));
        }
    );
    super.initState();
  }

  getRoute(mssg) async{
    if(mssg['type'] == 'meeting'){
      var snapshot  = await firestore.document(mssg['reference']).get();
      await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MeetingDescription(snapshot.reference,userId)));
    }
  }
  options(BuildContext context){
    var cardColor = Colors.white70;
    FutureBuilder(future: _getSubscribtion(),builder: (_,__) => SizedBox(height: 0.0,width: 0.0,));
    return Column(
      children: <Widget>[
        Container(
          height: screenSize(context).height * .483,
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
                        child: Center(child: Text('Projects',style: TextStyle(
                            color: Colors.red,
                            fontSize: 24.0
                        ),))),
                  )),
              Card(
                color: cardColor,
                  child: InkWell(
                    onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> MainList('committees'))),
                    child: Container(
                        child: Center(child: Text('Committees',style: TextStyle(
                            color: Colors.red,
                            fontSize: 24.0
                        ),))),
                  )),
              Card(
                color: cardColor,
                  child: InkWell(
                    onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> MainList('events'))),
                    child: Container(
                        child: Center(child: Text('Events',style: TextStyle(
                          color: Colors.red,
                          fontSize: 24.0
                        ),))),
                  )),
              Card(
                color: cardColor,
                  child: InkWell(
                    onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MyProfile(onSignedOut: widget.onSignedOut, id: userId,))),
                    child: Container(
                        child: Center(child: Text('Profile',style: TextStyle(
                            color: Colors.red,
                            fontSize: 24.0
                        ),))))),
            ],
          ),
        ),
        Card(
            color: cardColor,
            child: InkWell(
                onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MyProfile(onSignedOut: widget.onSignedOut, id: userId,))),
                child: Container(
                  height: 150.0,
                    child: Center(child: Text('Meetings',style: TextStyle(
                        color: Colors.red,
                        fontSize: 24.0
                    ),))))),
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rotaract Himalayan',
      theme: ThemeData(
          primaryColor: themeColor),
      routes: {
        '/profile' : (context) => MyProfile(onSignedOut: widget.onSignedOut,)
      },
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: LinearGradient(colors: [themeColor,Colors.orangeAccent],begin: Alignment.topLeft)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(height: 50.0,),
                    options(context)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
