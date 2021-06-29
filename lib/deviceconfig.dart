import 'package:JMAP_deviceconfig/controllers/wifiscan.dart';
import 'package:JMAP_deviceconfig/widgets/navdrawer.dart';
import 'package:JMAP_deviceconfig/widgets/progress_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeviceConfigPage extends StatefulWidget {
  const DeviceConfigPage({Key key}) : super(key: key);
  static const String routeName = '/config';

  @override
  _DeviceConfigPageState createState() => _DeviceConfigPageState();
}

class _DeviceConfigPageState extends State<DeviceConfigPage> {
  WiFiScanGetData _wiFiScan = WiFiScanGetData();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Configure Switch"),
        ),
        drawer: NavDrawer(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            new ListTile(
              leading: Icon(Icons.adjust_sharp),
              title: Text("Step 1: Reset Switch to turn on management access point."),
            ),
            new ListTile(
              leading: Icon(Icons.adjust_sharp),
              title: Text("Step 2: Connect this device to the switch access point (shellyswitch25-xxxxxxxxx)."),
            ),
            new ListTile(
              leading: Icon(Icons.adjust_sharp),
              title: Text("Step 3: Click on Scan to view a list of available SSID's."),
            ),
            new ListTile(
              leading: Icon(Icons.adjust_sharp),
              title: Text("Step 4: Select the SSID to join."),
            ),

            Center(child: ProgressButton()),
          ],
        ));
  }
}
