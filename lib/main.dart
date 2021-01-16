import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ieee_news/api.dart';
import 'package:ieee_news/ui.dart';
import 'fire.dart';
import 'sign.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  var init = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IEEE News',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureWidget<FirebaseApp>(
        future: init,
        widget: (a, b) => StreamBuilder<User>(
          stream: newsFirebase.auth.userChanges(),
          builder: (_, user) {
            if (user.hasData)
              return HomePage();
            else
              return SignInScreen();
          },
        ),
      ),
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
    api.fetchApi();
  }

  @override
  void dispose() {
    //DONE: implement dispose
    super.dispose();
    // api.dispose();
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
        actionsIconTheme: IconThemeData(
          color: Colors.blue,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              newsFirebase.logout();
              // api.dispose();
            },
          ),
        ],
      ),
      body: PageView(
        onPageChanged: (i) {
          setState(() {
            index = i;
            // api.switchData(index);
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
                      var d = data[data.keys.toList()[index]];
                      // var d = {
                      //   data.keys.toList()[index]:
                      //       data[data.keys.toList()[index]],
                      // };
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
          StreamWidget<QuerySnapshot>(
            // stream: api.dbStream,
            stream: newsFirebase.streamUserArticles().snapshots(),
            widget: (context, data) {
              if (data.size > 0) {
                return ListView.builder(
                    itemCount: data.size,
                    itemBuilder: (context, index) {
                      var d = data.docs[index].data();
                      return NewsCard(
                        details: d["content"] != null ? d["content"] : "",
                        title: d["title"] != null ? d["title"] : "",
                        imageUrl:
                            d["urlToImage"] != null ? d["urlToImage"] : "",
                        url: d["url"] != null ? d["url"] : "",
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
          api.fetchApi();
          setState(() {
            index = value;
            // api.switchData(index);
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
