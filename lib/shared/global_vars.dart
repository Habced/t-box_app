import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:location/location.dart';

const MyPrimaryBlueColor = const MaterialColor(0xFF212935, const <int, Color>{
  50: const Color(0xFFE1E2E4),
  100: const Color(0xFFD1D2D5),
  200: const Color(0xFFB6B9BD),
  300: const Color(0xFF8D9197),
  400: const Color(0xFF4D545D),
  500: const Color(0xFF212935),
  600: const Color(0xFF151A22),
  700: const Color(0xFF0E1116),
  800: const Color(0xFF090B0E),
  900: const Color(0xFF050607),
});

const MyPrimaryYellowColor = const MaterialColor(0xFFF2C94C, const <int, Color>{
  50: const Color(0xFFFDF8E7),
  100: const Color(0xFFFDF4DA),
  200: const Color(0xFFFBEDC5),
  300: const Color(0xFFF9E4A4),
  400: const Color(0xFFF5D470),
  500: const Color(0xFFF2C94C),
  600: const Color(0xFF9B8131),
  700: const Color(0xFF63521F),
  800: const Color(0xFF3F3514),
  900: const Color(0xFF28220D),
});

const MyPrimaryBlackColor = const MaterialColor(0xFF000000, const <int, Color>{
  50: const Color(0xFF000000),
  100: const Color(0xFF000000),
  200: const Color(0xFF000000),
  300: const Color(0xFF000000),
  400: const Color(0xFF000000),
  500: const Color(0xFF000000),
  600: const Color(0xFF000000),
  700: const Color(0xFF000000),
  800: const Color(0xFF000000),
  900: const Color(0xFF000000),
});

var myTitle = "T-Box Fit Example";

// var myThemeData = ThemeData(
//   brightness: Brightness.dark,
//   primarySwatch: MyPrimaryBlueColor,
//   primaryColor: MyPrimaryBlueColor,
//   accentColor: MyPrimaryYellowColor,
//   // textTheme: TextTheme(
//   //   headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
//   //   headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
//   //   bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
//   // ),
// );
var myThemeData = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: MyPrimaryBlackColor,
  primaryColor: MyPrimaryBlackColor,
  accentColor: MyPrimaryYellowColor,
  // textTheme: TextTheme(
  //   headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
  //   headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
  //   bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
  // ),
);

// final FlutterBlue flutterBlue = FlutterBlue.instance;

BleManager bleManager = BleManager();
final Location location = new Location();

final TextStyle titleFont = const TextStyle(
  fontSize: 25.0,
); // color: Colors.grey.shade200 );
final TextStyle subtitleFont = const TextStyle(
  fontSize: 18.0,
); //color: Colors.grey.shade200 );
final TextStyle overlayCateFont = const TextStyle(fontSize: 14.0, color: Colors.white);
final TextStyle overlayTextFont =
    const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white, shadows: <Shadow>[
  Shadow(offset: Offset(3.0, 3.0), blurRadius: 8, color: Colors.black38),
]);
final TextStyle overlayTextFontSmall =
    const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white, shadows: <Shadow>[
  Shadow(offset: Offset(3.0, 3.0), blurRadius: 8, color: Colors.black38),
]);

// T-Box
const String tboxName = "Raytac AT-UART";
Peripheral tboxDevice;
Characteristic tboxWriteChar;
Characteristic tboxReadChar;
bool isTboxConnected = false;
const BLUETOOTH_LE_CCCD = "00002902-0000-1000-8000-00805f9b34fb";
const BLE_NRF_SERVICE = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
const BLE_NRF_CHAR_RX = "6e400002-b5a3-f393-e0a9-e50e24dcca9e"; // Write
const BLE_NRF_CHAR_TX = "6e400003-b5a3-f393-e0a9-e50e24dcca9e"; // Read
const packetHeader = 0x54;

// Cadence Sensor
// String cscName = "CAD";
// const String cscName = "Cycplus C3";
const String cscName = "Cycplus";
bool isBluetoothOn;
String crankData = "0";
double distance = 0;
String distanceString = "0.00";
String caloriesBurned = "0.0";
double speed = 0;
String speedString = "0.0";

