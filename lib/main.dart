import 'package:flutter/material.dart';
import 'package:rotaract_app/utils/auth.dart';
import 'package:rotaract_app/utils/authprovider.dart';
import 'package:rotaract_app/ui/root.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: RootPage(),
      ),
    );
  }
}