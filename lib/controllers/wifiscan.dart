import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class WiFiScan {
  final String? ssid;
  final int? auth;
  final int? channel;
  final String? bssid;
  final int? rssi;
  WiFiScan({this.ssid, this.auth, this.channel, this.bssid, this.rssi});

  factory WiFiScan.fromJson(Map<String, dynamic> parsedJson) {
    return WiFiScan(
      ssid: parsedJson['ssid'] as String,
      auth: parsedJson['auth'] as int,
      channel: parsedJson['channel'] as int,
      bssid: parsedJson['bssid'] as String,
      rssi: parsedJson['rssi'] as int,
    );
  }
}

List<WiFiScan> parseWiFiScan(String responseBody) {
  final parsed = json.decode(responseBody)["results"].cast<Map<String, dynamic>>();
  return parsed.map<WiFiScan>((json) => WiFiScan.fromJson(json)).toList();
}

Future<List<WiFiScan>> fetchWiFiScan() async {
  try {
    http.Response response = await http.get(Uri.http('192.168.33.1', '/wifiscan/'));
    if (response.statusCode == 200) {
      while (jsonDecode(response.body)["wifiscan"] != "done") {
        Timer(Duration(milliseconds: 50), () {});
        response = await http.get(Uri.http('192.168.33.1', '/wifiscan/'));
        //print(jsonDecode(response.body));
      }
      //print(jsonDecode(response.body)["results"]);
      return parseWiFiScan(response.body);
    } else {
      //throw Exception('Unable to connect to Device.');
      print('Unable to connect to device.');
      return [WiFiScan(ssid: 'Unable to connect to device.', auth: 9)];
    }
  } on Exception catch (_) {
    //throw Exception('Not connected to network.');
    print('Not connected to network.');
    return [WiFiScan(ssid: 'Not connected to network.', auth: 9)];
  }
}

// class WiFiScanGetData {
//   Future<dynamic> getSSID() async {
//     http.Response response = await http.get("http://192.168.33.1/wifiscan/");
//     String data;
//     if (response.statusCode == 200) {
//       while (jsonDecode(response.body)["wifiscan"] != "done") {
//         Timer(Duration(milliseconds: 100), () {});
//         response = await http.get("http://192.168.33.1/wifiscan/");
//         //print(jsonDecode(response.body));
//       }
//       data = response.body;
//       print(jsonDecode(data)["results"]);
//       return jsonDecode(data)["results"];
//     } else {
//       print(response.statusCode);
//     }
//   }
// }
