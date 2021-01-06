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
  Map _initDb = {};
  // DONE: subdivide streamController into apiStreamController and dbStreamController
  StreamController<Map> _apiStreamController =
      StreamController<Map>.broadcast();
  Stream<Map> get apiStream => _apiStreamController.stream;
  StreamSink<Map> get _apiSink => _apiStreamController.sink;
  Map get getCurrentApi => _initApi;

  StreamController<Map> _dbStreamController = StreamController<Map>.broadcast();
  Stream<Map> get dbStream => _dbStreamController.stream;
  StreamSink<Map> get _dbSink => _dbStreamController.sink;
  Map get getCurrentDb => _initDb;

  String _dbPath = 'articles.json';
  DatabaseFactory _dbFactory = !kIsWeb ? databaseFactoryIo : databaseFactoryWeb;

  Api() {
    _dbSink.add(_initDb);
    _apiSink.add(_initApi);
    fetchApi();
    getData();
  }

  Future<Map> fetchApi() async {
    _apiSink.add(null);
    String url = 'http://newsapi.org/v2/top-headlines?' +
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

  //DONE: add a method to get data from database
  Future<Map> getData() async {
    _dbSink.add(null);
    Database db = await _dbFactory.openDatabase(_dbPath);
    var store = StoreRef.main();
    var data = await store.record("data").get(db) as Map;
    if (data == null) data = {};
    _initDb = data;
    _dbSink.add(_initDb);
    return _initDb;
  }

  //DONE: add a method to add datat to database
  Future<Map> addData(Map data, {bool merge = true}) async {
    Database db = await _dbFactory.openDatabase(_dbPath);
    var store = StoreRef.main();
    await store.record("data").put(db, data, merge: merge);
    return await getData();
  }

  //DONE: add a method to delete data from database
  Future<Map> deleteData(Map data) async {
    Database db = await _dbFactory.openDatabase(_dbPath);
    var store = StoreRef.main();
    var saved = {};
    saved.addAll(await store.record("data").get(db) as Map);
    saved.remove(data.keys.first);
    return await addData(saved, merge: false);
  }

  //DONE: add a data selector method
  ///use other streams instead
  switchData(int index) {
    if (index == 0)
      fetchApi();
    else
      getData();
  }

  dispose() {
    _apiStreamController.close();
    _dbStreamController.close();
  }
}

Api api = Api();
