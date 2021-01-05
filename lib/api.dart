// this file conatains logical instructions to manipulate
// the data stream
// or we can call it api bloc (buisiness logic component)

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class Api {
  Map init = {};
  StreamController<Map> _streamController = StreamController<Map>();
  Stream<Map> get apiStream => _streamController.stream;
  StreamSink<Map> get _apiSink => _streamController.sink;

  String _dbPath = 'articles.db';
  DatabaseFactory _dbFactory = databaseFactoryIo;

  Api() {
    _apiSink.add(init);
    _fetchApi();
  }

  Future<Map> _fetchApi() async {
    String url = 'http://newsapi.org/v2/top-headlines?' +
        'country=us&' +
        'apiKey=f599cb8706914e578b866c0d0dc58a4f';
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    _apiSink.add(data);
    return data;
  }

  //TODO: add a method to get data from database
  Future<Map> _getData() async {
    Database db = await _dbFactory.openDatabase(_dbPath);
    var store = StoreRef.main();
    var data = await store.record("data").get(db) as Map;
    if (data == null) data = {};
    _apiSink.add(data);
    return data;
  }

  //TODO: add a method to add datat to database
  Future addData(Map data) async {
    Database db = await _dbFactory.openDatabase(_dbPath);
    var store = StoreRef.main();
    await store.record("data").put(db, data);
  }

  //TODO: add a data selector method
  switchData(int index) {
    if (index == 0)
      _fetchApi();
    else
      _getData();
  }
}
