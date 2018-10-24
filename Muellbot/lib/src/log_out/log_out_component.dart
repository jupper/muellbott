import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';


import '../services/log_in_service.dart';
import 'package:Muellbot/src/route_paths.dart';

@Component(
  selector: 'log-out',
  templateUrl: 'log_out_component.html',
)

class LogOutComponent implements OnInit{
    LogInService _logInService;
    LogOutComponent(this._logInService);

  @override
  void ngOnInit() async{
    this._logInService.logOut();
    await Future.delayed(const Duration(seconds: 1), () => "1");
    window.location.assign('#' + RoutePaths.home.toUrl());
  }
}