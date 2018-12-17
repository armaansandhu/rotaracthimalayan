import 'package:flutter/material.dart';
import 'package:rotaract_app/ui/detailpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainList extends StatelessWidget {
  final String title;
  MainList(this.title);
  final firestore = Firestore.instance;
  List<DocumentSnapshot> listItems;

  _getList() async{
    await firestore.collection('committees').getDocuments().then((snapshot){
      listItems = snapshot.documents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body: FutureBuilder(
          future: _getList(),
          builder: (BuildContext context,AsyncSnapshot snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemCount: listItems.length,
                  itemBuilder: (BuildContext context, int i) => _buildList(context,i));
            } else{
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Size screenSize(BuildContext context) => MediaQuery.of(context).size;

  _appBar(){
    return AppBar(
      title: Text('${title[0].toUpperCase()}${title.substring(1)}'),
      centerTitle: true,
      backgroundColor: Colors.red,
    );
  }

  _buildList(BuildContext context, int i) {
    final link = 'https://images.pexels.com/photos/36753/flower-purple-lical-blosso.jpg?cs=srgb&dl=bloom-blooming-blossom-36753.jpg&fm=jpg';
    return InkWell(
      onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DetailPage(listItems[i]))),
      child: Container(
          child: Card(
            child: Column(
              children: <Widget>[
                Container(
                  height: screenSize(context).height*.2,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(link),
                          fit: BoxFit.cover)
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 9.0),
                  child: Text(listItems[i].data['name'],style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                  ),),
                )
              ],
            ),
          )
      ),
    );
  }
}
