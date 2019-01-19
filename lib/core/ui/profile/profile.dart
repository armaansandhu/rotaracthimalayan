import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rotaract_app/core/ui/my_meetings.dart';
import 'package:rotaract_app/core/ui/notification_list_widget/notification_category_list.dart';
import 'package:rotaract_app/core/ui/profile/path.dart';
import 'package:rotaract_app/core/utils/authprovider.dart';
import 'package:rotaract_app/core/models/user.dart';
import 'package:rotaract_app/core/constants/constants.dart';
import 'package:rotaract_app/core/blocs/userbloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class MyProfile extends StatefulWidget {
  MyProfile({this.onSignedOut, this.id});
  final VoidCallback onSignedOut;
  final String id;
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  User userSub;

  void _signOut(BuildContext context) async {
    try {
      userSub.projects.forEach((f)=> FirebaseMessaging().unsubscribeFromTopic(f));
      userSub.committees.forEach((f)=> FirebaseMessaging().unsubscribeFromTopic(f));
      userSub.events.forEach((f)=> FirebaseMessaging().unsubscribeFromTopic(f));
      var auth = AuthProvider.of(context).auth;
      await auth.signOut();
      widget.onSignedOut();
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  Widget _appBar(){
    return new AppBar(
      title: new Text('Profile'),
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: themeColor,
    );
  }

  bool isImageUploading = false;

  Future uploadImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    StorageReference profileImageRef = FirebaseStorage.instance.ref().child('users/${widget.id}');
    setState(() {
      isImageUploading = true;
    });
    if(tempImage == null){
      setState(() {
        isImageUploading = false;
      });
    } else {
      var task = await profileImageRef.putFile(tempImage).onComplete.then((_){
        setState(() {
          isImageUploading = false;
        });
      });
    }
    var newDP = await profileImageRef.getDownloadURL();
    await Firestore.instance.document('users/${widget.id}').updateData({
      'dp':'$newDP'
    });
  }


  Widget _buildImageBox(User user){
    return ClipPath(
      clipper: ImageCurve(),
      child: Container(
        color: themeColor,
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 32.0),
                child: Stack(
                  children: <Widget>[
                    GestureDetector(
                      onTap: ()async{
                        await showDialog(context: context,builder: (_) => SimpleDialog(
                          children: <Widget>[
                            Image.network(user.dp)
                          ],
                        ));
                      },
                      child: isImageUploading == false ? Container(
                        width: 120.0,
                        height: 120.0,
                        decoration: new BoxDecoration(
                            color: const Color(0xff7c94b6),
                            image: DecorationImage(
                              image: new NetworkImage(user.dp ),
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
                      ) :
                      Container(
                        width: 120.0,
                        height: 120.0,
                        decoration: new BoxDecoration(
                            color: const Color(0xff7c94b6),
                            borderRadius: BorderRadius.all(new Radius.circular(100.0)),
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
                        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow)),
                      ),
                    ),
                    Positioned(
                      child: GestureDetector(
                          onTap: uploadImage,
                          child: CircleAvatar(
                              radius: 16.0,
                              child: Icon(Icons.edit,size: 20.0,))),
                      right: 0.0, top: 0.0,)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(User user){
    final leadingColor = Colors.black;
    final trailerColor = Colors.grey;

    return Column(
      children: <Widget>[
        ListTile(
            leading: Text('Name', style: TextStyle(fontSize: 18.0, color: leadingColor)),
            trailing: Text(user.name,
                style: TextStyle(fontSize: 18.0, color: trailerColor)),
        ),
        ListTile(
          leading: Text('Designation', style: TextStyle(fontSize: 18.0, color: leadingColor)),
          trailing: Text(user.designation,
              style: TextStyle(fontSize: 18.0, color: trailerColor)),
        ),
        ListTile(
          leading: Text('Team', style: TextStyle(fontSize: 18.0, color: leadingColor)),
          trailing: Text(user.team,
              style: TextStyle(fontSize: 18.0, color: trailerColor)),
        ),
        ListTile(
          leading: Text('College', style: TextStyle(fontSize: 18.0, color: leadingColor)),
          trailing: Text(user.college,
              style: TextStyle(fontSize: 18.0, color: trailerColor)),
        ),
        ListTile(
          leading: Text('My Meetings', style: TextStyle(fontSize: 18.0, color: leadingColor)),
          trailing: Icon(Icons.navigate_next),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MyMeetings(user.id,user.myMeetings))),
        ),
        ListTile(
          leading: Text('My Notifications', style: TextStyle(fontSize: 18.0, color: leadingColor)),
          trailing: Icon(Icons.navigate_next),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => NotificationCategoryList(id: user.id,))),
        ),
      ],
    );
  }

  Widget _buildUserContent(user){
    return Card(
      elevation: 0.0,
      child: Column(
        children: <Widget>[
          _buildUserInfo(user),
        ],
      ),
    );
  }

  Widget _buildUI(user){
    userSub = user;
    return Column(
      children: <Widget>[
        _buildImageBox(user),
        Expanded(
          child: Container(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                _buildUserContent(user),
                _signOutButton(context)
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _signOutButton(BuildContext context) {
    return Card(
      elevation: 0.0,
      child: InkWell(
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 4.0),
          leading: Icon(
            Icons.power_settings_new,
            color: Colors.red,
          ),
          title: Text('Sign Out', style: TextStyle(fontSize: 18.0)),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () => _signOut(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    userBloc.fetchUserInfo(context);
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Colors.white,
      body: Container(
          child: StreamBuilder(
            stream: userBloc.userStream,
            builder: (BuildContext context,AsyncSnapshot snapshot){
              if(snapshot.hasData){
                return _buildUI(snapshot.data);
              }
              else
                return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)));
            },
          )
      ),
    );
  }
}