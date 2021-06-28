import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class WiFiScan {
  Future<dynamic> getSSID() async {
    http.Response response = await http.get("http://192.168.33.1/wifiscan/");
    String data;
    if (response.statusCode == 200) {
      while (jsonDecode(response.body)["wifiscan"] != "done") {
        Timer(Duration(milliseconds: 300), () {});
        response = await http.get("http://192.168.33.1/wifiscan/");
        //print(jsonDecode(response.body));
      }
      data = response.body;
      print(jsonDecode(data)["results"]);
      return jsonDecode(data)["results"];
    } else {
      print(response.statusCode);
    }
  }
}
