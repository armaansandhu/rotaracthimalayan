import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Color themeColor = const Color(0xff9d030b);

//Standardized Input decoration for all app.
inputDecoration({label, hint, icon}) {
  return InputDecoration(
      contentPadding: EdgeInsets.all(16.0),
      labelText: label,
      hintText: hint,
      icon: Icon(icon));
}

//Function to implement Material Route
getRoute(BuildContext context, Widget page, {fullscreen}) {
  return Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => page,
          fullscreenDialog: fullscreen == null ? false : fullscreen));
}

//Creates animated placeholder for listviews.
listPlaceholder(BuildContext context) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300],
    highlightColor: Colors.grey[100],
    child: Column(
      children: [0, 1, 2, 3]
          .map((_) => Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        height: 20.0,
                        width: MediaQuery.of(context).size.width * .4,
                        decoration: new BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                new BorderRadius.all(Radius.circular(30.0))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        height: 20.0,
                        width: MediaQuery.of(context).size.width * .7,
                        decoration: new BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                new BorderRadius.all(Radius.circular(30.0))),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    ),
  );
}
