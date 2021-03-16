import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:proj4dart/proj4dart.dart';
import 'package:tboxapp/shared/global_vars.dart' as gvars;

Point convert4326to5179(x, y) {
  //EPSG:5179 (korean) to EPSG:4326 (decimal)

  // Source https://pub.dev/packages/proj4dart/example
  // Define Point
  var pointSrc = Point(x: x, y: y);

  // Find Projection by name or define it if not exists
  var projSrc = Projection('EPSG:5179') ??
      Projection.add('EPSG:5179',
          '+proj=tmerc +lat_0=38 +lon_0=127.5 +k=0.9996 +x_0=1000000 +y_0=2000000 +ellps=GRS80 +units=m +no_defs');

  // Use built-in projection
  var projDst = Projection('EPSG:4326');

  // Forward transform (lonlat -> projected crs)
  var pointForward = projSrc.transform(projDst, pointSrc);
  // print('FORWARD: Transform point ${pointSrc.toArray()} from EPSG:4326 to EPSG:5179: ${pointForward.toArray()}');

  // Inverse transform (projected crs -> lonlat)
  // var pointInverse = projDst.transform(projSrc, pointForward);
  // print('INVERSE: Transform point ${pointForward.toArray()} from EPSG:5179 to EPSG:4326: ${pointInverse.toArray()}');

  return pointForward;
}

Future<bool> isLocationServiceEnabled() async {
  bool _serviceEnabled = await gvars.location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await gvars.location.requestService();
    if (!_serviceEnabled) {
      Fluttertoast.showToast(msg: "Location services are required for BLE devices");
      return false;
    }
  }
  return true;
}

Future<bool> isLocationPermissionGranted() async {
  PermissionStatus _permissionGranted = await gvars.location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied || _permissionGranted == PermissionStatus.deniedForever) {
    _permissionGranted = await gvars.location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      Fluttertoast.showToast(msg: "Please allow app to access location data");
      return false;
    }
  }
  return true;
}
