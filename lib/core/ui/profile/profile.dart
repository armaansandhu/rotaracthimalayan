import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rotaract_app/core/models/user.dart';
import 'package:rotaract_app/core/ui/my_meetings.dart';
import 'package:rotaract_app/core/ui/my_notifications/notification_category_list.dart';
import 'package:rotaract_app/core/ui/profile/path.dart';
import 'package:rotaract_app/core/utils/authprovider.dart';
import 'package:rotaract_app/core/constants/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class MyProfile extends StatefulWidget {
  MyProfile({this.onSignedOut, this.id, this.user});
  final VoidCallback onSignedOut;
  final String id;
  final User user;
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  var dp = null;
  var localDp = 'images/placeholder.png';
  User user;

  getUser() async{
    Stopwatch stopwatch = Stopwatch();
    stopwatch..start();
    var user = await Firestore.instance.document('users/${widget.id}').get();
    dp = user.data['dp'];
    print(stopwatch.elapsed.inSeconds);
    return user.data;
  }

  void _signOut(BuildContext context) async {
    try {
      widget.user.subscription.forEach((f)=> FirebaseMessaging().unsubscribeFromTopic(f));
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
    File compressedImage = await FlutterNativeImage.compressImage(tempImage.path,quality: 30);
    StorageReference profileImageRef = FirebaseStorage.instance.ref().child('users/${widget.id}');
    setState(() {
      isImageUploading = true;
    });
    if(tempImage == null){
      setState(() {
        isImageUploading = false;
      });
    } else {
      var task = await profileImageRef.putFile(compressedImage);
      var newDP = await profileImageRef.getDownloadURL();
      await Firestore.instance.document('users/${widget.id}').updateData({
        'dp':'$newDP'
      });
      setState(() {
        dp = newDP;
      });
      isImageUploading = false;
    }
  }

  imageContainer(){
    return Container(
      width: 120.0,
      height: 120.0,
      decoration: new BoxDecoration(
          color: const Color(0xff7c94b6),
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
      child: FutureBuilder(
          future: getUser(),
          builder: (BuildContext context,AsyncSnapshot snapshot){
            if(snapshot.connectionState == ConnectionState.done)
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(new Radius.circular(100.0)),
                    image: DecorationImage(
                      image: dp == null ? AssetImage(localDp) : NetworkImage(dp,),
                      fit: BoxFit.cover,
                    )
                ),
              );
            else return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(new Radius.circular(100.0)),
                color: Colors.grey
              ),
            );
          }),
    );



  }

  Widget _buildImageBox(User user){
    return ClipPath(
      clipper: ImageCurve(),
      child: Container(
        height: MediaQuery.of(context).size.height*0.3,
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
                            dp == null ? Image.asset(localDp) : Image.network(dp)
                          ],
                        ));
                      },
                      child: isImageUploading == false ? imageContainer() :
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
                      right: 0.0, bottom: 0.0,)
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
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MyMeetings(user.id))),
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
  void initState() {
    user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Colors.white,
      body: Container(
          child: _buildUI(widget.user)
      ),
    );
  }
}