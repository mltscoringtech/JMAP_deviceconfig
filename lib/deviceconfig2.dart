import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wifi_connect/flutter_wifi_connect.dart';
import 'package:http/http.dart' as http;
import 'package:jmap_device_config/routes/routes.dart';
import 'package:jmap_device_config/widgets/navdrawer.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'controllers/fixedip.dart';
import 'controllers/styles.dart';
import 'controllers/wifiscan.dart';

class DeviceConfigPage2 extends StatefulWidget {
  final String switchID;
  const DeviceConfigPage2({Key? key, required this.switchID}) : super(key: key);
  static const String routeName = '/config2';

  @override
  _DeviceConfigPage2State createState() => _DeviceConfigPage2State();
}

class _DeviceConfigPage2State extends State<DeviceConfigPage2> {
  List<WiFiScan> ssidList = [];
  int _state = 0;
  GlobalKey _globalKey = GlobalKey();

  @override
  initState() {
    getSSID();
    super.initState();
  }

  getSSID() async {
    await fetchWiFiScan().then((data) {
      setState(() {
        ssidList = data;
        final dataSet = Set();
        ssidList.retainWhere((element) => dataSet.add(element.ssid));
        ssidList.sort((b, a) => a.rssi!.compareTo(b.rssi!));
        _state = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Configure Switch: Select SSID"),
        ),
        drawer: NavDrawer(),
        body: Container(
          padding: const EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.adjust_sharp),
                  SizedBox(width: 8),
                  Expanded(child: Text("Select SSID to connect switch.")),
                  refreshButton(),
                ],
              ),
              Flexible(
                child: Container(
                  child: wifiScanList(),
                  padding: EdgeInsets.all(24),
                ),
              ),
            ],
          ),
        ));
  }

  Widget wifiScanList() {
    if (ssidList.length > 0) {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: ssidList.length,
              itemBuilder: (context, index) {
                return ssidItemCard(index);
              },
            ),
          ),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 16),
          Expanded(
              child:
                  (_state == 0) ? Text("Scanning for SSID's.") : Text("No SSID's found. Make sure router is turned on and within range.")),
        ],
      );
    }
  }

  Widget ssidItemCard(int index) {
    return Card(
      elevation: 8,
      child: InkWell(
        onTap: () {
          setState(() {
            configSwitch(index);
          });
        },
        child: Container(
          height: 56,
          child: Center(
            child: Row(
              children: [
                Expanded(
                    child: AutoSizeText(
                  "${ssidList[index].ssid}",
                  maxLines: 1,
                )),
                SizedBox(width: 5),
                WiFiIcon(rssi: ssidList[index].rssi ?? 0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> configSwitch(int index) async {
    ProgressDialog pr = ProgressDialog(context);
    pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(message: 'Configuring Switch, please wait...');
    pr.show();
    Map<String, String> fixedIPs = fixedIPLookup();
    String switchName = widget.switchID.substring(widget.switchID.length - 3, widget.switchID.length);
    switchName = 'Device' + switchName;
    String switchIPNotNull = fixedIPs[switchName] ?? '192.168.33.1';

    var client = http.Client();
    await client.get(Uri.parse("http://192.168.33.1/settings?name=$switchName"));
    print("SwitchID: $switchName");
    await client.get(Uri.parse("http://192.168.33.1/settings?sntp_server=192.168.8.1"));
    print("sntp_server: 192.168.8.1");
    await client.get(Uri.parse("http://192.168.33.1/settings/relay/0?default_state=off")); // Power On Default
    print("RelayDefault: off");
    String configURL = "http://192.168.33.1/settings/sta?enabled=true&ssid=${ssidList[index].ssid}";
    if (ssidList[index].auth! > 0) {
      configURL += '&key=87654321';
    }
    configURL += '&ipv4_method=static&ip=$switchIPNotNull&dns=8.8.8.8&gw=192.168.8.1';
    print(configURL);
    //await client.get(Uri.parse("http://192.168.33.1/settings/sta?enabled=true&ssid=${ssidList[index].ssid}&key=87654321&ipv4_method=static&ip=$switchIPNotNull&dns=8.8.8.8&gw=192.168.8.1")); // Enable WiFi
    await client.get(Uri.parse(configURL)); // Enable WiFi
    print("SSID: ${ssidList[index].ssid}");

    await FlutterWifiConnect.connectToSecureNetwork(ssidList[index].ssid, "87654321").then((value) => {
          if (value = true)
            {
              pr.hide(),
              Navigator.of(context).popUntil((route) => route.isFirst),
              Navigator.pushReplacementNamed(context, Routes.home),
            }
        });
  }

  Widget refreshButton() {
    return Container(
      key: _globalKey,
      width: 48,
      height: 48,
      child: ElevatedButton(
        style: raisedButtonStyle,
        onPressed: () async {
          setState(() {
            ssidList = [];
            _state = 0;
            getSSID();
          });
        },
        child: Icon(Icons.refresh_sharp),
      ),
    );
  }
}
