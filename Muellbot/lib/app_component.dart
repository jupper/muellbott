import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';

import 'src/routes.dart';
import 'src/services/log_in_service.dart';
import 'src/model/user.dart';

@Component(
  selector: 'my-app',
  styleUrls: ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: [routerDirectives, formDirectives, coreDirectives],
  exports: [RoutePaths, Routes],
  providers: [ClassProvider(LogInService)],
)
class AppComponent implements DoCheck{
  final LogInService _logInService;
  User user;
  AppComponent(this._logInService);

  @override
  void ngDoCheck() {
    user = _logInService.getUser();
  }
}