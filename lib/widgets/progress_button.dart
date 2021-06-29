import 'package:JMAP_deviceconfig/controllers/wifiscan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ProgressButton extends StatefulWidget {
  const ProgressButton({Key key}) : super(key: key);

  @override
  _ProgressButtonState createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton> with TickerProviderStateMixin {
  WiFiScanGetData _wiFiScan = WiFiScanGetData();
  int _state = 0;
  double _width = 240;
  Animation _animation;
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
          var ssidData = await _wiFiScan.getSSID().then((value) {
            setState(() {
              animateButton();
            });
          });
        },
        child: searchButtonContent(),
      ),
    );
  }

  void animateButton() {
    var animationController = AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(animationController)
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
