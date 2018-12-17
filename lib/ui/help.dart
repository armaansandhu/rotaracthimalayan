import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: 200.0,),


          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: <Widget>[
                  Center(child: Text('PLAY QUEUE'),),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text('CLEAR'),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
