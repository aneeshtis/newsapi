import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:newsapi/model/news_headlines.dart';

class NewsData {
  Future<NewsHeadlines> getNews(int currentPage, String category) async {
    print("Current Page:" + currentPage.toString());
    var url =
        'https://newsapi.org/v2/top-headlines?country=in&apiKey=6f83b845f92545ac8b87da65966d4156&pageSize=5&page=' +
            currentPage.toString() +
            '&category=' +
            category;
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print('Get Data');
      print(response.body);
      return NewsHeadlines.fromJson(json.decode(response.body));
    } else {
      throw Exception('Faild to load');
    }
  }
}
