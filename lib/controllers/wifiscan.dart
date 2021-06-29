import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class WiFiScan {
  final String ssid;
  final int auth;
  final int channel;
  final String bssid;
  final String rssi;
  WiFiScan({this.ssid, this.auth, this.channel, this.bssid, this.rssi});

  factory WiFiScan.fromJson(Map<String, dynamic> parsedJson) {
    return WiFiScan(
      ssid: parsedJson['ssid'] as String,
      auth: parsedJson['auth'] as int,
      channel: parsedJson['channel'] as int,
      bssid: parsedJson['bssid'] as String,
      rssi: parsedJson['rssi'] as String,
    );
  }
}

class WiFiScanGetData {
  Future<dynamic> getSSID() async {
    http.Response response = await http.get("http://192.168.33.1/wifiscan/");
    String data;
    if (response.statusCode == 200) {
      while (jsonDecode(response.body)["wifiscan"] != "done") {
        Timer(Duration(milliseconds: 100), () {});
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
