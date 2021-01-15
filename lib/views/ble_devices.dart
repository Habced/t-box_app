import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:system_setting/system_setting.dart';
import 'package:tboxapp/shared/global_vars.dart';
import 'package:tboxapp/shared/utils.dart';

class BleDevicesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BleDevicesScreenState();
}

class BleDevicesScreenState extends State<BleDevicesScreen> {
  var scanSubscription;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Connect')),
      backgroundColor: MyPrimaryBlueColor,
      body: _buildBody(),
    );
  }

  _buildBody() {
    var connectTcyclingButton = Container(
      height: 45,
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      decoration: BoxDecoration(
        color: Color(0x33ECEBEA),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("T-CYCLING 센서"),
          Container(
            child: StreamBuilder<BluetoothDeviceState>(
              stream: cscDevice?.state,
              initialData: BluetoothDeviceState.disconnected,
              builder: (context, snapshot) {
                VoidCallback onPressed;
                String text;
                switch (snapshot.data) {
                  case BluetoothDeviceState.connected:
                    onPressed = () async {
                      await cscDevice.disconnect();
                      setState(() {
                        isC1Connected = false;
                      });
                    };
                    text = "연결 완료";
                    break;
                  case BluetoothDeviceState.disconnected:
                    onPressed = () async {
                      if (cscDevice == null) {
                        // await scanForDevice(cscName);
                      }
                      await cscDevice?.connect();
                      setState(() {
                        isC1Connected = true;
                      });
                      await addCrankListener();
                    };
                    text = "연결";
                    break;
                  case BluetoothDeviceState.connecting:
                    onPressed = null;
                    text = "연결중...";
                    break;
                  case BluetoothDeviceState.disconnecting:
                    onPressed = null;
                    text = "Disconnecting...";
                    break;
                  default:
                    onPressed = null;
                    text = snapshot.data.toString().substring(21).toUpperCase();
                    break;
                }
                return FlatButton(
                  onPressed: onPressed,
                  child: Text(
                    text,
                    style: TextStyle(color: MyPrimaryYellowColor),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
    var connectTboxButton = Container(
      height: 45,
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      decoration: BoxDecoration(color: Color(0x33ECEBEA), borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("T-BOX 센서"),
          Container(
            child: FlatButton(
              onPressed: () async {
                if (isTboxConnected) {
                  await tboxDevice?.disconnect();
                  setState(() {
                    isTboxConnected = false;
                  });
                } else {
                  bool isFound = false;
                  if (tboxDevice == null) {
                    isFound = await scanForDevice(tboxName);
                  }
                  if (isFound || tboxDevice != null) {
                    await tboxDevice?.connect();
                    await findTboxCharacteristics();
                    setState(() {
                      isTboxConnected = true;
                    });

                    // var myState = await tboxDevice.state?.last;
                    // print("myState" + myState.toString());
                    // if (myState == BluetoothDeviceState.connected) {
                    //   print("is connected");
                    //   setState(() {
                    //     isTboxConnected = true;
                    //   });
                    // } else if (myState == BluetoothDeviceState.disconnected) {
                    //   print("is not connected");
                    //   await tboxDevice?.connect();
                    //   await findTboxCharacteristics();
                    //   setState(() {
                    //     isTboxConnected = true;
                    //   });
                    // }
                  }
                }
              },
              child: Text(
                isTboxConnected ? '연결됨' : '연결',
                style: TextStyle(color: MyPrimaryYellowColor),
              ),
            ),
          ),
        ],
      ),
    );

    var myTs = TextStyle(
      color: Colors.white,
    );

    return Container(
      color: Colors.black,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text("T-BOX 디바이스 연결", style: myTs),
              ),
              Divider(color: Colors.white, thickness: 2),
              SizedBox(height: 10),
              connectTboxButton,
              SizedBox(height: 10),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text("T-CYCLING C1 디바이스 연결", style: myTs),
              ),
              Divider(color: Colors.white, thickness: 2),
              SizedBox(height: 10),
              connectTcyclingButton,
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    flutterBlue.stopScan();
  }

  Future<bool> scanForDevice(String scanItem) async {
    await flutterBlue.stopScan();

    // Check if Location is on
    if (!(await isLocationServiceEnabled())) return false;

    // Check if app has location permission
    if (!(await isLocationPermissionGranted())) return false;

    // Check if Bluetooth is on
    if (!(await flutterBlue.isOn)) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Bluetooth'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Bluetooth is off.'),
                  // Text('Would you like to turn on bluetooth?'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Go To Settings'),
                onPressed: () {
                  SystemSetting.goto(SettingTarget.BLUETOOTH);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return false;
    }

    bool isFound = false;
    FlutterToast.showToast(msg: "Scanning for $scanItem");
    scanSubscription = await flutterBlue.scan(timeout: Duration(seconds: 2)).listen(
      (scanResult) async {
        if (scanResult.device.name.contains(scanItem)) {
          if (scanItem.contains(tboxName)) {
            tboxDevice = scanResult.device;
            isFound = true;
            FlutterToast.showToast(msg: 'T-Box has been connected');
            flutterBlue.stopScan();
          }
        }
      },
    ).asFuture();
    setState(() {});
    return isFound;
  }

  Future<void> findTboxCharacteristics() async {
    List<BluetoothService> services = await tboxDevice?.discoverServices();
    services?.forEach((service) {
      // print('found a service: ' + service.toString());
      service.characteristics.forEach((characteristic) {
        if (characteristic.uuid.toString() == BLE_NRF_CHAR_RX) {
          tboxWriteChar = characteristic;
          // characteristic.setNotifyValue(true);
          // characteristic.value.listen((value) {
          //   print("Received: " + value.toString());
          // });
          print('found write');
        }
        if (characteristic.uuid.toString() == BLE_NRF_CHAR_TX) {
          tboxReadChar = characteristic;
          // characteristic.setNotifyValue(true);
          // characteristic.value.listen((value) {
          //   print("Received lol: " + value.toString());
          // });
          print('found read');
        }
      });
    });
    return;
  }
}
