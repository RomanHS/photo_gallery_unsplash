import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'consts.dart' as consts;

class Data with ChangeNotifier {
  int? _statusCode;
  int? get getStatusCode => _statusCode;

  List<dynamic> _json = [];
  List<dynamic> get getJson => _json;

  void httpRequest() async {
    try {
      var response = await http.get(Uri.parse(consts.url));

      if (response.statusCode == 200) {
        _json = jsonDecode(response.body);
      }
      _statusCode = response.statusCode;
    } catch (error) {
      _statusCode = 0;
    }

    notifyListeners();
  }
}
