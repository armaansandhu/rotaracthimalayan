import 'package:flutter/material.dart';
import 'package:rotaract_app/core/constants/constants.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreen();

  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: themeColor,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CircularProgressIndicator(),
              Center(
                child: Text(
                  'Welcome to Rotaract',
                  style: TextStyle(fontSize: 24.0, color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
