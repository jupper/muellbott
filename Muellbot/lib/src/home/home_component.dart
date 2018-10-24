import 'package:angular/angular.dart';

import '../model/user.dart';
import '../services/log_in_service.dart';

@Component(
  selector: 'home',
  templateUrl: 'home_component.html',
  directives: [coreDirectives],
)

class HomeComponent {
  List<String> weekdays = ["Montag", "Dienstag", "Mitwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"];
  User user;
  HomeComponent(LogInService logInService) : user = logInService.getUser();
}