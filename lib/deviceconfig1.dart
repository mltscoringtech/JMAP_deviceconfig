import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jmap_device_config/deviceconfig2.dart';
import 'package:jmap_device_config/widgets/navdrawer.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:wifi_iot/wifi_iot.dart';

import 'controllers/fixedip.dart';
import 'controllers/styles.dart';

class DeviceConfigPage1 extends StatefulWidget {
  const DeviceConfigPage1({Key? key}) : super(key: key);
  static const String routeName = '/config1';

  @override
  _DeviceConfigPage1State createState() => _DeviceConfigPage1State();
}

class _DeviceConfigPage1State extends State<DeviceConfigPage1> {
  List<WifiNetwork> _htResultNetwork = [];
  String ssid = "";
  int _state = 0;
  GlobalKey _globalKey = GlobalKey();

  @override
  initState() {
    getWifi();
    super.initState();
  }

  getWifi() async {
    _htResultNetwork = await loadWifiList();
    setState(() {});
  }

  Future<List<WifiNetwork>> loadWifiList() async {
    List<WifiNetwork> htResultNetwork = [];
    htResultNetwork = await WiFiForIoTPlugin.loadWifiList();
    return htResultNetwork.where((element) => element.ssid!.startsWith('shelly')).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Configure Switch: Select Switch"),
        ),
        drawer: NavDrawer(),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          width: MediaQuery.of(context).size.width * 0.9,
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
                  Expanded(child: Text("Connect to switch you are configuring:")),
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

  Widget refreshButton() {
    return Container(
      key: _globalKey,
      width: 48,
      height: 48,
      child: ElevatedButton(
        style: raisedButtonStyle,
        onPressed: () async {
          setState(() {
            _htResultNetwork = [];
            getWifi();
          });
        },
        child: Icon(Icons.refresh_sharp),
      ),
    );
  }

  Widget wifiScanList() {
    if (_htResultNetwork.length > 0) {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _htResultNetwork.length,
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
          Icon(Icons.adjust_sharp),
          SizedBox(width: 16),
          Expanded(child: Text("No devices detected. Reset the device and then click refresh.")),
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
            print("clicked ${_htResultNetwork[index].ssid}");

            wifiConnect(_htResultNetwork[index].ssid!, "87654321");
          });
        },
        child: Container(
          height: 56,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${_htResultNetwork[index].ssid}"),
                SizedBox(width: 24),
                WiFiIcon(rssi: _htResultNetwork[index].level ?? 0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  wifiConnect(String psSSID, String psKey) async {
    ProgressDialog pr = ProgressDialog(context);
    pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(message: 'Connecting to switch, please wait...');
    pr.show();
    await WiFiForIoTPlugin.findAndConnect(psSSID, password: psKey, joinOnce: true, withInternet: false).then((value) => {
          if (value = true)
            {
              pr.hide(),
              Navigator.push(context, new MaterialPageRoute(builder: (context) => new DeviceConfigPage2(switchID: psSSID))),
            }
        });
  }
}
