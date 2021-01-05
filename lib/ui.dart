import 'package:flutter/material.dart';

class StreamWidget<T> extends StatelessWidget {
  final Stream<T> stream;
  final Function(T snap) widget;
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
          return widget(snapshot.data);
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
  final Function(T snap) widget;
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
          return widget(snapshot.data);
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
