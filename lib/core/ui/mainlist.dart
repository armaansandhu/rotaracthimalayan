import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:rotaract_app/core/constants/constants.dart';
import 'package:rotaract_app/core/ui/detailpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rotaract_app/core/utils/authprovider.dart';

class ShadowText extends StatelessWidget {
  ShadowText(this.data, {this.style}) : assert(data != null);

  final String data;
  final TextStyle style;

  Widget build(BuildContext context) {
    return new ClipRect(
      child: new Stack(
        children: [
          new Positioned(
            top: 2.0,
            left: 2.0,
            child: new Text(
              data,
              style: style.copyWith(color: Colors.black.withOpacity(0.5)),
            ),
          ),
          new BackdropFilter(
            filter: new ui.ImageFilter.blur(sigmaX: 1.0, sigmaY: 2.0),
            child: new Text(data, style: style),
          ),
        ],
      ),
    );
  }
}

class MainList extends StatelessWidget {
  final String title;

  MainList(this.title);

  final firestore = Firestore.instance;
  var id;

  Future<List<DocumentSnapshot>> _getList(context) async {
    id = await AuthProvider.of(context).auth.currentUser();
    var listItems;
    await firestore.collection(title).getDocuments().then((snapshot) {
      listItems = snapshot.documents;
    });
    return listItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context),
        body: FutureBuilder(
          future: _getList(context),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int i) =>
                      _buildList(context, i, snapshot.data));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Size screenSize(BuildContext context) => MediaQuery.of(context).size;

  _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: themeColor,
      elevation: 0.0,
      title: Text('${title[0].toUpperCase()}${title.substring(1)}'),
      centerTitle: true,
    );
  }

  _buildList(BuildContext context, int i, List<DocumentSnapshot> listItems) {
    return InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    DetailPage(listItems[i], id))),
        child: Stack(
          children: <Widget>[
            Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAlias,
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.amber, Colors.amberAccent])),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: ShadowText(
                listItems[i].data['name'],
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              )),
            )
          ],
        ));
  }
}
