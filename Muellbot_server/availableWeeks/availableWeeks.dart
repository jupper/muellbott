import 'dart:io';
import 'dart:core';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

String dbPath = join(dirname(Platform.script.toFilePath()), "availableWeeks/database.db");
DatabaseFactory dbFactory = databaseFactoryIo;

class AvailableWeeks {
  Future<List<String>> getWeeks() async{
    List<String> list = new List();
    Database db = await dbFactory.openDatabase(dbPath);
    Finder finder = new Finder();
    List<Record> records = await db.findRecords(finder);
    for (var record in records) {
      if (record['start'] != null) {
        list.add(record['start']);
      }
    }
    for (var record in records) {
      if (record['kw'] != null) {
        list.add(record['kw']);
      }
    }
    db.close();
    return list;
  }

  Future<bool> deleteWeeks() async{
    Database db = await dbFactory.openDatabase(dbPath);
    Finder finder = new Finder();
    List<Record> records = await db.findRecords(finder);
    for (var record in records) {
      await db.deleteRecord(record);
    }
    db.close();
    return true;
  }

  void addWeeks(List<String> list, DateTime date) async{
    if(await this.deleteWeeks()) {
      Database db = await dbFactory.openDatabase(dbPath);
      for (int i = 0; i < list.length; i++) {
        await db.put({'kw': list[i]});
      }
      await db.put({'start': date.toString()});
      db.close;
    }
  }
}
