import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tboxapp/shared/global_vars.dart' as gvars;

final TextStyle overlayCateFont = const TextStyle(fontSize: 14.0, color: Colors.white);
final TextStyle overlayTextFont = const TextStyle(
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  shadows: <Shadow>[
    Shadow(offset: Offset(3.0, 3.0), blurRadius: 8, color: Colors.black38),
  ],
);
final TextStyle overlayTextFontSmall = const TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  shadows: <Shadow>[
    Shadow(offset: Offset(3.0, 3.0), blurRadius: 8, color: Colors.black38),
  ],
);

class TBoxDataRight extends StatefulWidget {
  const TBoxDataRight({Key key}) : super(key: key);
  @override
  TBoxDataRightState createState() => TBoxDataRightState();
}

class TBoxDataRightState extends State<TBoxDataRight> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Offset> offset;

  int touchCount;
  int touchCountText;
  String calText = "";
  double cal;

  bool isOpen = false;

  bool isTboxConnected;

  var subscription;
  List<List<int>> writeCommands;
  bool writing;

  // Send
  final int sidDeviceStatus = 0x00; // 0.toByte() ( Reply 128 / 0.80 )
  final int sidBatteryStatus = 0x01; // 1.toByte() ( Reply 129 / 0.81 )
  final int sidTouchNoti = 0x02; // 2.toByte() ( Reply 130 / 0.82 )
  final int sidPlayEffect = 0x10; // 16.toByte() ( Reply 144 / 0.90 )

  @override
  void initState() {
    super.initState();

    cal = 0;
    touchCount = 0;

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    final curve = CurvedAnimation(curve: Curves.decelerate, parent: _animationController);
    offset = Tween<Offset>(begin: Offset(0.99, 0.0), end: Offset.zero).animate(curve);

    if (gvars.tboxReadChar != null) {
      _setRead();
      _setReadNotifyValue();
      writeCommands = [];
      writing = false;
      isTboxConnected = true;
    } else {
      FlutterToast.showToast(msg: "tbox not connected");
      isTboxConnected = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var icon = SlideTransition(
      position: offset,
      child: Container(
        width: 120,
        child: Align(
          alignment: Alignment.centerRight,
          child: FlatButton(
            padding: EdgeInsets.all(0.0),
            child: isOpen
                ? Image.asset('assets/images/side_data_close_icon.png', fit: BoxFit.scaleDown)
                : Image.asset('assets/images/side_data_open_icon.png', fit: BoxFit.scaleDown),
            onPressed: () {
              switch (_animationController.status) {
                case AnimationStatus.completed:
                  _animationController.reverse();
                  setState(() {
                    isOpen = false;
                  });
                  break;
                case AnimationStatus.dismissed:
                  _animationController.forward();
                  setState(() {
                    isOpen = true;
                  });
                  break;
                default:
              }
            },
          ),
        ),
      ),
    );

    var rpmData = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 110,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Image(
                width: 25,
                height: 25,
                color: Colors.yellow,
                image: AssetImage('assets/images/rpm_icon.png'),
              ),
              Text("Touch Count", textAlign: TextAlign.left, style: overlayCateFont),
            ],
          ),
        ),
        SizedBox(
          width: 110,
          child: Container(
            child: Text(touchCount.toString(), textAlign: TextAlign.right, style: overlayTextFont),
          ),
        ),
      ],
    );

    var calData = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 110,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Image(
                width: 25,
                height: 25,
                color: Colors.yellow,
                image: AssetImage('assets/images/kcal_icon.png'),
              ),
              Text("KCAL", textAlign: TextAlign.left, style: overlayCateFont),
            ],
          ),
        ),
        SizedBox(
          width: 110,
          child: Container(
            child: Text((cal / 1.4).floor().toString(), textAlign: TextAlign.right, style: overlayTextFont),
          ),
        ),
      ],
    );

    var data = FadeTransition(
      opacity: _animationController,
      child: SlideTransition(
        position: offset,
        child: Row(
          children: <Widget>[
            Container(color: Colors.yellow, alignment: Alignment.topLeft, width: 2, height: 200),
            Container(
              width: 130,
              height: 200,
              color: Color.fromRGBO(0, 0, 0, 0.7),
              child: Row(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 10),
                          rpmData,
                          calData,
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Row(
      children: <Widget>[icon, Align(alignment: Alignment.centerRight, child: data)],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    subscription?.cancel();
    super.dispose();
  }

  _setRead() {
    gvars.tboxReadChar.monitor();
    subscription = gvars.tboxReadChar.monitor().listen((event) {
      _readTboxValue(event);
    });
    return;
  }

  _setReadNotifyValue() async {
    return;
  }

  _readTboxValue(value) {
    print('Received: ' + value.toString());
    if (value.length < 1) {
      print("Recieved empty, thus not valid");
      return;
    }
    if (value[0] != 84) {
      print("Recieved index 0 not valid");
      return;
    }
    if (value[1] == 1) {
      // T-Box Request Reply
      if (value[2] == 32) {
      } else if (value[2] == 128) {
      } else if (value[2] == 129) {
      } else if (value[2] == 130) {
      } else if (value[2] == 144) {
      } else {
        print("Recieved index 2 not valid");
        return;
      }
    } else if (value[1] == 2) {
      // T-Box Status & Battery Status
      if (value[2] == 129) {
        // value[3] is the amount of batter left
        FlutterToast.showToast(msg: "Battery Left: " + value[3]);
      } else if (value[2] == 160) {
        setState(() {
          cal += 0.1;
          touchCount += 1;
        });
        if (value[3] == 0) {
          //Front right
        } else if (value[3] == 1) {
          //Front left
        } else if (value[3] == 2) {
          //Back right
        } else if (value[3] == 3) {
          //Back left
        } else if (value[3] == 4) {
          // right
        } else if (value[3] == 5) {
          // left
        }
      } else {
        print("Recieved index 2 not valid");
      }
    } else {
      print("Recieved index 1 not valid");
    }
  }

  sendMessages() async {
    writing = true;
    while (writeCommands.length != 0) {
      try {
        // await gvars.tboxWriteChar.write(writeCommands[0]);
        await gvars.tboxWriteChar.write(writeCommands[0], true);
      } catch (error) {
        FlutterToast.showToast(msg: "Error with BLE write");
        print("Ble write message failed: " + writeCommands[0].toString());
        writing = false;
      }
      writeCommands.removeAt(0);
    }
    writing = false;
    print('writing was set false');
  }

  startCollectingData() {
    print("Started collecting data");
  }

  getData() {
    print("called get data");
    // TODO properly get current tbox data
    return 1;
  }
}

class CadenceDataRight extends StatefulWidget {
  const CadenceDataRight({Key key}) : super(key: key);
  @override
  CadenceDataRightState createState() => CadenceDataRightState();
}

class CadenceDataRightState extends State<CadenceDataRight> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Offset> offset;

  Timer _everyHalfSecond;

  double startDistance;
  String rpmText = "";
  String distanceText = "";
  String calText = "";
  double cal;
  int latestCrankEventTime;

  bool isOpen = false;

  @override
  void initState() {
    super.initState();

    cal = 0;
    startDistance = gvars.distance;
    _everyHalfSecond = Timer.periodic(Duration(milliseconds: 500), (Timer t) {
      setState(() {
        // print(gvars.crankData);
        if (latestCrankEventTime != gvars.myLastCrankEventTime) {
          latestCrankEventTime = gvars.myLastCrankEventTime;
          calText = gvars.caloriesBurned;
          cal = cal + 0.08;
          calText = cal.toString().split(".")[0] + "." + cal.toString().split(".")[1]?.substring(0, 2);

          rpmText = gvars.crankData;
          distanceText = (gvars.distance - startDistance).toString().substring(0, 3) + " km";
        }
      });
    });

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    final curve = CurvedAnimation(curve: Curves.decelerate, parent: _animationController);
    offset = Tween<Offset>(begin: Offset(0.99, 0.0), end: Offset.zero).animate(curve);
  }

  @override
  Widget build(BuildContext context) {
    var icon = SlideTransition(
      position: offset,
      child: Container(
        width: 120,
        child: Align(
          alignment: Alignment.centerRight,
          child: FlatButton(
            padding: EdgeInsets.all(0.0),
            child: isOpen
                ? Image.asset('assets/images/side_data_close_icon.png', fit: BoxFit.scaleDown)
                : Image.asset('assets/images/side_data_open_icon.png', fit: BoxFit.scaleDown),
            onPressed: () {
              switch (_animationController.status) {
                case AnimationStatus.completed:
                  _animationController.reverse();
                  setState(() {
                    isOpen = false;
                  });
                  break;
                case AnimationStatus.dismissed:
                  _animationController.forward();
                  setState(() {
                    isOpen = true;
                  });
                  break;
                default:
              }
            },
          ),
        ),
      ),
    );

    var rpmData = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 110,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Image(
                width: 25,
                height: 25,
                color: Colors.yellow,
                image: AssetImage('assets/images/rpm_icon.png'),
              ),
              Text("RPM", textAlign: TextAlign.left, style: overlayCateFont),
            ],
          ),
        ),
        SizedBox(
          width: 110,
          child: Container(
            child: Text(rpmText, textAlign: TextAlign.right, style: overlayTextFont),
          ),
        ),
      ],
    );

    var distanceData = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 110,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Image(
                width: 25,
                height: 25,
                color: Colors.yellow,
                image: AssetImage('assets/images/dist_icon.png'),
              ),
              Text("DISTANCE", textAlign: TextAlign.left, style: overlayCateFont),
            ],
          ),
        ),
        SizedBox(
          width: 110,
          child: Container(
            child: Text(distanceText, textAlign: TextAlign.right, style: overlayTextFont),
          ),
        ),
      ],
    );

    var calData = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 110,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Image(
                width: 25,
                height: 25,
                color: Colors.yellow,
                image: AssetImage('assets/images/kcal_icon.png'),
              ),
              Text("KCAL", textAlign: TextAlign.left, style: overlayCateFont),
            ],
          ),
        ),
        SizedBox(
          width: 110,
          child: Container(
            child: Text(calText, textAlign: TextAlign.right, style: overlayTextFont),
          ),
        ),
      ],
    );

    var data = FadeTransition(
      opacity: _animationController,
      child: SlideTransition(
        position: offset,
        child: Row(
          children: <Widget>[
            Container(color: Colors.yellow, alignment: Alignment.topLeft, width: 2, height: 200),
            Container(
              width: 130,
              height: 200,
              color: Color.fromRGBO(0, 0, 0, 0.7),
              child: Row(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 10),
                          rpmData,
                          distanceData,
                          calData,
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Row(
      children: <Widget>[icon, Align(alignment: Alignment.centerRight, child: data)],
    );
  }

  @override
  void dispose() {
    _everyHalfSecond.cancel();
    _animationController.dispose();
    super.dispose();
  }

  startCollectingData() {
    print("Started collecting data");
  }

  getData() {
    print("called get data");
    // TODO properly get current tcycling data
    return 1;
  }
}

class CadenceDataTop extends StatefulWidget {
  @override
  CadenceDataTopState createState() => CadenceDataTopState();
}

class CadenceDataTopState extends State<CadenceDataTop> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Offset> offset;

  Timer _everyHalfSecond;

  String rpmText = "";
  String distanceText = "";
  String calText = "";

  bool isOpen = false;

  @override
  void initState() {
    super.initState();

    _everyHalfSecond = Timer.periodic(Duration(milliseconds: 500), (Timer t) {
      setState(() {
        rpmText = gvars.crankData;
        distanceText = gvars.distanceString + " km";
        calText = gvars.caloriesBurned;
      });
    });

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    final curve = CurvedAnimation(curve: Curves.decelerate, parent: _animationController);
    offset = Tween<Offset>(begin: Offset(0.0, -0.99), end: Offset(0.0, 0.0)).animate(curve);
  }

  @override
  Widget build(BuildContext context) {
    var rpmData = SizedBox(
      width: 90,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            width: 25,
            height: 25,
            color: Colors.yellow,
            image: AssetImage('assets/images/rpm_icon.png'),
          ),
          // Text( "RPM", textAlign: TextAlign.left, style: gvars.overlayCateFont ),
          Text(rpmText + " rpm", textAlign: TextAlign.center, style: overlayTextFontSmall)
        ],
      ),
    );

    var distanceData = SizedBox(
      width: 90,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            width: 25,
            height: 25,
            color: Colors.yellow,
            image: AssetImage('assets/images/dist_icon.png'),
          ),
          // Text( "RPM", textAlign: TextAlign.left, style: gvars.overlayCateFont ),
          Text(distanceText, textAlign: TextAlign.center, style: overlayTextFontSmall)
        ],
      ),
    );

    var calData = SizedBox(
      width: 90,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            width: 25,
            height: 25,
            color: Colors.yellow,
            image: AssetImage('assets/images/kcal_icon.png'),
          ),
          // Text( "RPM", textAlign: TextAlign.left, style: gvars.overlayCateFont ),
          Text(calText + " cal", textAlign: TextAlign.center, style: overlayTextFontSmall)
        ],
      ),
    );

    var data = FadeTransition(
      opacity: _animationController,
      child: SlideTransition(
        position: offset,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomPaint(
              painter: TopDataPainter(),
              child: Container(
                width: 400,
                height: 50,
                alignment: Alignment(0.0, 0.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        rpmData,
                        distanceData,
                        calData,
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    var icon = SlideTransition(
      position: offset,
      child: Container(
        width: 400,
        height: 50,
        child: Align(
          alignment: Alignment.topCenter,
          child: IconButton(
            icon: isOpen ? Icon(Icons.keyboard_arrow_up) : Icon(Icons.keyboard_arrow_down),
            color: Colors.yellow,
            onPressed: () {
              switch (_animationController.status) {
                case AnimationStatus.completed:
                  _animationController.reverse();
                  setState(() {
                    isOpen = false;
                    debugPrint(isOpen.toString());
                  });
                  break;
                case AnimationStatus.dismissed:
                  _animationController.forward();
                  setState(() {
                    isOpen = true;
                  });
                  break;
                default:
              }
            },
          ),
        ),
      ),
    );

    return Column(
      children: <Widget>[ClipRect(child: Align(alignment: Alignment.centerRight, child: data)), icon],
    );
  }

  @override
  void dispose() {
    _everyHalfSecond.cancel();
    _animationController.dispose();
    super.dispose();
  }
}

class TopDataPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 0 - Gray Background
    var paint0 = Paint();
    paint0.color = Color(0xa0000000);
    paint0.style = PaintingStyle.fill;
    paint0.strokeWidth = 4;

    var path0 = Path();

    path0.moveTo(size.width * 0.10, size.height * -0.4);
    path0.conicTo(size.width * 0.16, size.height * 0.85, size.width * 0.5, size.height * 0.85, 30);
    path0.conicTo(size.width * 0.84, size.height * 0.85, size.width * 0.90, size.height * -0.4, 30);

    canvas.drawPath(path0, paint0);

    // 1 - Yellow To Brown Strip
    Rect rect1 = new Rect.fromCircle(center: new Offset(165.0, 55.0), radius: 180.0);
    var myGradient1 = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Colors.yellow, Colors.brown],
    );
    var paint1 = Paint();
    paint1.color = Colors.yellow;
    paint1.style = PaintingStyle.stroke;
    paint1.strokeWidth = 7;
    paint1.shader = myGradient1.createShader(rect1);

    var path1 = Path();

    path1.moveTo(size.width * 0.10, size.height * -0.1);
    path1.conicTo(size.width * 0.15, size.height * 0.95, size.width * 0.5, size.height * 0.95, 15);
    path1.conicTo(size.width * 0.85, size.height * 0.95, size.width * 0.9, size.height * -0.1, 15);

    canvas.drawPath(path1, paint1);

    // 2 - white Strip
    var paint2 = Paint();
    paint2.color = Colors.white;
    paint2.style = PaintingStyle.stroke;
    paint2.strokeWidth = 4;

    var path2 = Path();

    path2.moveTo(size.width * 0.10, size.height * -0.4);
    path2.conicTo(size.width * 0.16, size.height * .85, size.width * 0.5, size.height * 0.85, 30);
    path2.conicTo(size.width * 0.84, size.height * .85, size.width * 0.90, size.height * -0.4, 30);

    canvas.drawPath(path2, paint2);

    // 3 - Light gray to bgcolor Strip
    Rect rect3 = new Rect.fromCircle(center: new Offset(165.0, 55.0), radius: 180.0);
    var myGradient3 = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0x60000000), Color(0xa0000000)],
    );
    var paint3 = Paint();
    paint3.color = Color(0xa0000000);
    paint3.style = PaintingStyle.stroke;
    paint3.strokeWidth = 3;
    paint3.shader = myGradient3.createShader(rect3);

    var path3 = Path();

    path3.moveTo(size.width * 0.12, size.height * -0.15);
    path3.conicTo(size.width * 0.21, size.height * 0.08, size.width * 0.5, size.height * 0.08, 25);
    path3.conicTo(size.width * 0.79, size.height * 0.08, size.width * 0.88, size.height * -0.15, 25);

    canvas.drawPath(path3, paint3);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
