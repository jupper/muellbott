import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:Muellbot/src/model/user.dart';
import 'package:Muellbot/src/route_paths.dart';
import 'package:Muellbot/src/services/log_in_service.dart';
import 'package:http/browser_client.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular/angular.dart';


@Component(
  selector: 'new-user',
  templateUrl: 'new_user_component.html',
  styleUrls: ['new_user_component.css'],
  directives: [coreDirectives, formDirectives],
)

class NewUserComponent extends OnInit{
  List<String> emailAddresses = new List();
  bool created = false, success = false, buttonDis = true, passNotCorrect = false, userExist = false, inputEmpty = false;
  static final _headers = {'Content-Type': 'application/json'};
  var client = new BrowserClient();
  LogInService _logInService;
  NewUserComponent(this._logInService);

  Future<void> add(String firstName, String lastName, String email, String password, String passwordRe) async {
    final url = "http://localhost:4040/user/new";
    if(!checkPass(password, passwordRe)) {
      return;
    } else if(emailExist(email)) {
      return;
    } else if (firstName == "" || lastName == "" || email == "" || password == "") {
      inputEmpty = true;
      return;
    }
    try {
      created = true;

      final response = await client.post(url, headers: _headers, body: json.encode({'firstName': firstName, 'lastName': lastName, 'email': email, 'password': password}));
      if (response.statusCode == 200) {
        success = true;
        this._logInService.setUser(new User(firstName, lastName, email));
        await Future.delayed(const Duration(seconds: 1), () => "1");
        window.location.assign('#' + RoutePaths.home.toUrl());
      } else {
        success = false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  bool checkPass(String first, String second) {
    if(first == second) {
      passNotCorrect = false;
      return true;
    } else {
      passNotCorrect = true;
      return false;
    }
  }

  bool emailExist(String email) {
    if(emailAddresses.contains(email)) {
      userExist = true;
      return true;
    } else
      userExist = false;
      return false;
  }

  @override
  void ngOnInit() async{
    final url = "http://localhost:4040/user/getAll";

    try {
      final response = await client.post(url, headers: _headers);
      if (response.body != null) {
        for(int i = 0; i < response.body.length; i++) {
          emailAddresses.add(response.body[i]);
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

}