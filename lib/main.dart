import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
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
  String url = 'http://newsapi.org/v2/top-headlines?' +
      'country=us&' +
      'apiKey=f599cb8706914e578b866c0d0dc58a4f';

  Future<Map> fetchApi() async {
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    return data;
  }

  @override
  void initState() {
    super.initState();
    //fetchApi().then((value) => print(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hello World",
          style: TextStyle(color: Colors.blue),
        ),
        elevation: 2,
        backgroundColor: Colors.white,
        leading: Icon(
          Icons.account_box,
          color: Colors.blue,
        ),
      ),
      body: FutureBuilder<Map>(
        future: fetchApi(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snap.data['totalResults'],
              itemBuilder: (context, index) {
                return NewsCard(
                  details: snap.data["articles"][index]["content"] != null
                      ? snap.data["articles"][index]["content"]
                      : "",
                  title: snap.data["articles"][index]["title"] != null
                      ? snap.data["articles"][index]["title"]
                      : "",
                  imageUrl: snap.data["articles"][index]["urlToImage"] != null
                      ? snap.data["articles"][index]["urlToImage"]
                      : "",
                  url: snap.data["articles"][index]["url"] != null
                      ? snap.data["articles"][index]["url"]
                      : "",
                );
              },
            );
          } else
            return Center(child: CircularProgressIndicator());
        },
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
