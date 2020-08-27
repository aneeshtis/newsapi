import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetails extends StatefulWidget {
  final String title;
  final String imgUrl;
  final String decription;
  final String url;

  const NewsDetails(this.title, this.imgUrl, this.decription, this.url);
  @override
  _NewsDetailsState createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: SingleChildScrollView(
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height,
                    ),
                    child: Column(
                      children: <Widget>[dataView()],
                    ))),
          )
        ],
      ),
    );
  }

  Widget dataView() {
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              widget.imgUrl != null
                  ? Container(
                      //check if file exists
                      child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/ldr.gif',
                      image: widget.imgUrl,
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ))
                  : Container(
                      child: Image(
                        image: AssetImage('assets/images/bg.png'),
                        fit: BoxFit.cover,
                      ),
                      height: 250,
                    ),
              Container(
                padding: EdgeInsets.only(top: 30, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.black.withOpacity(0.3)),
                        child: IconButton(
                            icon: Icon(Icons.open_in_browser,
                                color: Colors.white),
                            onPressed: () {
                              _launchURL(widget.url);
                            }))
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 200, left: 40),
                      child: Card(
                        elevation: 5.0,
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: IconButton(
                                      icon: Icon(Platform.isIOS
                                          ? Icons.arrow_back_ios
                                          : Icons.arrow_back),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 12,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          top: 10, right: 5, bottom: 10),
                                      child: Text(widget.title,
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: getTitleContainer("News Details"),
                          flex: 10,
                        ),
                      ],
                    ),
                    //New Decription
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Card(
                              child: Container(
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12, left: 12.0, bottom: 10.0),
                                    child: Text(widget.decription,
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500))),
                              ),
                            ))),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  getTitleContainer(String title) {
    return Container(
      padding: EdgeInsets.only(left: 20.0),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Text(
                title,
                style: TextStyle(fontSize: 20),
              )),
          Expanded(
            flex: 1,
            child: FlatButton(
                textColor: Colors.red, onPressed: () {}, child: Text("")),
          ),
        ],
      ),
    );
  }

  _launchURL(String url) async {
    String uri = Uri.encodeFull(url);
    if (await canLaunch(uri)) {
      await launch(url);
    } else {
      throw 'Could not launch $uri';
    }
  }
}
