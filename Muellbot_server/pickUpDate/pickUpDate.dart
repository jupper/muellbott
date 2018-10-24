import 'dart:io';
import 'dart:core';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

String dbPath = join(dirname(Platform.script.toFilePath()), "pickUpDate/database.db");
DatabaseFactory dbFactory = databaseFactoryIo;

class PickUpDate{

  Future<List<String>> getPickUpDates(String email) async{
    List<String> s = new List();
    Database db = await dbFactory.openDatabase(dbPath);
    Finder finder = new Finder();
    finder.filter = new Filter.equal("email", email);
    List<Record> records = await db.findRecords(finder);
    for (var record in records) {
      s.add(record['date']);
      s.add(record['kind']);
    }
    db.close();
    return s;
  }

  void addPickUpDates(List<String> dates, List<String> kinds, String email) async{
    Database db = await dbFactory.openDatabase(dbPath);
    for (int i =0; i <dates.length;i ++) {
      db.put({'email': email, 'date': dates[i], 'kind': kinds[i]});
    }
    db.close();
  } 
}
