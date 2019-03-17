import 'package:flutter/material.dart';
import 'package:rotaract_app/core/constants/constants.dart';
import 'package:rotaract_app/core/ui/mainlist.dart';

class Wiki extends StatefulWidget {
  @override
  _WikiState createState() => _WikiState();
}

class _WikiState extends State<Wiki> {
  Widget _generateTitleCard(String title) {
    Expanded(
      child: Stack(
        children: <Widget>[
          Center(
            child: GestureDetector(
              onTap: () => getRoute(context, MainList(title.toLowerCase())),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  semanticContainer: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Image.asset(
                    'images/${title.toLowerCase()}.jpg',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(color: Colors.white, fontSize: 24),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Rotaract Wiki'),
          centerTitle: true,
          backgroundColor: themeColor,
          elevation: 0.0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _generateTitleCard('Projects'),
            _generateTitleCard('Committees'),
            _generateTitleCard('Events'),
          ],
        ));
  }
}
