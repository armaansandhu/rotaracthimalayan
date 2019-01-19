import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotGoing extends StatefulWidget {
  NotGoing(this.notGoing);
  final notGoing;
  @override
  _NotGoingState createState() => _NotGoingState();
}

class _NotGoingState extends State<NotGoing> with AutomaticKeepAliveClientMixin<NotGoing> {
  _getNotGoing(int i) async{
    var userTileData;
    await Firestore.instance.document(widget.notGoing[i]).get().then((snapshot){
      userTileData = snapshot.data;
    });
    return userTileData;
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.notGoing.length,
        itemBuilder: (BuildContext context, int i){
          return FutureBuilder(
              future: _getNotGoing(i),
              builder: (BuildContext context,AsyncSnapshot snapshot){
                if(snapshot.connectionState == ConnectionState.done)
                  return ListTile(
                    contentPadding: EdgeInsets.all(8.0),
                    leading: CircleAvatar(radius: 25.0, backgroundImage: NetworkImage(snapshot.data['dp']),),
                    title: Text(snapshot.data['name']),
                    subtitle: Text(snapshot.data['college']),
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: CircleAvatar(
                          radius: 15.0,
                          backgroundColor: Color.fromRGBO(0, 100, 255, .7),
                          child: Text(snapshot.data['team'],
                            style: TextStyle(
                                color: Colors.white
                            ),)),
                    ),
                  );
                else
                  return Container();
              });
        });
  }

  @override
  bool get wantKeepAlive => true;
}
