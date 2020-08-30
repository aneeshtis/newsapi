import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NoInternet extends StatelessWidget {
  final double height;
  NoInternet(this.height);
  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.white,
      child: new Container(
        height: height,
        //color: Colors.white,
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                "assets/images/noInternet.png",
                width: 100,
                color: Colors.black26,
              ),
              SizedBox(
                height: 20,
              ),
              new Text(
                "No Internet",
                style: new TextStyle(
                    color: Colors.black26, fontFamily: 'Fitfont', fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              new Text(
                "Please enable wifi or data",
                style: new TextStyle(
                    color: Colors.black26, fontFamily: 'Fitfont', fontSize: 17),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
