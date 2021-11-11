import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jmap_device_config/manage.dart';
import 'package:jmap_device_config/routes/routes.dart';
import 'package:jmap_device_config/widgets/navdrawer.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:ping_discover_network/ping_discover_network.dart';

import 'controllers/fixedip.dart';
import 'controllers/styles.dart';
import 'deviceconfig.dart';
import 'deviceconfig1.dart';

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
        Routes.config1: (context) => DeviceConfigPage1(),
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
  List<String> connectedVSKIPs = [];
  double _startSignalTime = 500;
  double _startDelayTime = 2;
  double _parSignalTime = 8;
  bool _startStopIsTiming = false;

  final _startSignalTimeTextController = TextEditingController()..text = "500";
  final _startDelayTextController = TextEditingController()..text = "2.00";
  @override
  initState() {
    pingDiscoverNetwork();
    super.initState();
  }

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
              // LabeledCheckbox(
              //     label: '110V - Green and Red LED',
              //     value: _use110v,
              //     onChanged: (bool newValue) {
              //       setState(() {
              //         _use110v = newValue;
              //       });
              //     }),
              // LabeledCheckbox(
              //     label: '12V - Single White LED',
              //     value: _use12v,
              //     onChanged: (bool newValue) {
              //       setState(() {
              //         _use12v = newValue;
              //       });
              //     }),
              Divider(
                thickness: 3,
                color: Colors.red,
              ),
              SizedBox(
                height: 12,
              ),
              // DropdownButton<String>(
              //   style: const TextStyle(
              //     color: Colors.black,
              //     fontSize: 22,
              //   ),
              //   items: <String>["Start Light Only", "Start / Stop Timing Light", "Par Time Light"].map((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(value),
              //     );
              //   }).toList(),
              //   onChanged: (newValue) {
              //     setState(() {
              //       _selectedStartLightOption = newValue!;
              //       _startStopIsTiming = false;
              //     });
              //   },
              //   value: _selectedStartLightOption,
              // ),
              SizedBox(
                height: 12,
              ),
              Container(
                width: 280,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      triggerStartLight();
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
              // Container(
              //   width: 280,
              //   height: 52,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       setState(() {
              //         print('ntp storm button pressed');
              //         Timer.periodic(Duration(seconds: 1), (timer) async {
              //           _intCount += 1;
              //           print(_intCount);
              //           DateTime _myTime = DateTime.now();
              //
              //           DateTime _ntpTime1 = await NTP.now(lookUpAddress: '192.168.8.1');
              //           DateTime _ntpTime2 = await NTP.now(lookUpAddress: '192.168.8.1');
              //           DateTime _ntpTime3 = await NTP.now(lookUpAddress: '192.168.8.1');
              //           DateTime _ntpTime4 = await NTP.now(lookUpAddress: '192.168.8.1');
              //           DateTime _ntpTime5 = await NTP.now(lookUpAddress: '192.168.8.1');
              //           DateTime _ntpTime6 = await NTP.now(lookUpAddress: '192.168.8.1');
              //           DateTime _ntpTime7 = await NTP.now(lookUpAddress: '192.168.8.1');
              //           DateTime _ntpTime8 = await NTP.now(lookUpAddress: '192.168.8.1');
              //           DateTime _ntpTime9 = await NTP.now(lookUpAddress: '192.168.8.1');
              //           DateTime _ntpTime10 = await NTP.now(lookUpAddress: '192.168.8.1');
              //           DateTime _ntpTime11 = await NTP.now(lookUpAddress: '192.168.8.1');
              //           DateTime _ntpTime12 = await NTP.now(lookUpAddress: '192.168.8.1');
              //           DateTime _ntpTime13 = await NTP.now(lookUpAddress: '192.168.8.1');
              //           DateTime _ntpTime14 = await NTP.now(lookUpAddress: '192.168.8.1');
              //           DateTime _ntpTime15 = await NTP.now(lookUpAddress: '192.168.8.1');
              //           DateTime _ntpTime16 = await NTP.now(lookUpAddress: '192.168.8.1');
              //           DateTime _ntpTime17 = await NTP.now(lookUpAddress: '192.168.8.1');
              //           DateTime _ntpTime18 = await NTP.now(lookUpAddress: '192.168.8.1');
              //           DateTime _ntpTime19 = await NTP.now(lookUpAddress: '192.168.8.1');
              //           DateTime _ntpTime20 = await NTP.now(lookUpAddress: '192.168.8.1');
              //
              //           //_ntpTime = _myTime!.add(Duration(milliseconds: offset));
              //
              //           print('\n==== 192.168.8.1 ====');
              //           print('My time: $_myTime');
              //           print('NTP time: $_ntpTime1}');
              //           print('NTP time: $_ntpTime2}');
              //           print('NTP time: $_ntpTime3}');
              //           print('NTP time: $_ntpTime4}');
              //           print('NTP time: $_ntpTime5}');
              //           print('NTP time: $_ntpTime6}');
              //           print('NTP time: $_ntpTime7}');
              //           print('NTP time: $_ntpTime8}');
              //           print('NTP time: $_ntpTime9}');
              //           print('NTP time: $_ntpTime10}');
              //           print('NTP time: $_ntpTime11}');
              //           print('NTP time: $_ntpTime12}');
              //           print('NTP time: $_ntpTime13}');
              //           print('NTP time: $_ntpTime14}');
              //           print('NTP time: $_ntpTime15}');
              //           print('NTP time: $_ntpTime16}');
              //           print('NTP time: $_ntpTime17}');
              //           print('NTP time: $_ntpTime18}');
              //           print('NTP time: $_ntpTime19}');
              //           print('NTP time: $_ntpTime20}');
              //           print('Difference: ${_myTime.difference(_ntpTime1).inMilliseconds} ms');
              //         });
              //       });
              //     },
              //     style: ElevatedButton.styleFrom(
              //       textStyle: TextStyle(
              //         fontSize: 24,
              //       ),
              //       primary: Colors.green,
              //       padding: EdgeInsets.all(0),
              //       shape: const RoundedRectangleBorder(
              //         borderRadius: BorderRadius.all(Radius.circular(16)),
              //       ),
              //     ),
              //     child: Text("NTP Storm"),
              //   ),
              // ),
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
              Text("Signal Light On Time in Milliseconds"),
              Row(
                children: [
                  Container(
                    width: 250,
                    child: Slider(
                      value: _startSignalTime,
                      label: _startSignalTime.toString(),
                      min: 100,
                      max: 3000,
                      onChanged: (double newSliderValue) {
                        setState(() {
                          _startSignalTime = newSliderValue;
                          _startSignalTimeTextController.text = newSliderValue.toStringAsFixed(0);
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 85,
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
              // Text("Start Signal Delay Time in Seconds"),
              // Row(
              //   children: [
              //     Container(
              //       width: 400,
              //       child: Slider(
              //         value: _startDelayTime,
              //         label: _startDelayTime.toString(),
              //         min: 0,
              //         max: 10,
              //         onChanged: (double newSliderValue) {
              //           setState(() {
              //             _startDelayTime = newSliderValue;
              //             _startDelayTextController.text = newSliderValue.toStringAsFixed(0);
              //           });
              //         },
              //       ),
              //     ),
              //     Container(
              //       width: 65,
              //       child: TextField(
              //         controller: _startDelayTextController,
              //         enabled: false,
              //         style: TextStyle(fontSize: 24),
              //         decoration: InputDecoration(
              //           isDense: true,
              //           counterText: '',
              //           border: UnderlineInputBorder(),
              //           contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 6),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
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

  void triggerStartLight() {
    var client = http.Client();
    print("trigger: ${DateTime.now().millisecond}");
    // final ping21 = Ping('192.168.8.21', count: 1);
    // final ping22 = Ping('192.168.8.22', count: 1);
    // final ping23 = Ping('192.168.8.23', count: 1);
    // final ping24 = Ping('192.168.8.24', count: 1);
    //
    // ping21.stream.listen((event) {
    //   print(event.response);
    // });
    // ping22.stream.listen((event) {
    //   print(event.summary);
    // });
    // ping23.stream.listen((event) {
    //   print(event);
    // });
    // ping24.stream.listen((event) {
    //   print(event);
    // });

    try {
      //print(".21: ${DateTime.now().millisecond}");
      // int startTime = DateTime.now().millisecond;
      // http.Response response23 = await http.get(Uri.http('192.168.8.21', '/status/'));
      // print("${jsonDecode(response23.body)["time"]} - ${jsonDecode(response23.body)["unixtime"]}");
      // int endTime = DateTime.now().millisecond;
      // print('start: $startTime - end: $endTime - delay: ${endTime - startTime}');
      // print("----------------------------------");
      // startTime = DateTime.now().millisecond;
      // http.Response response24 = await http.get(Uri.http('192.168.8.22', '/status/'));
      // print("${jsonDecode(response24.body)["time"]} - ${jsonDecode(response24.body)["unixtime"]}");
      // endTime = DateTime.now().millisecond;
      // print('start: $startTime - end: $endTime - delay: ${endTime - startTime}');
      // print("----------------------------------");
      // print(".23: ${DateTime.now().millisecond}");
      // http.Response response23 = await http.get(Uri.http('192.168.8.23', '/status/'));
      // print(
      //     "${jsonDecode(response23.body)["time"]} - ${jsonDecode(response23.body)["unixtime"]} - ${jsonDecode(response23.body)["ram_total"]} - ${jsonDecode(response23.body)["ram_free"]}");
      //
      // print(".23: ${DateTime.now().millisecond}");

      for (String vskip in connectedVSKIPs) {
        client.get(Uri.parse("http://$vskip/relay/0?turn=on"));
        print("On: ${DateTime.now().millisecond}");
        Future.delayed(Duration(milliseconds: _startSignalTime.toInt())).then((value) {
          client.get(Uri.parse("http://$vskip/relay/0?turn=off"));
          print("Off: ${DateTime.now().millisecond}");
        });
      }

      // Socket.connect('192.168.8.23', 80, timeout: Duration(milliseconds: 500)).then((socket) {
      //   client.get(Uri.parse("http://192.168.8.23/relay/0?turn=on&timer=$_startSignalTime"));
      // }).catchError((error) {});

    } catch (e) {
      print(e);
    }
    print("Done: ${DateTime.now().millisecond}");
  }

  void triggerStopLight() async {
    // http.Response response1 = await http.get(Uri.http('192.168.8.21', '/settings/'));
    // print("${jsonDecode(response1.body)["unixtime"]} ");
    // http.post(Uri.http('192.168.8.21', '/relay/0?turn=on&timer=$_startSignalTime'));
  }

  Future<void> triggerParTime() async {
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

  void pingDiscoverNetwork() async {
    connectedVSKIPs.clear();
    await NetworkInfo().getWifiIP().then((value) {
      if (value!.startsWith('192.168.33')) {
        connectedVSKIPs.add('192.168.33.1');
      } else {
        Map<String, String> fixedIPs = fixedIPLookup();
        final stream8 = NetworkAnalyzer.discover2('192.168.8', 80, timeout: Duration(milliseconds: 500));
        stream8.listen((NetworkAddress addr) {
          if ((addr.exists) && (fixedIPs.containsValue(addr.ip))) {
            connectedVSKIPs.add(addr.ip);
            print(addr.ip);
          }
        });
      }
    });
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
