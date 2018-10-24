import 'dart:io';
import 'dart:core';
import 'dart:convert';


import 'User/user.dart';
import 'pickUpDate/pickUpDate.dart';
import 'availableWeeks/availableWeeks.dart';
import 'userChoise/userChoise.dart';

main() async {
  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 4040);
  print('Listening on localhost:${server.port}');

  await for (var request in server) {
    request.response.headers.add("Access-Control-Allow-Origin", "http://localhost:37147");
    request.response.headers.add("Access-Control-Allow-Methods", "POST, OPTIONS");
    request.response.headers.add('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, X-Custom-Header');
    handleRequest(request);
  }

}

void handleRequest(HttpRequest request) {
  try {
    if (request.method == 'POST') {
      handle(request);
    } else if (request.method == 'OPTIONS'){
      HttpResponse res = request.response;
      res.statusCode = HttpStatus.noContent;
      res.close();
    } else {
      request.response
        ..statusCode = HttpStatus.methodNotAllowed
        ..write('Unsupported request: ${request.method}.')
        ..close();
    }
  } catch (e) {
    throw new Exception(e);
  }
}

void handle(HttpRequest request) {
  if (request.uri.pathSegments[0] == "user") {
    handleUser(request);
  } else if(request.uri.pathSegments[0] == "pickUpDate") {
    handleDate(request);
  } else if(request.uri.pathSegments[0] == "availableWeeks") {
    handleAvailable(request);
  } else if(request.uri.pathSegments[0] == "setAvailableWeeks") {
    setAvailableWeeks(request);
  }
}

void handleUser(HttpRequest request) async {
  String content = await request.transform(utf8.decoder).join();

  User user = new User();
  switch(request.uri.pathSegments[1]) {
      case 'new':
        Map _json = json.decode(content);
        if (await user.createUser(_json['firstName'], _json['lastName'], _json['email'], _json['password'], "n")) {
          request.response..statusCode = HttpStatus.ok..close();
        } else {
          request.response..statusCode = HttpStatus.noContent..close();
        }
        break;
      case 'delete':
        Map _json = json.decode(content);
        if(await user.deleteUser(_json['email'])) {
          request.response..statusCode = HttpStatus.ok..close();
        } else {
          request.response..statusCode = HttpStatus.noContent..close();
        }
        break;
      case 'change':
        Map _json = json.decode(content);
        user = await user.changeUser(_json['firstName'], _json['lastName'], _json['email']);
        if (user != null) {
          request.response.headers.contentType = new ContentType("application", "json", charset: "utf-8");
          request.response..write(json.encode({'firstName': user.getFirstName(), 'lastName': user.getLastName(), 'email': user.getEmail()}))..close();
        } else {
          request.response..statusCode = HttpStatus.noContent..close();
        }
        break;
      case 'get':
        Map _json = json.decode(content);
        user = await user.getUser(_json['email']);
        if (user != null) {
          request.response.headers.contentType = new ContentType("application", "json", charset: "utf-8");
          request.response..write(json.encode({'firstName': user.getFirstName(), 'lastName': user.getLastName(), 'email': user.getEmail()}))..close();
        } else {
          request.response..statusCode = HttpStatus.noContent..close();
        }
        break;
      case 'login':
        Map _json = json.decode(content);
        if(await user.logInUser(_json['email'], _json['password'])) {
          request.response..statusCode = HttpStatus.ok..close();
        } else {
          request.response..statusCode = HttpStatus.unauthorized..close();
        }
        break;
      case 'changeP':
        Map _json = json.decode(content);
        if (await user.changePasswort(_json['email'], _json['newPassword'])) {
          request.response..statusCode = HttpStatus.ok..close();
        } else {
          request.response..statusCode = HttpStatus.unauthorized..close();
        }
        break;
      case 'changeE':
        Map _json = json.decode(content);
        if (await user.changeEmail(_json['oldEmail'], _json['newEmail'])) {
          request.response..statusCode = HttpStatus.ok..close();
        } else {
          request.response..statusCode = HttpStatus.unauthorized..close();
        }
        break;
      case 'getAll':
        List list = await user.getAllMails();
        request.response.headers.contentType = new ContentType("application", "json", charset: "utf-8");
        request.response..write(list)..close();
        break;
  }
}

void handleDate(HttpRequest request) async {
  String content = await request.transform(utf8.decoder).join();
  Map _json = json.decode(content);
  PickUpDate pickUpDate = new PickUpDate();
  switch(request.uri.pathSegments[1]) {
    case 'add':
      break;
    case 'get':
      List<String> list = await pickUpDate.getPickUpDates(_json['email']);
      request.response.headers.contentType = new ContentType("application", "json", charset: "utf-8");
      request.response..write(list)..close();
      break;
  }
}

void handleAvailable(HttpRequest request) async{
  AvailableWeeks availableWeeks = new AvailableWeeks();
  List<String> list = await availableWeeks.getWeeks();
  request.response.headers.contentType = new ContentType("application", "json", charset: "utf-8");
  request.response..write(list)..close();
}

void setAvailableWeeks(HttpRequest request) async{
  String content = await request.transform(utf8.decoder).join();
  Map _json = json.decode(content);
  UserChoise userChoise = new UserChoise();
  List<String> list = _json['weeks'].toString().substring(1, _json['weeks'].toString().length - 1) .split(",");
  if( await userChoise.setWeeks(_json['email'], list)) {
    request.response..statusCode = HttpStatus.ok..close();
  }
}
