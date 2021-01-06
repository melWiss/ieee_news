// this file contains two widgets (SteamWidget & FutureWidget)
// that I frequently use to speed up my work
// and some other UI widgets

import 'package:flutter/material.dart';

import 'art_details.dart';

class StreamWidget<T> extends StatelessWidget {
  final Stream<T> stream;
  final Widget Function(BuildContext context, T data) widget;
  const StreamWidget({
    this.stream,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return widget(context, snapshot.data);
        else if (snapshot.hasError)
          return Center(
            child: Text("Error while loading data:\n${snapshot.error}"),
          );
        else
          return Center(
            child: CircularProgressIndicator(),
          );
      },
    );
  }
}

class FutureWidget<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(BuildContext context, T data) widget;
  const FutureWidget({
    this.future,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return widget(context, snapshot.data);
        else if (snapshot.hasError)
          return Center(
            child: Text("Error while loading data:\n${snapshot.error}"),
          );
        else
          return Center(
            child: CircularProgressIndicator(),
          );
      },
    );
  }
}

class NewsCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String details;
  final String url;
  final Map data;
  NewsCard({
    this.title = "",
    this.imageUrl = "",
    this.details = "",
    this.url = "",
    @required this.data,
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
              data: data,
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
