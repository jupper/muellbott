import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:Muellbot/src/route_paths.dart';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:http/browser_client.dart';

import '../model/user.dart';
import '../services/log_in_service.dart';


@Component(
  selector: 'my_data',
  templateUrl: 'my_data_component.html',
  styleUrls: ['my_data_component.css'],
  directives: [coreDirectives, formDirectives],
)

class MyDataComponent {
  User user;
  MyDataComponent(LogInService logInService) : user = logInService.getUser();
  static final _headers = {'Content-Type': 'application/json'};
  var client = new BrowserClient();
  String url;
  bool data = true, email = false, password = false, sent = false, success = false;


  void setData() {
    data = true;
    email = false;
    password = false;
  }

  void setEmail() {
    email = true;
    data = false;
    password = false;
  }

  void setPassword() {
    password = true;
    email = false;
    data = false;
  }

  void change(String firstName, String lastName) async{
    if(firstName == "" || lastName == "" || (firstName == user.getFirstName() && lastName == user.getLastName())) {
      this.cancel();
    }
    url = "http://localhost:4040/user/change";
    try {
      final response = await client.post(url, headers: _headers, body: json.encode({'firstName': firstName, 'lastName': lastName, 'email': user.getEmail()}));
      sent = true;
      if (response.statusCode == 200) {
        user.setLastName(lastName);
        user.setFirstName(firstName);
        success = true;
        await Future.delayed(const Duration(seconds: 1), () => "1");
        window.location.assign('#' + RoutePaths.home.toUrl());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void changeP(String newPassword, String newPasswordRe) async{
    if(newPassword != newPasswordRe) {
      sent = true;
      success = false;
      return;
    } else if(newPassword == "") {
      this.cancel();
    }
    url = "http://localhost:4040/user/changeP";
    try {
      final response = await client.post(url, headers: _headers, body: json.encode({'email': user.getEmail(), 'newPassword': newPassword}));
      sent = true;
      if (response.statusCode == 200) {
        success = true;
        await Future.delayed(const Duration(seconds: 1), () => "1");
        window.location.assign('#' + RoutePaths.home.toUrl());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void changeE(String newEmail) async{
    url = "http://localhost:4040/user/changeE";
    if(newEmail == user.email) {
      this.cancel();
    } else if (newEmail == "") {
      sent = true;
      success = false;
    }
    try {
      final response = await client.post(url, headers: _headers, body: json.encode({'newEmail': newEmail ,'oldEmail': user.getEmail()}));
      sent = true;
      if (response.statusCode == 200) {
        success = true;
        user.setEmail(newEmail);
        await Future.delayed(const Duration(seconds: 1), () => "1");
        window.location.assign('#' + RoutePaths.home.toUrl());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void cancel() {
    window.location.assign('#' + RoutePaths.home.toUrl());
  }

}