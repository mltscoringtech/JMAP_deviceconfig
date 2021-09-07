import 'dart:convert';

import 'package:JMAP_deviceconfig/deviceconfig.dart';
import 'package:JMAP_deviceconfig/manage.dart';
import 'package:JMAP_deviceconfig/routes/routes.dart';
import 'package:JMAP_deviceconfig/widgets/navdrawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'controllers/styles.dart';

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
          textTheme: textTheme),
      home: HomeScreen(),
      routes: {
        Routes.home: (context) => HomeScreen(),
        Routes.manage: (context) => ManageDevicePage(),
        Routes.config: (context) => DeviceConfigPage(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _use110v = true;
  bool _use12v = true;
  double _startSignalTime = 2.00;
  double _parSignalTime = 8.00;
  bool _startStopIsTiming = false;
  String _selectedStartLightOption = "Start Light Only";
  final _parTimeTextController = TextEditingController()..text = "8";
  final _startSignalTimeTextController = TextEditingController()..text = "2.00";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width * 0.9,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 24),
              LabeledCheckbox(
                  label: '110V - Green and Red LED',
                  value: _use110v,
                  onChanged: (bool newValue) {
                    setState(() {
                      _use110v = newValue;
                    });
                  }),
              LabeledCheckbox(
                  label: '12V - Single White LED',
                  value: _use12v,
                  onChanged: (bool newValue) {
                    setState(() {
                      _use12v = newValue;
                    });
                  }),
              Divider(
                thickness: 3,
                color: Colors.red,
              ),
              SizedBox(
                height: 12,
              ),
              DropdownButton<String>(
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                ),
                items: <String>["Start Light Only", "Start / Stop Timing Light", "Par Time Light"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedStartLightOption = newValue!;
                    _startStopIsTiming = false;
                  });
                },
                value: _selectedStartLightOption,
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                width: 280,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      triggerStartSignalLight();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(
                      fontSize: 24,
                    ),
                    primary: (_startStopIsTiming) ? Colors.red : Colors.green,
                    padding: EdgeInsets.all(0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                  child: (_startStopIsTiming) ? Text("Stop Timing") : Text("Start Timing"),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Divider(
                thickness: 3,
                color: Colors.red,
              ),
              SizedBox(
                height: 8,
              ),
              Text("Signal Light On Time in Seconds"),
              Row(
                children: [
                  Container(
                    width: 400,
                    child: Slider(
                      value: _startSignalTime,
                      label: _startSignalTime.toString(),
                      min: 1,
                      max: 5,
                      onChanged: (double newSliderValue) {
                        setState(() {
                          _startSignalTime = newSliderValue;
                          _startSignalTimeTextController.text = newSliderValue.toStringAsFixed(2);
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 65,
                    child: TextField(
                      controller: _startSignalTimeTextController,
                      enabled: false,
                      style: TextStyle(fontSize: 24),
                      decoration: InputDecoration(
                        isDense: true,
                        counterText: '',
                        border: UnderlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 6),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Text("Par Time Length"),
                  Container(
                    width: 65,
                    child: TextField(
                      controller: _parTimeTextController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 24),
                      decoration: InputDecoration(
                        isDense: true,
                        counterText: '',
                        border: UnderlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 15),
                      ),
                      onTap: () {
                        _parTimeTextController.selection =
                            TextSelection(baseOffset: 0, extentOffset: _parTimeTextController.value.text.length);
                      },
                      onChanged: (String newText) {
                        setState(() {
                          print(newText);
                          _parTimeTextController.text = newText;
                          _parSignalTime = double.parse(newText);
                        });
                      },
                    ),
                  ),
                  Text("Seconds"),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Divider(
                thickness: 3,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
      drawer: NavDrawer(),
    );
  }

  void triggerStartSignalLight() async {
    print("start ${DateTime.now().millisecond}");
    print(_selectedStartLightOption);

    switch (_selectedStartLightOption) {
      case "Start Light Only":
        {
          _startStopIsTiming = false;
          triggerStartLight();
        }
        break;
      case "Start / Stop Timing Light":
        {
          _startStopIsTiming = !_startStopIsTiming;
          (_startStopIsTiming) ? triggerStartLight() : triggerStopLight();
        }
        break;
      case "Par Time Light":
        {
          _startStopIsTiming = false;
          triggerParTime();
        }
        break;
    }
  }

  void triggerStartLight() async {
    http.Response response1 = await http.get(Uri.http('192.168.8.21', '/settings/'));
    print("${jsonDecode(response1.body)["unixtime"]} ");
    http.post(Uri.http('192.168.8.21', '/relay/0?turn=on&timer=$_startSignalTime'));
  }

  void triggerStopLight() async {
    http.Response response1 = await http.get(Uri.http('192.168.8.21', '/settings/'));
    print("${jsonDecode(response1.body)["unixtime"]} ");
    http.post(Uri.http('192.168.8.21', '/relay/0?turn=on&timer=$_startSignalTime'));
  }

  void triggerParTime() async {
    int _parTimeInMilliseconds = (_parSignalTime * 1000).round();
    print(DateTime.now().millisecond);
    http.Response response1 = await http.get(Uri.http('192.168.8.21', '/settings/'));
    print("${jsonDecode(response1.body)["unixtime"]} ");
    print(DateTime.now().millisecond);
    http.post(Uri.http('192.168.8.21', '/relay/0?turn=on'));

    Future.delayed(Duration(milliseconds: _parTimeInMilliseconds), () {
      http.post(Uri.http('192.168.8.21', '/relay/0?turn=off'));
    });
    print(DateTime.now().millisecond);
  }
}

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: InkWell(
        onTap: () {
          onChanged(!value);
        },
        child: Row(
          children: <Widget>[
            Checkbox(
              value: value,
              onChanged: (bool? newValue) {
                onChanged(newValue);
              },
            ),
            Expanded(child: Text(label)),
          ],
        ),
      ),
    );
  }
}
