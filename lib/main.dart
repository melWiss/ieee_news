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
        widget: (data) {
          if (data.containsKey("articles"))
            return ListView.builder(
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
            );
          else
            return Center(
              child: Text("No saved article avaiable"),
            );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
            api.switchData(index);
            print(index);
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
