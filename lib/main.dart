import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ieee_news/api.dart';
import 'package:ieee_news/fire.dart';
import 'package:ieee_news/signin.dart';
import 'package:ieee_news/ui.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IEEE News',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error),
            );
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder<User>(
              stream: firebaseFunctions.auth.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return HomePage();
                else
                  return SignIn();
              },
            );
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Center(
            child: CircularProgressIndicator(),
          );
        },
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
