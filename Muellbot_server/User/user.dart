import 'dart:io';
import 'dart:core';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:crypt/crypt.dart';

String dbPath = join(dirname(Platform.script.toFilePath()), "User/database.db");
DatabaseFactory dbFactory = databaseFactoryIo;

class User {
  String firstName, lastName, email, password;

  User() {}

  User.named(this.firstName, this.lastName, this.email);

  String getFirstName() {
    return this.firstName;
  }

  String getLastName() {
    return this.lastName;
  }

  String getEmail() {
    return this.email;
  }

  void setFirstName(String firstName) {
    this.firstName = firstName;
  }

  void setLastName(String lastName) {
    this.lastName = lastName;
  }

  void setEmail(String email) {
    this.email = email;
  }

  void setPassword(String password) {
    this.password = password;
  }

  Future<Record> getRecord(String email) async{
    Database db = await dbFactory.openDatabase(dbPath);
    Finder finder = new Finder();
    finder.filter = new Filter.equal("email", email);
    return await db.findRecord(finder);
  }

  Future<bool> createUser(String firstName, String lastName, String email, String password, String mode) async {
    Record record = await this.getRecord(email);
    if (record != null) {
      return false;
    }
    Database db = await dbFactory.openDatabase(dbPath);
    if(mode == "n") {
      db.put({"firstName": firstName, "lastName": lastName, "email": email, "password": new Crypt.sha256(password).toString()});
    } else {
      db.put({"firstName": firstName, "lastName": lastName, "email": email, "password": password});
    }
    db.close();
    return true;
  }

  Future<User> getUser(String email) async{
    Record record = await this.getRecord(email);
    if (record == null) {
      return new User();
    } else {
      return new User.named(record['firstName'], record['lastName'], record['email']);
    }
  }

  Future<bool> deleteUser(String email) async{
    Record record = await this.getRecord(email);
    if (record == null) {
      return false;
    } else {
      Database db = await dbFactory.openDatabase(dbPath);
      db.deleteRecord(record);
      db.close();
      return true;
    }
  }

  Future<User> changeUser(String firstName, String lastName, String email) async {
    Record record = await this.getRecord(email);
    if (record == null) {
      return new User();
    } else {
        if (await this.deleteUser(email)) {
          this.createUser(firstName, lastName, email, record['password'], "c");
      }
      return this.getUser(email);
    }
  }

  Future<bool> logInUser(String email, String password) async{
    Record record = await this.getRecord(email);
    if (record == null) {
      return false;
    } else if (new Crypt(record['password']).match(password)){
      return true;
    } else {
      return false;
    }
  }

  Future<bool> changePasswort(String email, String newPassword) async{
    Record record = await this.getRecord(email);
    if (record == null) {
      return false;
    } else {
      User user = await getUser(email);
      if (await this.deleteUser(email)) {
        this.createUser(user.getFirstName(), user.getLastName(), user.getEmail(), new Crypt.sha256(newPassword).toString(), "c");
      }
      return true;
    }
  }

  Future<bool> changeEmail(String oldEmail, String newEmail) async{
    Record record = await this.getRecord(oldEmail);
    if (record == null) {
      return false;
    } else {
      User user = await this.getUser(oldEmail);
      if (await this.deleteUser(oldEmail)) {
        this.createUser(user.getFirstName(), user.getLastName(), newEmail, record['password'], "c");
      }
      return true;
    }
  }

  Future<List> getAllMails() async{
    List list = new List();
    Database db = await dbFactory.openDatabase(dbPath);
    Finder finder = new Finder();
    List<Record> records = await db.findRecords(finder);
    records.forEach((record) => list.add(record['email']));
    db.close();
    return list;
  }

}
