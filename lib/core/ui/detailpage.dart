import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rotaract_app/core/ui/meetings_catalog_widget/meetings_catalog.dart';

class DetailPage extends StatelessWidget {
  final link =
      'https://images.pexels.com/photos/36753/flower-purple-lical-blosso.jpg?cs=srgb&dl=bloom-blooming-blossom-36753.jpg&fm=jpg';
  final DocumentSnapshot item;

  DetailPage(this.item, this.id);

  final id;

  screenSize(BuildContext context) => MediaQuery.of(context).size.height;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.yellow,
          expandedHeight: 200.0,
          title: Text(item.data['name']),
          flexibleSpace: FlexibleSpaceBar(
            background: Image.network(
              link,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text(
              item.data['name'],
              style: TextStyle(fontSize: 32.0),
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              item.data['description'],
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        MeetingCatalog(item.data['name'], id))),
            child: Container(
              height: screenSize(context) * .1,
              color: Colors.blue,
              child: Center(
                  child: Text(
                "View Meetings",
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )),
            ),
          ),
          Divider(
            height: 0.0,
          )
        ]))
      ],
    ));
  }
}
