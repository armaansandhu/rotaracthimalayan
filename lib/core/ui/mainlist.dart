import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:rotaract_app/core/constants/constants.dart';
import 'package:rotaract_app/core/ui/detailpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShadowText extends StatelessWidget {
  ShadowText(this.data, { this.style }) : assert(data != null);

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
              style: style.copyWith(color: Colors.black.withOpacity(0.1)),
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

  Future<List<DocumentSnapshot>> _getList() async{
    var listItems;
    await firestore.collection('committees').getDocuments().then((snapshot){
      listItems = snapshot.documents;
    });
    return listItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context),
        body: FutureBuilder(
          future: _getList(),
          builder: (BuildContext context,AsyncSnapshot snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int i) => _buildList(context,i,snapshot.data));
            } else{
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Size screenSize(BuildContext context) => MediaQuery.of(context).size;

  _appBar(BuildContext context){
    return AppBar(
      backgroundColor: themeColor,
      elevation: 0.0,
      title: Text('${title[0].toUpperCase()}${title.substring(1)}'),
      centerTitle: true,
    );
  }

  _buildList(BuildContext context, int i, List<DocumentSnapshot> listItems) {
    final link = 'https://firebasestorage.googleapis.com/v0/b/fir-76f86.appspot.com/o/users%2FDLwqD1JfNgdlVNETGY0EJ72B8bm1?alt=media&token=9f066b01-0044-4450-aab9-8ac39dec2b05';
    return InkWell(
      onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DetailPage(listItems[i]))),
      child: Stack(
        children: <Widget>[
          Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAlias,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(link),
                      fit: BoxFit.cover)
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: ShadowText(listItems[i].data['name'],style:TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),)
            ),
          )
        ],
      )
    );
  }
}
