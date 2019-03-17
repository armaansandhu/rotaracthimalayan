import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rotaract_app/core/models/user.dart';
import 'package:rotaract_app/core/ui/admin/manage_users.dart';
import 'package:rotaract_app/core/ui/announcements.dart';
import 'package:rotaract_app/core/ui/meeting_management/meeting_schedule.dart';
import 'package:rotaract_app/core/ui/meeting_description_widget/meeting_description.dart';
import 'package:rotaract_app/core/ui/meeting_management/view_scheduled_meetings.dart';
import 'package:rotaract_app/core/ui/meetingindex/meetingindex.dart';
import 'package:rotaract_app/core/ui/notifications/user_notifcations.dart';
import 'package:rotaract_app/core/ui/profile/profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:async/async.dart';
import 'package:rotaract_app/core/ui/splashscreen.dart';
import 'package:rotaract_app/core/ui/wiki/wiki.dart';
import 'package:rotaract_app/core/utils/authprovider.dart';
import 'package:rotaract_app/core/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({this.onSignedOut});
  final VoidCallback onSignedOut;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  Size screenSize(BuildContext context) => MediaQuery.of(context).size;
  final msg = new FirebaseMessaging();
  final firestore = Firestore.instance;
  final memoizer = AsyncMemoizer();
  String userId;
  User user;


  _getSubscribtion() {
    return memoizer.runOnce(() async{

      userId = await AuthProvider.of(context).auth.currentUser();
      await Firestore.instance.collection('users').document(userId).get().then((snapshot) {
        user = User.fromJson(snapshot.data);
        print(snapshot.data);
      });
      SharedPreferences preferences = await SharedPreferences.getInstance();
      bool isLoadedFirst = preferences.getBool(userId);
      if(isLoadedFirst == null){
        user.subscription.forEach((f) => FirebaseMessaging().subscribeToTopic(f));
        preferences.setBool(userId, false);
      }
      return Future.delayed(Duration(seconds: 0));
    });
  }

  getRoutes(mssg) {
    if(mssg['data']['type'] == 'meeting'){
      var reference  = mssg['data']['reference'];
      return Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MeetingDescription(reference,userId)));
    }
  }
  int notificationCount = null;
  userneww()async{
    var usernew = await FirebaseAuth.instance.currentUser();
    print(usernew.email);
    Firestore.instance.collection('users/${usernew.uid}/notifications')
        .where('seen', isEqualTo: false)
        .getDocuments()
        .then((snap){
      setState(() {
        notificationCount = snap.documents.length;
      });
    });
  }

  @override
  void initState() {
    userneww();
    msg.requestNotificationPermissions();
    msg.configure(
        onLaunch: (mssg) async {
          print('onLaunch : $mssg');
          var tempUser = await FirebaseAuth.instance.currentUser();
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MeetingDescription(mssg['reference'], tempUser.uid)));
        },
        onResume: (mssg) async{
          print('onResume : $mssg');
          var tempUser = await FirebaseAuth.instance.currentUser();
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MeetingDescription(mssg['reference'], tempUser.uid)));
        },
        onMessage: (mssg) async{
          print('onMessage : $mssg');}
    );
    super.initState();
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
                        AppBar(
                          title: Text('Rotaract Himalayan'),
                          elevation: 0.0,backgroundColor: Colors.transparent,
                          actions: <Widget>[
                            Stack(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.notifications,color: Colors.white,size: 30,),
                                  onPressed: ()=> getRoute(context,UserNotifications(userId)),
                                ),
                                Positioned(child: CircleAvatar(child: Text(notificationCount == null ? '0' : '$notificationCount',style: TextStyle(
                                    fontSize: 10
                                ),),radius: 8,),top: 10,right: 4,)
                              ],
                            )
                          ],
                        ),
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
        return SplashScreen();
    });
  }
  bool notification = false;
  content(){
    var cardColor = Colors.white ;
    var textColor = Colors.black;
    return Column(
      children: <Widget>[
        Container(
          height: screenSize(context).height * .85,
          child: ListView(
            children: <Widget>[
              homeTile('Rotaract Wiki',Wiki()),
              homeTile('Announcements', Announcements()),
              homeTile('Meetings', MeetingIndex(user.id)),
              homeTile('Profile', MyProfile(onSignedOut: widget.onSignedOut, id: userId,user: user))
            ],
          ),
        ),
      ],
    );
  }
  var tileColor = Colors.white;
  Widget homeTile(String text,Widget child,{notification}){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * .8,
        height: 120,
        child: Material(
            color: notification == true ? Colors.red : tileColor,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            elevation: 10,
            shadowColor: Color.fromRGBO(10, 0, 100, 0.1),
            child: InkWell(
              splashColor: Colors.red,
              onTap: ()async{
                getRoute(context,child);
              },
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(
                    child: Text(text,style: Theme.of(context).textTheme.title,)),
              ),
            )),
      ),
    );
  }

  Widget drawer(){
    if(user.designation == 'Team Leader')
      return Drawer(
        child: Column(
            children: <Widget>[
              ListTile(title: Text('Admin Options',style: Theme.of(context).textTheme.title.copyWith(color: themeColor),),),
              Divider(),
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
