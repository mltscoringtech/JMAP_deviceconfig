import 'package:flutter/cupertino.dart';

Map<String, String> fixedIPLookup() {
  var fixedIPs = {
    'Device193': '192.168.8.21',
    'DeviceBBB': '192.168.8.22',
    'DeviceF10': '192.168.8.23',
    'Device9A0': '192.168.8.24',
    'DeviceE2C': '192.168.8.25',
    'Device258': '192.168.8.26',
    'Device00F': '192.168.8.27'
  };
  return fixedIPs;
}

class WiFiIcon extends StatelessWidget {
  const WiFiIcon({
    Key? key,
    required this.rssi,
  }) : super(key: key);

  final int rssi;

  @override
  Widget build(BuildContext context) {
    if (rssi > -55) {
      return Image(image: AssetImage('images/wifi3.png'));
    } else if (rssi > -75) {
      return Image(image: AssetImage('images/wifi2.png'));
    } else {
      return Image(image: AssetImage('images/wifi1.png'));
    }
  }
}
