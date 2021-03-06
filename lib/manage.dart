import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jmap_device_config/widgets/navdrawer.dart';
import 'package:ping_discover_network/ping_discover_network.dart';

import 'controllers/fixedip.dart';

class ManageDevicePage extends StatelessWidget {
  const ManageDevicePage({Key? key}) : super(key: key);
  static const String routeName = '/manage';

  @override
  Widget build(BuildContext context) {
    pingDiscoverNetwork();

    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Devices"),
      ),
      drawer: NavDrawer(),
      body: Center(
        child: Text("Manage Devices"),
      ),
    );
  }
}

void pingDiscoverNetwork() async {
  // NetworkAnalyzer.discover pings PORT:IP one by one according to timeout.
  // NetworkAnalyzer.discover2 pings all PORT:IP addresses at once.
  Map<String, String> fixedIPs = fixedIPLookup();
  List<String> connectedVSKIPs = [];

  final stream = NetworkAnalyzer.discover2(
    '192.168.8',
    80,
    timeout: Duration(milliseconds: 500),
  );

  int found = 0;
  stream.listen((NetworkAddress addr) {
    if ((addr.exists) && (fixedIPs.containsValue(addr.ip))) {
      connectedVSKIPs.add(addr.ip);
      found++;
      print('Found device: ${addr.ip}');
    }
  }).onDone(() {
    print('Finish. Found $found device(s)');

    print(connectedVSKIPs.length);
    for (String vskip in connectedVSKIPs) {
      print('ip in list: $vskip');
    }
  });
}
