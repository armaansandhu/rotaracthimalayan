import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  Help(this.mssg);

  final mssg;

  getData() async {
    final data =
        await Firestore.instance.document(mssg['data']['reference']).get();
    return data.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: getData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done)
                return Column(
                  children: <Widget>[
                    Text(snapshot.data['agenda']),
                    Text(snapshot.data['title'])
                  ],
                );
              else
                return Center(
                  child: CircularProgressIndicator(),
                );
            }));
  }
}
