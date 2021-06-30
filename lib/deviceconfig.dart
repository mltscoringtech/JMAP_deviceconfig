import 'package:JMAP_deviceconfig/controllers/wifiscan.dart';
import 'package:JMAP_deviceconfig/widgets/navdrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var ssidData;

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
            Text("ssidData: ${ssidData ?? "None"} "),
          ],
        ));
  }
}

class ProgressButton extends StatefulWidget {
  const ProgressButton({Key key}) : super(key: key);

  @override
  _ProgressButtonState createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton> with TickerProviderStateMixin {
  WiFiScanGetData _wiFiScan = WiFiScanGetData();
  int _state = 0;
  double _width = 240;
  GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _globalKey,
      width: _width,
      height: 48,
      child: ElevatedButton(
        style: raisedButtonStyle,
        onPressed: () async {
          setState(() {
            animateButton();
          });
          ssidData = await _wiFiScan.getSSID().then((value) {
            setState(() {
              animateButton();
              ssidData = value;
            });
          });
        },
        child: searchButtonContent(),
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

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      primary: Colors.red,
      padding: EdgeInsets.all(0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ));
}
