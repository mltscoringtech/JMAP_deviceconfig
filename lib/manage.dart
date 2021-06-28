import 'package:JMAP_deviceconfig/widgets/navdrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ManageDevicePage extends StatelessWidget {
  const ManageDevicePage({Key key}) : super(key: key);
  static const String routeName = '/manage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Manage Devices"),
        ),
        drawer: NavDrawer(),
        body: Center(child: Text("Manage Devices")));
  }
}
