import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:ieee_news/api.dart';
import 'package:ieee_news/ui.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IEEE News',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  Api api;

  @override
  void initState() {
    super.initState();
    api = Api();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "IEEE News",
          style: TextStyle(color: Colors.blue),
        ),
        elevation: 2,
        backgroundColor: Colors.white,
        leading: Icon(
          Icons.account_box,
          color: Colors.blue,
        ),
      ),
      body: StreamWidget<Map>(
        stream: api.apiStream,
        widget: (data) => ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) => NewsCard(
            details: data["articles"][index]["content"] != null
                ? data["articles"][index]["content"]
                : "",
            title: data["articles"][index]["title"] != null
                ? data["articles"][index]["title"]
                : "",
            imageUrl: data["articles"][index]["urlToImage"] != null
                ? data["articles"][index]["urlToImage"]
                : "",
            url: data["articles"][index]["url"] != null
                ? data["articles"][index]["url"]
                : "",
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.assignment,
            ),
            label: "News",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.save,
            ),
            label: "Saved",
          ),
        ],
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String details;
  final String url;
  NewsCard({
    this.title = "",
    this.imageUrl = "",
    this.details = "",
    this.url = "",
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return NewsDetail(
              title: title,
              imageUrl: imageUrl,
              details: details,
              url: url,
            );
          }));
        },
        child: Material(
            elevation: 5,
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Image.network(imageUrl),
                      Positioned(
                        left: 5,
                        bottom: 5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            color: Colors.pink,
                            padding: EdgeInsets.all(5),
                            child: Text(
                              title,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        details,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class NewsDetail extends StatelessWidget {
  final String title;
  final String details;
  final String imageUrl;
  final String url;
  NewsDetail({this.details, this.imageUrl, this.title, this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
