import 'package:http/browser_client.dart';
import 'dart:async';
import 'dart:convert';

import '../model/user.dart';
import '../model/pickup_date.dart';

class LogInService {
  User user;

  User getUser() => this.user;

  void setUser(User user) {
    this.user = user;
  }

  void logOut() {
    user = null;
  }

  Future<bool> logIn(String email, String password) async{

    final _headers = {'Content-Type': 'application/json'};
    var client = new BrowserClient();
    var url = "http://localhost:4040/user/login";

    try {
      var response = await client.post(url, headers: _headers, body: json.encode({'email': email, 'password': password}));
      if (response.statusCode == 200) {
        url = "http://localhost:4040/user/get";
        response = await client.post(url, headers: _headers, body: json.encode({'email': email}));
        if (response.body != null) {
          Map _json = json.decode(response.body);
          user = new User(_json['firstName'], _json['lastName'], email);
          url = "http://localhost:4040/pickUpDate/get";
          response = await client.post(url, headers: _headers, body: json.encode({'email': email}));
          if(response.body != null) {
            this.parseDates(response.body);
          }
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }

  }
  void parseDates(String s) {
    if (s.length == 2) {
      return;
    }
    int counter = 1;
    String date, kind;
    while (counter < s.length) {
      for(int i = counter; i < s.length; i++) {
        if(s.substring(i, i + 1) == ',') {
          date = s.substring(counter, i);
          counter = i + 2;
          break;
        }
      }
      for(int i = counter; i < s.length; i++) {
        if(s.substring(i, i + 1) == ',' || s.substring(i) == ']') {
          kind = s.substring(counter, i);
          counter = i + 2;
          break;
        }
      }
      PickUpDate pickUpDate = new PickUpDate(DateTime.parse(date), kind);
      user.addPickUpDate(pickUpDate);
    }
  }
}