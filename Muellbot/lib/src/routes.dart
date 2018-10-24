import 'package:angular_router/angular_router.dart';

import 'route_paths.dart';
import 'home/home_component.template.dart' as home_template;
import 'new_user/new_user_component.template.dart' as new_user_template;
import 'log_in/log_in_component.template.dart' as log_in_template;
import 'log_out/log_out_component.template.dart' as log_out_template;
import 'my_data/my_data_component.template.dart' as my_data_template;
import 'select_weeks/select_weeks_component.template.dart' as select_weeks_template;

export 'route_paths.dart';

class Routes {
  static final home = RouteDefinition(
    routePath: RoutePaths.home,
    component: home_template.HomeComponentNgFactory,
  );
  static final newUser = RouteDefinition(
    routePath: RoutePaths.newUser,
    component: new_user_template.NewUserComponentNgFactory,
  );
  static final logIn = RouteDefinition(
    routePath: RoutePaths.logIn,
    component: log_in_template.LogInComponentNgFactory,
  );
  static final logOut = RouteDefinition(
    routePath: RoutePaths.logOut,
    component: log_out_template.LogOutComponentNgFactory,
  );
  static final myData = RouteDefinition(
    routePath: RoutePaths.myData,
    component: my_data_template.MyDataComponentNgFactory,
  );
  static final selectWeeks = RouteDefinition(
    routePath: RoutePaths.selectWeeks,
    component: select_weeks_template.SelectWeeksComponentNgFactory,
  );

  static final all = <RouteDefinition>[
    home,
    newUser,
    logIn,
    logOut,
    myData,
    selectWeeks,
    RouteDefinition.redirect(
      path: '',
      redirectTo: RoutePaths.home.toUrl(),
    ),
  ];
}