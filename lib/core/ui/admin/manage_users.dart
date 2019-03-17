import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rotaract_app/core/constants/constants.dart';

class ManageUsers extends StatefulWidget {
  @override
  _ManageUsersState createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  var order = 'name';
  String _radioValue;
  String selected = 'By Name';
  Map<String,String> sortItems = {
    'By Name' : 'name',
    'By Position' : 'designation'
  };

  //Fetch sorted users from Firebase.
  getUsers() async{
    var docs = await Firestore.instance.collection('users').
    orderBy(order, descending: false).getDocuments();
    return docs;
  }

  void _handleRadioValueChange(String value) {
    setState(() {
      _radioValue = value;
      order = _radioValue;
      Navigator.of(context).pop();
    });
  }

  void _newTaskModalBottomSheet(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              children: <Widget>[
                ListTile(
                  title: Text('Name'),
                  leading: Radio(value: 'name', groupValue: _radioValue, onChanged: (e){}),
                onTap: (){
                  _handleRadioValueChange('name');
                },),
                ListTile(
                  title: Text('Designation'),
                  leading: Radio(value: 'designation', groupValue: _radioValue, onChanged: (e){}),
                  onTap: (){
                  _handleRadioValueChange('designation');
                  }
                ),

                ListTile(
                    title: Text('Team'),
                    leading: Radio(value: 'team', groupValue: _radioValue, onChanged: (e){}),
                    onTap: (){
                      _handleRadioValueChange('team');
                    }
                ),
              ],
            ),
          );
        }
    );
  }

  Widget _bottomNavigationBar(){
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          InkWell(
            onTap: (){
              _newTaskModalBottomSheet(context);
            },
            child: Container(
              height: 50,
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Sort'),
                  Icon(Icons.sort),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(){
    FutureBuilder(
      future: getUsers(),
      builder: (BuildContext context,AsyncSnapshot snapshot){
        if(snapshot.connectionState == ConnectionState.done)
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int i){
                return ListTile(
                  contentPadding: EdgeInsets.all(8.0),
                  leading: CircleAvatar(radius: 25.0, backgroundImage: NetworkImage(snapshot.data.documents[i].data['dp']),),
                  title: Text(snapshot.data.documents[i].data['name']),
                  subtitle: Text(snapshot.data.documents[i].data['designation']),
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: CircleAvatar(
                        radius: 15.0,
                        backgroundColor: Color.fromRGBO(0, 100, 255, .7),
                        child: Text(snapshot.data.documents[i].data['team'],
                          style: TextStyle(
                              color: Colors.white
                          ),)),
                  ),
                );
              });
        else
          return listPlaceholder(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
            title: Text('Manage Users'),
            backgroundColor: themeColor,
        ),
        bottomNavigationBar: _bottomNavigationBar(),
        body: _body()
    );
  }
}
