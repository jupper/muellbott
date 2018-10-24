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
  selector: 'select_weeks',
  templateUrl: 'select_weeks_component.html',
  styleUrls: ['select_weeks_component.css'],
  directives: [coreDirectives, formDirectives],
)


class SelectWeeksComponent implements OnInit{
  User user;
  List<int> kw = new List();
  List<DateTime> kwStart = new List();
  List<DateTime> kwEnd = new List();
  String start;
  SelectWeeksComponent(LogInService logInService) : user = logInService.getUser();
  bool success = false;

  void save() async{
    List<bool> available = new List();
    List<String> listKw = new List();
    for (int i = 0; i < kw.length; i++) {
      available.add(false);
      var cb = document.querySelector('#cb' + i.toString()) as CheckboxInputElement;
      if(cb.checked) {
        available.removeLast();
        available.add(true);
      }
    }
    for(int i = 0; i < kw.length; i++) {
      if(available[i]) {
        listKw.add(kw[i].toString());
      }
    }
    final _headers = {'Content-Type': 'application/json'};
    var client = new BrowserClient();
    var url = "http://localhost:4040/setAvailableWeeks";
    try {
      final response = await client.post(url, headers: _headers, body: json.encode({'email': user.getEmail(), 'weeks': listKw}));
      if (response.statusCode == 200) {
        success = true;
        await Future.delayed(const Duration(seconds: 1), () => "1");
        cancel();
      } else {
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void cancel() {
    window.location.assign('#' + RoutePaths.home.toUrl());
  }

  @override
  void ngOnInit() async{
    final _headers = {'Content-Type': 'application/json'};
    var client = new BrowserClient();
    var url = "http://localhost:4040/availableWeeks";

    try {
      var response = await client.post(url, headers: _headers);
      if (response.body.length != null) {
        this.parseInt(response.body);
        this.parseKwStartEnd();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void parseInt(String s) {
    if (s.length == 2) {
      return;
    }
    int counter = 1;
    for (int i = 1; i < s.length; i++) {
      if(s.substring(i, i + 1) == ',' || s.substring(i) == ']') {
        start = s.substring(1, i);
        counter = i + 2;
        break;
      }
    }
    while (counter < s.length) {
      for(int i = counter; i < s.length; i++) {
        if(s.substring(i, i + 1) == ',' || s.substring(i) == ']') {
          kw.add(int.tryParse(s.substring(counter, i)));
          counter = i + 2;
          break;
        }
      }
    }
  }

  void parseKwStartEnd() {
    kwStart.add(DateTime.parse(this.start));
    for (int i = 1; i < kw.length; i++) {
      kwStart.add(kwStart[i - 1].add(new Duration(days: 7)));
    }

    for (int i = 0; i < kwStart.length; i++) {
      kwEnd.add(kwStart[i].add(new Duration(days: 6)));
    }
  }
}
