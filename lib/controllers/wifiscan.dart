import 'dart:convert';

import 'package:http/http.dart' as http;

class WiFiScan {
  Future<dynamic> getSSID() async {
    String data;
    http.Response response = await http.get("http://192.168.33.1/wifiscan/");
    if (response.statusCode == 200) {
      http.get("http://192.168.33.1/wifiscan/").then((response) {
        handleDataFromSSIDScan(response);
        data = response.body;
        print(jsonDecode(data));
      });

      while (jsonDecode(response.body)["wifiscan"] != "done") {
        Future.delayed(Duration(milliseconds: 500));
        response = await http.get("http://192.168.33.1/wifiscan/");
      }
      print(jsonDecode(data)["results"]);
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }

  Future<dynamic> handleDataFromSSIDScan(var response) async {
    if (jsonDecode(response.body)["wifiscan"] != "done") {
      Future.delayed(Duration(milliseconds: 500), () {
        http.get("http://192.168.33.1/wifiscan/").then((response) {
          handleDataFromSSIDScan(response);
        });
      });
    } else {
      response = await http.get("http://192.168.33.1/wifiscan/");
      return response;
    }
  }
}
