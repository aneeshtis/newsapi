import 'dart:io';

import 'package:flutter/material.dart';
import 'package:newsapi/data/newsapi.dart';
import 'package:newsapi/model/news_headlines.dart';
import 'package:newsapi/view/news_details.dart';
import 'package:newsapi/widget/no_internet.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  bool _showNoInternet = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    _checkInternet();
  }

  _checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          _showNoInternet = false;
        });
      }
    } on SocketException catch (_) {
      print(_);
      setState(() {
        _showNoInternet = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: choices.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'News Stack',
              style: TextStyle(fontSize: 24.0),
            ),
            bottom: TabBar(
                isScrollable: true,
                tabs: choices.map((Choice choice) {
                  return Tab(
                    text: choice.title,
                  );
                }).toList()),
            centerTitle: true,
            elevation: 0.0,
          ),
          body: TabBarView(
            children: choices.map((Choice choice) {
              return Padding(
                padding: const EdgeInsets.only(top: 18),
                child: _showNoInternet == false
                    ? Container(
                        child: FutureBuilder(
                          future:
                              NewsData().getNews(1, choice.title.toLowerCase()),
                          builder: (BuildContext context, AsyncSnapshot s) {
                            if (s.data == null) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else
                              return new NewsList(
                                headlines: s.data,
                              );
                          },
                        ),
                      )
                    : Container(
                        child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              _checkInternet();
                            },
                            child: NoInternet(
                                MediaQuery.of(context).size.height - 200)),
                      ),
              );
            }).toList(),
          ),
        ));
  }
}

class NewsList extends StatefulWidget {
  final NewsHeadlines headlines;
  const NewsList({
    this.headlines,
    Key key,
  }) : super(key: key);

  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  ScrollController scrollController = new ScrollController();
  List<Article> article;
  int currentPage = 1;

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        print('Scroll Bottom');
        setState(() {
          currentPage = currentPage + 1;
        });
        final index = DefaultTabController.of(context).index;
        String cat = choices[index].title;
        print(cat);
        NewsData().getNews(currentPage, cat).then((val) {
          setState(() {
            article.addAll(val.articles);
          });
        });
      }
    }
    return true;
  }

  @override
  void initState() {
    article = widget.headlines.articles;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: onNotification,
      child: ListView.builder(
          itemCount: article.length,
          controller: scrollController,
          itemBuilder: (BuildContext c, int i) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewsDetails(
                            article[i].title,
                            article[i].urlToImage,
                            article[i].description,
                            article[i].url)));
              },
              child: Container(
                  margin: EdgeInsets.only(bottom: 24),
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.bottomCenter,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(6),
                              bottomLeft: Radius.circular(6))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: article[i].urlToImage != null
                                  ? FadeInImage.assetNetwork(
                                      placeholder: 'assets/images/ldr.gif',
                                      image: article[i].urlToImage,
                                      height: 200,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                    )
                                  : Image(
                                      image: AssetImage('assets/images/bg.png'),
                                      fit: BoxFit.cover,
                                    )),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            article[i].title != null ? article[i].title : '',
                            maxLines: 3,
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 22,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            article[i].description != null
                                ? article[i].description
                                : '',
                            maxLines: 2,
                            style:
                                TextStyle(color: Colors.black54, fontSize: 17),
                          )
                        ],
                      ),
                    ),
                  )),
            );
          }),
    );
  }
}

class Choice {
  const Choice({this.title});

  final String title;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'General'),
  const Choice(title: 'Business'),
  const Choice(title: 'Entertainment'),
  const Choice(title: 'Health'),
  const Choice(title: 'Science'),
  const Choice(title: 'Sports'),
  const Choice(title: 'Technology'),
];
