import 'package:JMAP_deviceconfig/controllers/wifiscan.dart';
import 'package:JMAP_deviceconfig/widgets/navdrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeviceConfigPage extends StatefulWidget {
  const DeviceConfigPage({Key key}) : super(key: key);
  static const String routeName = '/config';

  @override
  _DeviceConfigPageState createState() => _DeviceConfigPageState();
}

class _DeviceConfigPageState extends State<DeviceConfigPage> with TickerProviderStateMixin {
  Future<List<WiFiScan>> ssidData;
  List<WiFiScan> ssidList = [];
  int _state = 0;
  double _width = 240;
  GlobalKey _globalKey = GlobalKey();

  void updateUI(data) {
    setState(() {
      var stop = 0;
      ssidList = data;
      ssidList.sort((b, a) => a.rssi.compareTo(b.rssi));
    });
  }

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
            Center(child: progressButton()),
            Flexible(
              child: Container(
                child: wifiScanList(),
                padding: EdgeInsets.all(24),
              ),
            ),
          ],
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
      return Text("Scan for SSID's");
    } else {
      return CircularProgressIndicator(
        value: null,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  Widget wifiScanList() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: ssidList.length,
      itemBuilder: (context, index) {
        return ssidItemCard(index);
      },
    );
  }

  Widget ssidItemCard(int index) {
    return Card(
      elevation: 8,
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

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      primary: Colors.red,
      padding: EdgeInsets.all(0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ));
}
