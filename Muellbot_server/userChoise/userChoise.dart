import 'dart:io';
import 'dart:core';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

String dbPath = join(dirname(Platform.script.toFilePath()), "userChoise/database.db");
DatabaseFactory dbFactory = databaseFactoryIo;

class UserChoise {
  Future<bool> setWeeks(String email, List<String> list) async{
    Database db = await dbFactory.openDatabase(dbPath);
    Finder finder = new Finder();
    finder.filter = new Filter.equal("email", email);
    List<Record> records = await db.findRecords(finder);
    if(records != null) {
      for (var record in records) {
        db.deleteRecord(record);
      }
    }
    for (var week in list) {
      db.put({'email': email, 'kw': week});
    }
    db.close();
    return true;
  }

  Future<List<String>> getWeeks(String email) async{
    Database db = await dbFactory.openDatabase(dbPath);
    Finder finder = new Finder();
    finder.filter = new Filter.equal("email", email);
    List<Record> records = await db.findRecords(finder);
    List<String> list = new List();
    for (var record in records) {
      list.add(record['kw']);
    }
    return list;
  }
}
