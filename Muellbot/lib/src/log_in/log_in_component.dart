import 'dart:html';
import 'dart:async';

import 'package:Muellbot/src/route_paths.dart';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import '../services/log_in_service.dart';

@Component(
  selector: 'log-in',
  templateUrl: 'log_in_component.html',
  styleUrls: ['log_in_component.css'],
  directives: [coreDirectives, formDirectives]
)

class LogInComponent {
  bool success = false, failure = false;
  LogInService _logInService;
  LogInComponent(this._logInService);


  doLogIn(String email, String password) async{
    success = false;
    if(email == "" || password == "") {
      failure = true;
      return;
    }
    failure = !await this._logInService.logIn(email, password);
    if(failure) {
      success = true;
      return;
    }
    success = true;
    failure = false;
    await Future.delayed(const Duration(seconds: 1), () => "1");
    window.location.assign('#' + RoutePaths.home.toUrl());
  }
}