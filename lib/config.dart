import 'package:JMAP_deviceconfig/controllers/wifiscan.dart';
import 'package:JMAP_deviceconfig/widgets/navdrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfigSwitchPage extends StatefulWidget {
  const ConfigSwitchPage({Key key}) : super(key: key);
  static const String routeName = '/config';

  @override
  _ConfigSwitchPageState createState() => _ConfigSwitchPageState();
}

class _ConfigSwitchPageState extends State<ConfigSwitchPage> {
  WiFiScan _wiFiScan = WiFiScan();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Configure Switch"),
        ),
        drawer: NavDrawer(),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Step 1: Reset Switch to turn on management access point."),
            Text(
                "Step 2: Connect this device to the switch access point (shellyswitch25-xxxxxxxxx)."),
            Text("Step 3: Click on Scan to view a list of available SSID's."),
            Text(
                "Step 4: Click on the SSID you would like to join and join the device."),
            FlatButton(
              onPressed: () async {
                var ssidData = await _wiFiScan.getSSID();
                //var stop = 0;
              },
              child: Text("Search for SSID"),
            ),
          ],
        )));
  }
}