Peripheral cscDevice;
Characteristic crankCharacteristic;
bool isC1Connected = false;

const CADENCE_SERVICE_UUID = "00001816-0000-1000-8000-00805f9b34fb";
const CAD_CRANK_UUID = "00002a5b-0000-1000-8000-00805f9b34fb";

int myLastCrankRevolutions = -1;
int myLastCrankEventTime = -1;
int myCurrentCrankCadence = 0;

List<dynamic> roleList = [
  {'num': 1, 'label': 'Superuser'},
  {'num': 2, 'label': 'None Member '},
  {'num': 3, 'label': 'Member'},
  {'num': 4, 'label': 'Business'},
  {'num': 5, 'label': 'Instructor'},
  {'num': 6, 'label': 'O2O'},
  {'num': 7, 'label': 'Admin'}
];

List<dynamic> levels = [
  {'lid': 1, 'info': 'Easy'},
  {'lid': 2, 'info': 'Normal'},
  {'lid': 3, 'info': 'Hard'}
];

List<dynamic> vidType = [
  {'id': 0, 'type': 'All'},
  {'id': 1, 'type': 'T-Cycling'},
  {'id': 2, 'type': 'T-Box'}
];

// https://github.com/NordicSemiconductor/Android-BLE-Library/blob/master/ble-common/src/main/java/no/nordicsemi/android/ble/common/callback/csc/CyclingSpeedAndCadenceMeasurementDataCallback.java
/*
  cr = Crank Revolutions
  lcet = Last Crank Event Time
 */
void calculateCrankMesaurement(Peripheral device, int cr, int lcet) {
  if (myLastCrankEventTime == lcet) return;

  if (myLastCrankRevolutions >= 0) {
    double timeDifference;
    if (lcet < myLastCrankEventTime) {
      timeDifference = (65535 + lcet - myLastCrankEventTime) / 1024; // [s]
    } else {
      timeDifference = (lcet - myLastCrankEventTime) / 1024; // [s]
    }

    // double crankCadence = (crankRevolutions - gvars.myLastCrankRevolutions) * 60 / timeDifference; // [revolutions/minute]
    myCurrentCrankCadence = (cr - myLastCrankRevolutions) * 60 ~/ timeDifference;
    crankData = myCurrentCrankCadence.toString();
    distance = (cr * 6).toDouble() / 1000;
    distanceString = ((cr * 6).toDouble() / 1000).toString().substring(0, 3);

    // speed is current crank cadence * 3 = speed in meters per minute.
    // current crank cadence * 3 * 60 / 1000 = speed in km per hour
    speed = ((myCurrentCrankCadence * 6) * 60 / 1000);
    if (speed.toString().length > 4) {
      speedString = speed.toString().substring(0, 4);
    } else {
      speedString = speed.toString();
    }
    // print(myCurrentCrankCadence.toString());
    // print('cr: ' + cr.toString());
    // print("distance: " + distance.toString());
    // print("xx: " + ((crankRevolutions * 2).toDouble() / 1000).toString());
    // print("myCurrentCrankCadence: " + myCurrentCrankCadence.toString() );
  }
  myLastCrankRevolutions = cr;
  myLastCrankEventTime = lcet;
}

// https://pub.dev/packages/flutter_ble_lib
Future<void> addCrankListener() async {
  if (crankCharacteristic == null) {
    await cscDevice.discoverAllServicesAndCharacteristics();
    List<Characteristic> characteristics = await cscDevice?.characteristics(CADENCE_SERVICE_UUID);

    characteristics.forEach((characteristic) {
      if (characteristic.uuid.toString() == CAD_CRANK_UUID) {
        crankCharacteristic = characteristic;
      }
    });
  }
  crankCharacteristic?.monitor()?.listen((event) {
    print(event.toString());
    if (event.length > 4) {
      calculateCrankMesaurement(cscDevice, ((event[2] * 256) + event[1]), ((event[4] * 256) + event[3]));
    }
  });
  return;
}

// Future<void> removeCrankListener() async {
//   await crankCharacteristic.setNotifyValue(false);
// }

// Future<void> disconnectCscDevice() async {
//   await cscDevice.disconnect();
// }
