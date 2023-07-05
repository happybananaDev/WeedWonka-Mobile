import 'dart:convert';

import 'package:http/http.dart' as http;

const String apiUrl = 'https://api.weedwonka.it/api';

class BaseHttp {
  var client = http.Client();

  Future<dynamic> get(String route) async {
    var url = Uri.parse(apiUrl + route);
    var requestHeaders = {
      'Content-Type': 'application/json', 
    };
    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
