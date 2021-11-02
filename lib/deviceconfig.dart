import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jmap_device_config/widgets/navdrawer.dart';

import 'controllers/styles.dart';
import 'controllers/wifiscan.dart';

class DeviceConfigPage extends StatefulWidget {
  const DeviceConfigPage({Key? key}) : super(key: key);
  static const String routeName = '/config';

  @override
  _DeviceConfigPageState createState() => _DeviceConfigPageState();
}

class _DeviceConfigPageState extends State<DeviceConfigPage> with TickerProviderStateMixin {
  late Future<List<WiFiScan>> ssidData;
  List<WiFiScan> ssidList = [];
  int _state = 0;
  double _width = 240;
  GlobalKey _globalKey = GlobalKey();

  void updateUI(data) {
    setState(() {
      var stop = 0;
      ssidList = data;
      ssidList.sort((b, a) => a.rssi!.compareTo(b.rssi!));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Configure Switch"),
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
                  SizedBox(width: 16),
                  Expanded(child: Text("Connect to switch to be configured.")),
                ],
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: progressButton(),
              )),
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

  Widget progressButton() {
    return Container(
      key: _globalKey,
      width: _width,
      height: 48,
      child: ElevatedButton(
        style: raisedButtonStyle,
        onPressed: () async {
          setState(() {
            ssidList = [];
            animateButton();
          });
          await fetchWiFiScan().then((data) {
            setState(() {
              animateButton();
            });
            updateUI(data);
          });
        },
        child: searchButtonContent(),
      ),
    );
  }

  Widget searchButtonContent() {
    if (_state == 0) {
      return Text("Scan for JMAP start signal devices.");
    } else {
      return CircularProgressIndicator(
        value: null,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  Widget wifiScanList() {
    if (ssidList.length > 0) {
      return Column(
        children: [
          ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: ssidList.length,
            itemBuilder: (context, index) {
              return ssidItemCard(index);
            },
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.adjust_sharp),
              SizedBox(width: 16),
              Expanded(child: Text("Select the Device to configure:")),
            ],
          )
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.adjust_sharp),
          SizedBox(width: 16),
          Expanded(child: Text("Scan to view available Start Signal devices.")),
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
            print("clicked");
          });
        },
        child: Container(
          height: 56,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${ssidList[index].ssid}"),
                SizedBox(width: 24),
                Icon((ssidList[index].auth == 0) ? Icons.signal_wifi_4_bar : Icons.signal_wifi_4_bar_lock_sharp),
                SizedBox(width: 12),
                Text(ssidList[index].rssi.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void animateButton() {
    var animationController = AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    Animation _animation = Tween(begin: 0.0, end: 1.0).animate(animationController)
      ..addListener(() {
        setState(() {
          _width = (_state == 1) ? 48 : 240;
        });
      });
    animationController.forward();

    setState(() {
      _state = (_state == 0) ? 1 : 0;
    });
  }
}
