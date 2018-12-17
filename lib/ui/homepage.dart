import 'package:flutter/material.dart';
import 'package:rotaract_app/ui/mainlist.dart';
import 'package:rotaract_app/ui/profile.dart';

class HomePage extends StatefulWidget {
  HomePage({this.onSignedOut});
  final VoidCallback onSignedOut;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Size screenSize(BuildContext context) => MediaQuery.of(context).size;
  final list = List.generate(6, (int i) => 'New Event Title $i');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rotaract Himalayan',
      theme: ThemeData(primaryColor: Colors.red,),
      routes: {
        '/profile' : (context) => MyProfile(onSignedOut: widget.onSignedOut,)
      },
      home: Scaffold(
        appBar: AppBar(
          title: Text('Rotaract'),
          backgroundColor: Colors.red,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                Column(
                  children: <Widget>[
                    //newItems(context),
                    SizedBox(height: 50.0,),
                    options(context)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  newItems(BuildContext context){
    return Container(
      height: screenSize(context).height * .50,
      child: ListView.builder(
          itemCount: list.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int i) => Card(
              child: ListTile(
                title: Text(list[i]),
              ))),
    );
  }

  options(BuildContext context){
    return Container(
      height: screenSize(context).height * .66,
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2),
        children: <Widget>[
          Card(
              child: InkWell(
                onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> MainList('projects'))),
                child: Container(
                    color: Colors.red,
                    child: Center(child: Text('Projects',style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0
                    ),))),
              )),
          Card(
              child: InkWell(
                onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> MainList('committees'))),
                child: Container(
                    color: Colors.red,
                    child: Center(child: Text('Committees',style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0
                    ),))),
              )),
          Card(
              child: InkWell(
                onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> MainList('events'))),
                child: Container(
                    color: Colors.red,
                    child: Center(child: Text('Events',style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0
                    ),))),
              )),
          Card(
              child: InkWell(
                onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MyProfile(onSignedOut: widget.onSignedOut,))),
                child: Container(
                    color: Colors.red,
                    child: Center(child: Text('Profile',style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0
                    ),))))),
        ],
      ),
    );
  }
}
