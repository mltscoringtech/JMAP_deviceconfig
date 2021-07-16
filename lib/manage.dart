import 'package:JMAP_deviceconfig/widgets/navdrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ping_discover_network/ping_discover_network.dart';

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

  const port = 80;
  final stream = NetworkAnalyzer.discover2(
    '192.168.8',
    port,
    timeout: Duration(milliseconds: 5000),
  );

  int found = 0;
  stream.listen((NetworkAddress addr) {
    print('${addr.ip}:$port');
    if (addr.exists) {
      found++;
      print('Found device: ${addr.ip}:$port');
    }
  }).onDone(() => print('Finish. Found $found device(s)'));
}
