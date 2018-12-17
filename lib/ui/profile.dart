import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rotaract_app/utils/authprovider.dart';
import 'package:rotaract_app/json/user.dart';

const Color _color = Colors.red;

class MyProfile extends StatefulWidget {
  MyProfile({this.onSignedOut});
  final VoidCallback onSignedOut;
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  List list = List.generate(4, (i)=>'Hello $i');
  User user;
  String userId;
  var url;
  Firestore db = Firestore.instance;
  AsyncMemoizer asyncMemoizer = AsyncMemoizer();


  _getCurrentUser(BuildContext context) async{
    try{
      userId = await AuthProvider.of(context).auth.currentUser();
      print(userId);
      return userId;
    }catch(e){
      print('No Such Method');
    }
  }

  _getUser(String userId){
    return asyncMemoizer.runOnce(() async{
      await db.collection('users').where('id', isEqualTo: userId).getDocuments().then((snapshot) {
        if (snapshot.documents[0].exists) {
          print(snapshot.documents[0].data);
          user = User.fromJson(snapshot.documents[0].data);
        }
      });

    });
  }

  void _signOut(BuildContext context) async {
    try {
      var auth = AuthProvider.of(context).auth;
      await auth.signOut();
      widget.onSignedOut();
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        child: FutureBuilder(
            future: _getCurrentUser(context),
            builder: (BuildContext context,AsyncSnapshot snapshot){
              if(snapshot.connectionState == ConnectionState.done)
                return FutureBuilder(
                  future: _getUser(snapshot.data),
                  builder: (BuildContext context,AsyncSnapshot snapshot){
                    if(snapshot.connectionState == ConnectionState.done)
                      return Column(
                        children: <Widget>[
                          _buildImageBox(),
                          Expanded(
                            child: Container(
                              child: ListView(
                                children: <Widget>[
                                  _buildUserContent(context),
                                  SizedBox(height: 36.0,),
                                  _signOutButton(context)
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    else
                      return Center(child: CircularProgressIndicator());
                  },
                );
              else
                return CircularProgressIndicator();
            }
        ),
      ),
    );
  }

  //User Interface

  Widget _appBar(){
    return new AppBar(
      title: new Text('Profile'),
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: _color,
    );
  }

  Widget _buildImageBox(){
    return new Container(
      color: _color,
      child: new Center(
        child: Column(
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 32.0),
              child: Container(
                        width: 120.0,
                        height: 120.0,
                        decoration: new BoxDecoration(
                            color: const Color(0xff7c94b6),
                            image: DecorationImage(
                              image: new NetworkImage(user.dp),
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                            new BorderRadius.all(new Radius.circular(100.0)),
                            border: new Border.all(
                              color: Colors.white,
                              width: 2.0,
                            ),
                            boxShadow: [
                              new BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.1),
                                  offset: new Offset(0.0, 5.0),
                                  blurRadius: 10.0)
                            ]),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserContent(BuildContext context){
    return new Card(
      child: new Column(
        children: <Widget>[
          _buildUserInfo(context),
          new Divider(),
          _buildExpansionList()
        ],
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context){
    final leadingColor = Colors.black;
    final trailerColor = Colors.grey;

    return Column(
      children: <Widget>[
        ListTile(
            leading: Text('Name', style: TextStyle(fontSize: 18.0, color: leadingColor)),
            trailing: new Text(user.name,
                style: TextStyle(fontSize: 18.0, color: trailerColor)),
        ),
        new ListTile(
          leading: Text('Designation', style: TextStyle(fontSize: 18.0, color: leadingColor)),
          trailing: new Text(user.designation,
              style: TextStyle(fontSize: 18.0, color: trailerColor)),
        ),
        new ListTile(
          leading: Text('Team', style: TextStyle(fontSize: 18.0, color: leadingColor)),
          trailing: new Text(user.team,
              style: TextStyle(fontSize: 18.0, color: trailerColor)),
        ),
        new ListTile(
          leading: Text('College', style: TextStyle(fontSize: 18.0, color: leadingColor)),
          trailing: new Text(user.college,
              style: TextStyle(fontSize: 18.0, color: trailerColor)),
        ),
      ],
    );
  }

  Widget _buildExpansionList() {
    return Column(
      children: <Widget>[
        ExpansionTile(
            title: new Text(
              'Projects',
              style: TextStyle(fontSize: 18.0),
            ),
            children: user.projects
                .map((val) => Container(
              color: Color.fromRGBO(0, 0, 0, 0.02),
              child: new ListTile(
                title: new Text(val),
              ),
            ))
                .toList()),
        ExpansionTile(
            title: new Text(
              'Committees',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            children: user.committees
                .map((val) => Container(
              color: Color.fromRGBO(0, 0, 0, 0.02),
              child: new ListTile(
                title: new Text(val),
              ),
            ))
                .toList()),
        ExpansionTile(
            title: new Text(
              'Events',
              style: TextStyle(fontSize: 18.0),
            ),
            children: user.events
                .map((val) => Container(
              color: Color.fromRGBO(0, 0, 0, 0.02),
              child: new ListTile(
                title: new Text(val),
              ),
            ))
                .toList())
      ],
    );
  }

  Widget _signOutButton(BuildContext context) {
    return Card(
      child: new InkWell(
        child: new ListTile(
          contentPadding: EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 4.0),
          leading: new Icon(
            Icons.power_settings_new,
            color: Colors.red,
          ),
          title: new Text('Sign Out', style: TextStyle(fontSize: 18.0)),
          trailing: new Icon(Icons.keyboard_arrow_right),
          onTap: () => _signOut(context),
        ),
      ),
    );
  }
}













