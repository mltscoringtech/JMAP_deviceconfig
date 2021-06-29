import 'package:JMAP_deviceconfig/deviceconfig.dart';
import 'package:JMAP_deviceconfig/manage.dart';
import 'package:JMAP_deviceconfig/routes/routes.dart';
import 'package:JMAP_deviceconfig/widgets/navdrawer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JMAP Device Configurator',
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Color.fromRGBO(176, 13, 37, 1),
        focusColor: Colors.cyan[600],
        indicatorColor: Colors.yellow[800],
        secondaryHeaderColor: Colors.grey[600],

        // Define the default font family.
        fontFamily: 'Hind',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          caption: TextStyle(fontSize: 22),
          bodyText2: TextStyle(fontSize: 22),
          bodyText1: TextStyle(fontSize: 22),
        ),
      ),
      home: HomeScreen(),
      routes: {
        Routes.manage: (context) => ManageDevicePage(),
        Routes.config: (context) => DeviceConfigPage(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(
            onPressed: () => Navigator.pushReplacementNamed(context, Routes.manage),
            child: Text("Manage Devices"),
          ),
          FlatButton(
            onPressed: () => Navigator.pushReplacementNamed(context, Routes.config),
            child: Text("Configure Switch"),
          )
        ],
      )),
      drawer: NavDrawer(),
    );
  }
}
