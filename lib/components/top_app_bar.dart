import 'package:flutter/material.dart';
import 'package:tboxapp/shared/global_vars.dart';

var logo = Image.asset(
  'assets/images/logo.png',
  width: 120,
  fit: BoxFit.fitWidth,
);

Widget buildbackButton(cntx) => IconButton(
      icon: Icon(Icons.keyboard_arrow_left),
      onPressed: () => Navigator.of(cntx).pop(),
    );

Widget buildFullAppBar(cntx) => AppBar(
      title: logo,
      actions: [
        // 공지사항
        IconButton(
            icon: Icon(Icons.bluetooth),
            onPressed: () {
              Navigator.pushNamed(cntx, "/ble_devices");
            }),
      ],
      iconTheme: IconThemeData(color: MyPrimaryYellowColor),
    );

Widget buildFullAppBarWithBack(cntx) => AppBar(
      leading: buildbackButton(cntx),
      title: logo,
      actions: [
        // 공지사항
        IconButton(
            icon: Icon(Icons.bluetooth),
            onPressed: () {
              Navigator.pushNamed(cntx, "/ble_devices");
            }),
      ],
      iconTheme: IconThemeData(color: MyPrimaryYellowColor),
    );
