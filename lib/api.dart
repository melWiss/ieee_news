//this file conatains logical instructions to manipulate
//the data stream

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  Map init = {};
  StreamController<Map> _streamController = StreamController<Map>();
  Stream<Map> get apiStream => _streamController.stream;
  StreamSink<Map> get _apiSink => _streamController.sink;
  Api() {
    _apiSink.add(init);
    fetchApi().then((value) => _apiSink.add(value));
  }

  Future<Map> fetchApi() async {
    String url = 'http://newsapi.org/v2/top-headlines?' +
        'country=us&' +
        'apiKey=f599cb8706914e578b866c0d0dc58a4f';
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    return data;
  }
}
