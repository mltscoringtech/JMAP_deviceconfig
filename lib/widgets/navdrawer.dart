import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jmap_device_config/routes/routes.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 85,
            padding: EdgeInsets.all(8),
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Text(
                "JMAP Configurator",
                style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          _createDrawerItem(
            icon: Icons.device_unknown_sharp,
            text: 'Home',
            onTap: () => Navigator.pushReplacementNamed(context, Routes.home),
          ),
          _createDrawerItem(
            icon: Icons.device_unknown_sharp,
            text: 'Manage Devices',
            onTap: () => Navigator.pushReplacementNamed(context, Routes.manage),
          ),
          _createDrawerItem(
            icon: Icons.devices_other_sharp,
            text: 'Configure Switch',
            onTap: () => Navigator.pushReplacementNamed(context, Routes.config1),
          ),
          Divider(),
        ],
      ),
    );
  }
}

Widget _createHeader() {
  return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Stack(children: [
        Positioned(
            bottom: 18.0,
            left: 6.0,
            child: Text("JMAP Device Configurator", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500))),
      ]));
}

Widget _createDrawerItem({required IconData icon, required String text, required GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(text),
        )
      ],
    ),
    onTap: onTap,
  );
}
