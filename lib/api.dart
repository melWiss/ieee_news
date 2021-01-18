// this file conatains logical instructions to manipulate
// the data stream
// or we can call it api bloc (buisiness logic component)

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class Api {
  Map _initApi = {};
  // DONE: subdivide streamController into apiStreamController and dbStreamController
  StreamController<Map> _apiStreamController =
      StreamController<Map>.broadcast();
  Stream<Map> get apiStream => _apiStreamController.stream;
  StreamSink<Map> get _apiSink => _apiStreamController.sink;
  Map get getCurrentApi => _initApi;

  Api() {
    _apiSink.add(_initApi);
    fetchApi();
  }

  Future<Map> fetchApi() async {
    _apiSink.add(null);
    String url = 'https://newsapi.org/v2/top-headlines?' +
        'country=us&' +
        'apiKey=f599cb8706914e578b866c0d0dc58a4f';
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    //DONE: reformulate data after getting it from the api
    List articles = data['articles'];
    var result = {};
    articles.forEach((element) {
      result.addAll({element["url"]: element});
    });
    _initApi = result;
    _apiSink.add(_initApi);
    return _initApi;
  }

  dispose() {
    _apiStreamController.close();
  }
}

Api api = Api();
