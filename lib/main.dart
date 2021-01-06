import 'package:flutter/material.dart';
import 'package:ieee_news/api.dart';
import 'package:ieee_news/ui.dart';

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
  PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: index);
  }

  @override
  void dispose() {
    //DONE: implement dispose
    super.dispose();
    api.dispose();
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
      body: PageView(
        onPageChanged: (i) {
          setState(() {
            index = i;
            api.switchData(index);
          });
        },
        controller: pageController,
        children: [
          StreamWidget<Map>(
            stream: api.apiStream,
            widget: (context, data) {
              if (data.isNotEmpty) {
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var d = {
                        data.keys.toList()[index]:
                            data[data.keys.toList()[index]],
                      };
                      return NewsCard(
                        details:
                            data[data.keys.toList()[index]]["content"] != null
                                ? data[data.keys.toList()[index]]["content"]
                                : "",
                        title: data[data.keys.toList()[index]]["title"] != null
                            ? data[data.keys.toList()[index]]["title"]
                            : "",
                        imageUrl: data[data.keys.toList()[index]]
                                    ["urlToImage"] !=
                                null
                            ? data[data.keys.toList()[index]]["urlToImage"]
                            : "",
                        url: data[data.keys.toList()[index]]["url"] != null
                            ? data[data.keys.toList()[index]]["url"]
                            : "",
                        data: d,
                      );
                    });
              } else
                return Center(
                  child: Text("No articles avaiable"),
                );
            },
          ),
          StreamWidget<Map>(
            stream: api.dbStream,
            widget: (context, data) {
              if (data.isNotEmpty) {
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var d = {
                        data.keys.toList()[index]:
                            data[data.keys.toList()[index]],
                      };
                      return NewsCard(
                        details:
                            data[data.keys.toList()[index]]["content"] != null
                                ? data[data.keys.toList()[index]]["content"]
                                : "",
                        title: data[data.keys.toList()[index]]["title"] != null
                            ? data[data.keys.toList()[index]]["title"]
                            : "",
                        imageUrl: data[data.keys.toList()[index]]
                                    ["urlToImage"] !=
                                null
                            ? data[data.keys.toList()[index]]["urlToImage"]
                            : "",
                        url: data[data.keys.toList()[index]]["url"] != null
                            ? data[data.keys.toList()[index]]["url"]
                            : "",
                        data: d,
                      );
                    });
              } else
                return Center(
                  child: Text("No saved article avaiable"),
                );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
            api.switchData(index);
            pageController.animateToPage(index,
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOutExpo);
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
