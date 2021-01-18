import 'package:flutter/material.dart';
import 'package:ieee_news/api.dart';
import 'package:ieee_news/fire.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ui.dart';

class NewsDetail extends StatelessWidget {
  final String title;
  final String details;
  final String imageUrl;
  final String url;
  final Map data;
  NewsDetail({
    this.details,
    this.imageUrl,
    this.title,
    this.url,
    @required this.data,
  });
  @override
  Widget build(BuildContext context) {
    print(data);
    return Scaffold(
      appBar: AppBar(
        //DONE: add a button to save the current article
        actions: [
          StreamWidget<bool>(
            stream: firebaseFunctions.existOrNot(url),
            widget: (context, exist) {
              if (exist) {
                return IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () {},
                );
              } else {
                return IconButton(
                  icon: Icon(Icons.save_outlined),
                  onPressed: () {
                    firebaseFunctions.saveArticle(data[url]);
                  },
                );
              }
            },
          ),
        ],
        title: Text(
          title,
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              child: Image.network(imageUrl),
              borderRadius: BorderRadius.circular(20),
              elevation: 5,
              clipBehavior: Clip.antiAlias,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(details),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              onPressed: () {
                launch(url);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.pink,
                  ),
                  Text(
                    "Read the article",
                    style: TextStyle(
                      color: Colors.pink,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
