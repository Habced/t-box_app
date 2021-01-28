import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
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
    _createBleClient();
  }

  _createBleClient() async {
    await bleManager.createClient();
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
            child: FlatButton(
              onPressed: () async {
                bool isFound = false;
                if (cscDevice == null) {
                  isFound = await scanForDevice(cscName);
                }
                if (isFound || cscDevice != null) {
                  if (await cscDevice.isConnected()) {
                    setState(() {
                      isC1Connected = true;
                    });
                  } else {
                    await cscDevice?.connect();
                    await addCrankListener();
                    setState(() {
                      isC1Connected = true;
                    });
                    FlutterToast.showToast(msg: 'C1 Sensor has been connected');
                  }
                }
                // if (isC1Connected) {
                //   await cscDevice?.disconnect();
                //   setState(() {
                //     isC1Connected = false;
                //   });
                // } else {
                //   bool isFound = false;
                //   if (cscDevice == null) {
                //     isFound = await scanForDevice(cscName);
                //   }
                //   if (isFound || cscDevice != null) {
                //     await cscDevice?.connect();
                //     await findTboxCharacteristics();
                //     setState(() {
                //       isC1Connected = true;
                //     });
                //   }
                // }
              },
              child: Text(
                isC1Connected ? '연결됨' : '연결',
                style: TextStyle(color: MyPrimaryYellowColor),
              ),
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
                bool isFound = false;
                if (tboxDevice == null) {
                  isFound = await scanForDevice(tboxName);
                }
                if (isFound || tboxDevice != null) {
                  if (await tboxDevice.isConnected()) {
                    setState(() {
                      isTboxConnected = true;
                    });
                  } else {
                    await tboxDevice?.connect();
                    await findTboxCharacteristics();
                    setState(() {
                      isTboxConnected = true;
                    });
                    FlutterToast.showToast(msg: 'T-Box has been connected');
                  }
                }
                // if (isTboxConnected) {
                //   await tboxDevice?.disconnect();
                //   setState(() {
                //     isTboxConnected = false;
                //   });
                // } else {
                //   bool isFound = false;
                //   if (tboxDevice == null) {
                //     isFound = await scanForDevice(tboxName);
                //   }
                //   if (isFound || tboxDevice != null) {
                //     await tboxDevice?.connect();
                //     await findTboxCharacteristics();
                //     setState(() {
                //       isTboxConnected = true;
                //     });
                //   }
                // }
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

    var tboxTouchSignal = Container(
      height: 45,
      decoration: BoxDecoration(color: Color(0x33ECEBEA), borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("T-Box 터치 연결"),
          Container(
            child: isTboxConnected
                ? FlatButton(
                    onPressed: () async {
                      // tboxDevice.readCharacteristic(serviceUuid, characteristicUuid)
                      await tboxWriteChar.write(Uint8List.fromList([packetHeader, 0x02, 0x02, 0x01, 0x01]), true);
                      FlutterToast.showToast(msg: "Signal Sent");
                      /*
                        await tboxReadChar.setNotifyValue(true);
                        */
                    },
                    child: Text("Send Signal", style: TextStyle(color: MyPrimaryYellowColor)))
                : Text('Connect T-Box First'),
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
              SizedBox(height: 5),
              tboxTouchSignal,
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
    // flutterBlue.stopScan();
    // bleManager.destroyClient();
  }

  Future<bool> scanForDevice(String scanItem) async {
    await bleManager.stopPeripheralScan();

    // Check if Location is on
    if (!(await isLocationServiceEnabled())) return false;

    // Check if app has location permission
    if (!(await isLocationPermissionGranted())) return false;

    // Check if Bluetooth is on
    BluetoothState currentState = await bleManager.bluetoothState();
    if (currentState != BluetoothState.POWERED_ON) {
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
    scanSubscription = await bleManager
        .startPeripheralScan(
      uuids: scanItem == tboxName
          ? ["6e400001-b5a3-f393-e0a9-e50e24dcca9e"]
          : scanItem == cscName
              ? ["00001816-0000-1000-8000-00805f9b34fb"]
              : [],
    )
        .listen(
      (scanResult) async {
        // print(
        //     "Scanned Peripheral ${scanResult.peripheral.name}, RSSI ${scanResult.rssi}");

        if (scanResult.peripheral.name.contains(scanItem)) {
          if (scanItem == tboxName) {
            tboxDevice = scanResult.peripheral;
            isFound = true;
            await bleManager.stopPeripheralScan();
          } else if (scanItem == cscName) {
            cscDevice = scanResult.peripheral;
            isFound = true;
            await bleManager.stopPeripheralScan();
          }
        }
      },
    ).asFuture();
    setState(() {});
    return isFound;
  }

  Future<void> findTboxCharacteristics() async {
    if (tboxReadChar == null || tboxWriteChar == null) {
      await tboxDevice.discoverAllServicesAndCharacteristics();
      List<Characteristic> characteristics = await tboxDevice?.characteristics(BLE_NRF_SERVICE);
      characteristics.forEach((characteristic) {
        if (characteristic.uuid.toString() == BLE_NRF_CHAR_RX) {
          tboxWriteChar = characteristic;
        }
        if (characteristic.uuid.toString() == BLE_NRF_CHAR_TX) {
          tboxReadChar = characteristic;
        }
      });
    }
    return;
  }
}
