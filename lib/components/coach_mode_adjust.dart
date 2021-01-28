import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tboxapp/shared/global_vars.dart' as gvars;
import 'package:tboxapp/components/countdown_timer.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class CoachModeAdjust extends StatefulWidget {
  @override
  CoachModeAdjustState createState() => CoachModeAdjustState();
}

class CoachModeAdjustState extends State<CoachModeAdjust> with TickerProviderStateMixin {
  double myWidth = 400.0;
  double myHeight = 400.0;
  double bodyWidth = 700;
  TextStyle s = TextStyle(color: Colors.white);
  TextStyle fontSize90 = TextStyle(fontSize: 90);
  TextStyle fontSize80 = TextStyle(fontSize: 80);
  TextStyle setTimeStyle = TextStyle(color: Colors.white, fontSize: 60);

  AssetsAudioPlayer aap;

  final int tileBgColor = 0x55ECEEF0;

  String timeMode;
  String myState;

  String minStr;
  String secStr;
  String msecStr;
  Stopwatch myStopwatch;
  Timer stopwatchPeriodical;

  int cdtMin;
  int cdtSec;
  int cdtMsec;
  int cdtMinStart;
  int cdtSecStart;
  int cdtMsecStart;
  CountdownTimer myCdt;
  int cdtEndTime;

  int totalSetCount;
  int currentSetCount;
  int totalTouchCount;
  int currentTouchCount;

  Map myLog;
  int myLogCounter;

  var setTimeHeader;
  var setTimeBody;
  int setTimeMin;
  int setTimeSec;
  var restTimeHeader;
  var restTimeBody;
  int restTimeMin;
  int restTimeSec;
  int restTimeSecSelIdx;
  var setHeader;
  var setBody;
  int setCount;
  var touchCountHeader;
  var touchCountBody;
  int touchCount;
  int touchCountSelIdx;
  var reactionTimeHeader;
  var reactionTimeBody;
  double reactionSec;
  int reactionSecSelIdx;
  var signalHeader;
  var signalBody;
  var lightModeHeader;
  var lightModeBody;
  var lightMotionHeader;
  var lightMotionBody;
  int latestTouchTime;

  AnimationController setTimeController;
  Animation<Offset> setTimeOffset;
  AnimationController restTimeController;
  Animation<Offset> restTimeOffset;
  AnimationController setController;
  Animation<Offset> setOffset;
  AnimationController touchCountController;
  Animation<Offset> touchCountOffset;
  AnimationController reactionTimeController;
  Animation<Offset> reactionTimeOffset;
  AnimationController signalController;
  Animation<Offset> signalOffset;
  AnimationController lightModeController;
  Animation<Offset> lightModeOffset;
  AnimationController lightMotionController;
  Animation<Offset> lightMotionOffset;

  int selIdx;

  int lightModeTL;
  int lightModeTR;
  int lightModeBL;
  int lightModeBR;
  int lightModeSelColorInt;
  int lightMotionIdx;
  final int offColorInt = 0xFFC4c4c4;

  TextEditingController toSaveTextController;
  String toSaveName;

  var readSubscription;
  List<List<int>> writeCommands = [];
  bool writing = false;

  @override
  void initState() {
    super.initState();
    aap = AssetsAudioPlayer();

    timeMode = 'setTime';
    myState = 'stopped';

    minStr = '00';
    secStr = '00';
    msecStr = '00';
    myStopwatch = Stopwatch();
    stopwatchPeriodical = Timer.periodic(Duration(milliseconds: 10), (Timer t) {
      setState(() {
        minStr = (myStopwatch.elapsed.inMinutes % 60).floor().toString().padLeft(2, '0');
        secStr = (myStopwatch.elapsed.inSeconds % 60).floor().toString().padLeft(2, '0');
        msecStr = (myStopwatch.elapsed.inMilliseconds % 1000).floor().toString().padLeft(2, '0').substring(0, 2);
      });
    });

    cdtMin = 0;
    cdtSec = 0;
    cdtMsec = 0;
    cdtMinStart = 0;
    cdtSecStart = 0;
    cdtMsecStart = 0;
    cdtEndTime = 0;
    // CountdownTimer myCdt;

    totalSetCount = 0;
    currentSetCount = 1;
    totalTouchCount = 0;
    currentTouchCount = 0;

    myLog = {};
    myLogCounter = 0;

    setTimeMin = 0;
    setTimeSec = 0;
    restTimeMin = 0;
    restTimeSec = 0;
    restTimeSecSelIdx = 0;
    setCount = 1;
    touchCount = 0;
    touchCountSelIdx = 0;
    reactionSec = 0.0;
    reactionSecSelIdx = 0;
    latestTouchTime = 0;

    setTimeController = AnimationController(vsync: this, duration: Duration(milliseconds: 0));
    setTimeOffset = Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset.zero).animate(setTimeController);

    restTimeController = AnimationController(vsync: this, duration: Duration(milliseconds: 0));
    restTimeOffset = Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset.zero).animate(restTimeController);

    setController = AnimationController(vsync: this, duration: Duration(milliseconds: 0));
    setOffset = Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset.zero).animate(setController);

    touchCountController = AnimationController(vsync: this, duration: Duration(milliseconds: 0));
    touchCountOffset = Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset.zero).animate(touchCountController);

    reactionTimeController = AnimationController(vsync: this, duration: Duration(milliseconds: 0));
    reactionTimeOffset = Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset.zero).animate(reactionTimeController);

    signalController = AnimationController(vsync: this, duration: Duration(milliseconds: 0));
    signalOffset = Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset.zero).animate(signalController);

    lightModeController = AnimationController(vsync: this, duration: Duration(milliseconds: 0));
    lightModeOffset = Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset.zero).animate(lightModeController);

    lightMotionController = AnimationController(vsync: this, duration: Duration(milliseconds: 0));
    lightMotionOffset = Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset.zero).animate(lightMotionController);

    selIdx = 0;
    lightModeTL = 0xFFFFFF00;
    lightModeTR = 0xFFFFFF00;
    lightModeBL = 0xFFFFFF00;
    lightModeBR = 0xFFFFFF00;
    lightModeSelColorInt = 0xFFFFFF00;
    lightMotionIdx = 0;

    toSaveTextController = TextEditingController();
    toSaveName = '';
    _setRead();
  }

  _setRead() async {
    if (gvars.isTboxConnected) {
      // await gvars.tboxReadChar.setNotifyValue(true);
      if (readSubscription == null) {
        gvars.tboxReadChar.monitor();
        readSubscription = gvars.tboxReadChar.monitor()?.listen((value) {
          _readTboxValue(value);
        });
      }
      // sendMessage([gvars.packetHeader, 0x02, 0x02, 0x01, 0x01]);
    } else {
      FlutterToast.showToast(msg: "Please connect T-Box");
    }
  }

  @override
  Widget build(BuildContext context) {
    myWidth = MediaQuery.of(context).size.width;
    myHeight = MediaQuery.of(context).size.height;

    return _buildBody();
  }

  _buildBody() {
    setTimeHeader = _buildHeader(
        setTimeController, 'setTime', '운동시간', Text(setTimeMin.toString() + 'm ' + setTimeSec.toString() + 's '));

    setTimeBody = ClipRect(
      child: SlideTransition(
          position: setTimeOffset,
          child: Container(
            width: myWidth,
            height: 150,
            decoration: BoxDecoration(
              color: Color(tileBgColor),
              border: Border.all(width: 1, color: gvars.MyPrimaryYellowColor),
            ),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: setTimeMin),
                        itemExtent: 26,
                        useMagnifier: true,
                        magnification: 1.4,
                        // squeeze: 1.6,
                        diameterRatio: 0.6,
                        onSelectedItemChanged: (value) {
                          setTimeMin = value;
                        },
                        children: [
                          Text('00', style: s),
                          Text('01', style: s),
                          Text('02', style: s),
                          Text('03', style: s),
                          Text('04', style: s),
                          Text('05', style: s),
                          Text('06', style: s),
                          Text('07', style: s),
                          Text('08', style: s),
                          Text('09', style: s),
                          Text('10', style: s),
                          Text('11', style: s),
                          Text('12', style: s),
                          Text('13', style: s),
                          Text('14', style: s),
                          Text('15', style: s),
                          Text('16', style: s),
                          Text('17', style: s),
                          Text('18', style: s),
                          Text('19', style: s),
                          Text('20', style: s),
                          Text('21', style: s),
                          Text('22', style: s),
                          Text('23', style: s),
                          Text('24', style: s),
                          Text('25', style: s),
                          Text('26', style: s),
                          Text('27', style: s),
                          Text('28', style: s),
                          Text('29', style: s),
                          Text('30', style: s),
                          Text('31', style: s),
                          Text('32', style: s),
                          Text('33', style: s),
                          Text('34', style: s),
                          Text('35', style: s),
                          Text('36', style: s),
                          Text('37', style: s),
                          Text('38', style: s),
                          Text('39', style: s),
                          Text('40', style: s),
                          Text('41', style: s),
                          Text('42', style: s),
                          Text('43', style: s),
                          Text('44', style: s),
                          Text('45', style: s),
                          Text('46', style: s),
                          Text('47', style: s),
                          Text('48', style: s),
                          Text('49', style: s),
                          Text('50', style: s),
                          Text('51', style: s),
                          Text('52', style: s),
                          Text('53', style: s),
                          Text('54', style: s),
                          Text('55', style: s),
                          Text('56', style: s),
                          Text('57', style: s),
                          Text('58', style: s),
                          Text('59', style: s)
                        ]),
                  ),
                  Text('m ', style: setTimeStyle),
                  Container(
                    width: 100,
                    child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: setTimeSec),
                        itemExtent: 26,
                        useMagnifier: true,
                        magnification: 1.4,
                        // squeeze: 1.6,
                        diameterRatio: 0.6,
                        onSelectedItemChanged: (value) {
                          setTimeSec = value;
                        },
                        children: [
                          Text('00', style: s),
                          Text('01', style: s),
                          Text('02', style: s),
                          Text('03', style: s),
                          Text('04', style: s),
                          Text('05', style: s),
                          Text('06', style: s),
                          Text('07', style: s),
                          Text('08', style: s),
                          Text('09', style: s),
                          Text('10', style: s),
                          Text('11', style: s),
                          Text('12', style: s),
                          Text('13', style: s),
                          Text('14', style: s),
                          Text('15', style: s),
                          Text('16', style: s),
                          Text('17', style: s),
                          Text('18', style: s),
                          Text('19', style: s),
                          Text('20', style: s),
                          Text('21', style: s),
                          Text('22', style: s),
                          Text('23', style: s),
                          Text('24', style: s),
                          Text('25', style: s),
                          Text('26', style: s),
                          Text('27', style: s),
                          Text('28', style: s),
                          Text('29', style: s),
                          Text('30', style: s),
                          Text('31', style: s),
                          Text('32', style: s),
                          Text('33', style: s),
                          Text('34', style: s),
                          Text('35', style: s),
                          Text('36', style: s),
                          Text('37', style: s),
                          Text('38', style: s),
                          Text('39', style: s),
                          Text('40', style: s),
                          Text('41', style: s),
                          Text('42', style: s),
                          Text('43', style: s),
                          Text('44', style: s),
                          Text('45', style: s),
                          Text('46', style: s),
                          Text('47', style: s),
                          Text('48', style: s),
                          Text('49', style: s),
                          Text('50', style: s),
                          Text('51', style: s),
                          Text('52', style: s),
                          Text('53', style: s),
                          Text('54', style: s),
                          Text('55', style: s),
                          Text('56', style: s),
                          Text('57', style: s),
                          Text('58', style: s),
                          Text('59', style: s),
                        ]),
                  ),
                  Text('s ', style: setTimeStyle),
                ],
              ),
            ),
          )),
    );

    restTimeHeader = _buildHeader(
        restTimeController, 'restTime', '휴식', Text(restTimeMin.toString() + 'm ' + restTimeSec.toString() + 's'));

    restTimeBody = ClipRect(
      child: SlideTransition(
          position: restTimeOffset,
          child: Container(
            height: 150,
            width: myWidth,
            decoration: BoxDecoration(
              color: Color(tileBgColor),
              border: Border.all(width: 1, color: gvars.MyPrimaryYellowColor),
            ),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: restTimeMin),
                        itemExtent: 26,
                        useMagnifier: true,
                        magnification: 1.4,
                        // squeeze: 1.6,
                        diameterRatio: 0.6,
                        onSelectedItemChanged: (value) {
                          restTimeMin = value;
                        },
                        children: [
                          Text('00', style: s),
                          Text('01', style: s),
                          Text('02', style: s),
                          Text('03', style: s),
                          Text('04', style: s),
                          Text('05', style: s),
                          Text('06', style: s),
                          Text('07', style: s),
                          Text('08', style: s),
                          Text('09', style: s),
                          Text('10', style: s),
                        ]),
                  ),
                  Text('m ', style: setTimeStyle),
                  Container(
                    width: 100,
                    child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: restTimeSecSelIdx),
                        itemExtent: 26,
                        useMagnifier: true,
                        magnification: 1.4,
                        // squeeze: 1.6,
                        diameterRatio: 0.6,
                        onSelectedItemChanged: (value) {
                          restTimeSec = value * 10;
                          restTimeSecSelIdx = value;
                        },
                        children: [
                          Text('00', style: s),
                          Text('10', style: s),
                          Text('20', style: s),
                          Text('30', style: s),
                          Text('40', style: s),
                          Text('50', style: s),
                        ]),
                  ),
                  Text('s ', style: setTimeStyle),
                ],
              ),
            ),
          )),
    );

    setHeader = _buildHeader(setController, 'set', '세트', Text(setCount.toString()));

    setBody = ClipRect(
      child: SlideTransition(
          position: setOffset,
          child: Container(
            height: 150,
            width: myWidth,
            decoration: BoxDecoration(
              color: Color(tileBgColor),
              border: Border.all(width: 1, color: gvars.MyPrimaryYellowColor),
            ),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: setCount),
                        itemExtent: 26,
                        useMagnifier: true,
                        magnification: 1.4,
                        // squeeze: 1.6,
                        diameterRatio: 0.6,
                        onSelectedItemChanged: (value) {
                          setCount = value + 1;
                        },
                        children: [
                          Text('01', style: s),
                          Text('02', style: s),
                          Text('03', style: s),
                          Text('04', style: s),
                          Text('05', style: s),
                          Text('06', style: s),
                          Text('07', style: s),
                          Text('08', style: s),
                          Text('09', style: s),
                          Text('10', style: s),
                        ]),
                  ),
                ],
              ),
            ),
          )),
    );

    touchCountHeader = _buildHeader(touchCountController, 'touchCount', '터치횟수', Text(touchCount.toString()));

    touchCountBody = ClipRect(
      child: SlideTransition(
          position: touchCountOffset,
          child: Container(
            height: 150,
            width: myWidth,
            decoration: BoxDecoration(
              color: Color(tileBgColor),
              border: Border.all(width: 1, color: gvars.MyPrimaryYellowColor),
            ),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: touchCountSelIdx),
                        itemExtent: 26,
                        useMagnifier: true,
                        magnification: 1.4,
                        // squeeze: 1.6,
                        diameterRatio: 0.6,
                        onSelectedItemChanged: (value) {
                          touchCountSelIdx = value;
                          if (value <= 16) {
                            touchCount = value;
                          } else if (value == 17) {
                            touchCount = 20;
                          } else if (value <= 18) {
                            touchCount = 25;
                          }
                        },
                        children: [
                          Text('00', style: s),
                          Text('01', style: s),
                          Text('02', style: s),
                          Text('03', style: s),
                          Text('04', style: s),
                          Text('05', style: s),
                          Text('06', style: s),
                          Text('07', style: s),
                          Text('08', style: s),
                          Text('09', style: s),
                          Text('10', style: s),
                          Text('11', style: s),
                          Text('12', style: s),
                          Text('13', style: s),
                          Text('14', style: s),
                          Text('15', style: s),
                          Text('16', style: s),
                          Text('20', style: s),
                          Text('25', style: s),
                        ]),
                  ),
                ],
              ),
            ),
          )),
    );

    reactionTimeHeader =
        _buildHeader(reactionTimeController, 'reactionTime', '반응시간', Text(reactionSec.toString() + " s"));

    reactionTimeBody = ClipRect(
      child: SlideTransition(
          position: reactionTimeOffset,
          child: Container(
            height: 150,
            width: myWidth,
            decoration: BoxDecoration(
                color: Color(tileBgColor), border: Border.all(width: 1, color: gvars.MyPrimaryYellowColor)),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: reactionSecSelIdx),
                        itemExtent: 26,
                        useMagnifier: true,
                        magnification: 1.4,
                        // squeeze: 1.6,
                        diameterRatio: 0.6,
                        onSelectedItemChanged: (value) {
                          reactionSecSelIdx = value;
                          if (value < 6) {
                            reactionSec = (value / 10);
                          } else if (value == 6) {
                            reactionSec = 1;
                          } else if (value == 7) {
                            reactionSec = 1.5;
                          } else if (value == 8) {
                            reactionSec = 2.0;
                          }
                        },
                        children: [
                          Text('0.0 s', style: s),
                          Text('0.1 s', style: s),
                          Text('0.2 s', style: s),
                          Text('0.3 s', style: s),
                          Text('0.4 s', style: s),
                          Text('0.5 s', style: s),
                          Text('1.0 s', style: s),
                          Text('1.5 s', style: s),
                          Text('2.0 s', style: s),
                        ]),
                  ),
                ],
              ),
            ),
          )),
    );

    signalHeader = _buildHeader(signalController, 'signal', '시그널', Text(getSelectedSignalName(selIdx)));

    signalBody = ClipRect(
      child: SlideTransition(
          position: signalOffset,
          child: Container(
            height: 200,
            width: myWidth,
            decoration: BoxDecoration(
                color: Color(tileBgColor), border: Border.all(width: 1, color: gvars.MyPrimaryYellowColor)),
            // child: adjustSignalWidget
            // child: coachSignalWidget
            child: CupertinoPicker(
                scrollController: FixedExtentScrollController(initialItem: selIdx),
                itemExtent: 26,
                // looping: true,
                useMagnifier: true,
                magnification: 1.2,
                onSelectedItemChanged: (value) {
                  selIdx = value;
                },
                children: [
                  Text('Whistle', style: s),
                  Text('Ready Set Go', style: s),
                  Text('titalau', style: s),
                  Text('bigbang', style: s),
                  Text('bebemon', style: s),
                  Text('b1a4', style: s),
                ]),
          )),
    );

    lightModeHeader = _buildHeader(lightModeController, 'lightMode', '조명모드', Text(''));

    lightModeBody = ClipRect(
      child: SlideTransition(
        position: lightModeOffset,
        child: Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(tileBgColor),
            border: Border.all(width: 1, color: gvars.MyPrimaryYellowColor),
          ),
          child: Center(
            child: Container(
              width: myWidth * 0.7,
              height: myHeight * 0.7,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // TOP LEFT BUTTON
                      GestureDetector(
                        onTap: () {
                          if (lightModeTL == offColorInt) {
                            setState(() {
                              lightModeTL = lightModeSelColorInt;
                            });
                          } else {
                            setState(() {
                              lightModeTL = offColorInt;
                            });
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Color(lightModeTL),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              lightModeTL != offColorInt
                                  ? BoxShadow(
                                      color: Color(lightModeTL),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                    )
                                  : BoxShadow(),
                            ],
                          ),
                        ),
                      ),
                      Text('후면', style: TextStyle(color: gvars.MyPrimaryYellowColor, fontSize: 18)),
                      // TOP LEFT BUTTON
                      GestureDetector(
                        onTap: () {
                          if (lightModeTR == offColorInt) {
                            setState(() {
                              lightModeTR = lightModeSelColorInt;
                            });
                          } else {
                            setState(() {
                              lightModeTR = offColorInt;
                            });
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Color(lightModeTR),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              lightModeTR != offColorInt
                                  ? BoxShadow(
                                      color: Color(lightModeTR),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                    )
                                  : BoxShadow(),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Image.asset('assets/images/tbox.png')],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // BOTTOM LEFT BUTTON
                      GestureDetector(
                        onTap: () {
                          if (lightModeBL == offColorInt) {
                            setState(() {
                              lightModeBL = lightModeSelColorInt;
                            });
                          } else {
                            setState(() {
                              lightModeBL = offColorInt;
                            });
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Color(lightModeBL),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              lightModeBL != offColorInt
                                  ? BoxShadow(
                                      color: Color(lightModeBL),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                    )
                                  : BoxShadow(),
                            ],
                          ),
                        ),
                      ),
                      Text('전면', style: TextStyle(color: gvars.MyPrimaryYellowColor, fontSize: 18)),
                      // BOTTOM RIGHT BUTTON
                      GestureDetector(
                          onTap: () {
                            if (lightModeBR == offColorInt) {
                              setState(() {
                                lightModeBR = lightModeSelColorInt;
                              });
                            } else {
                              setState(() {
                                lightModeBR = offColorInt;
                              });
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Color(lightModeBR),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                lightModeBR != offColorInt
                                    ? BoxShadow(
                                        color: Color(lightModeBR),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                      )
                                    : BoxShadow(),
                              ],
                            ),
                          ))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildColorButton(0xFFC32A2A, 0xFFFF0000), // Red
                      _buildColorButton(0xFFCD712E, 0xFFCD712E), // Orange
                      _buildColorButton(0xFFD5CE2C, 0xFFFFFF00), // Yellow
                      _buildColorButton(0xFF30CC36, 0xFF00FF00), // Green
                      _buildColorButton(0xFF3887D0, 0xFF3887D0), // Light Blue
                      _buildColorButton(0xFF191774, 0xFF0000FF), // Blue
                      _buildColorButton(0xFF6B1980, 0xFF6B1980), // Purple
                      _buildColorButton(0xFFFFFFFF, 0xFFFFFFFF), // White
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    lightMotionHeader =
        _buildHeader(lightMotionController, 'lightMotion', '라이트모션', Text(_getSelectedLightMode(lightMotionIdx)));

    lightMotionBody = ClipRect(
      child: SlideTransition(
          position: lightMotionOffset,
          child: Container(
            height: 200,
            width: myWidth,
            decoration: BoxDecoration(
              color: Color(tileBgColor),
              border: Border.all(width: 1, color: gvars.MyPrimaryYellowColor),
            ),
            child: CupertinoPicker(
                scrollController: FixedExtentScrollController(initialItem: lightMotionIdx),
                itemExtent: 26,
                // looping: true,
                useMagnifier: true,
                magnification: 1.2,
                onSelectedItemChanged: (value) {
                  lightMotionIdx = value;
                },
                children: [
                  Text('Normal', style: s),
                  Text('Reactive', style: s),
                  Text('Circle 1', style: s),
                  Text('Circle 2', style: s),
                  Text('Breathing', style: s),
                  Text('Twinkle', style: s),
                  Text('Gradient', style: s),
                ]),
          )),
    );

    var getSettingListButton = GestureDetector(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.folder_open, color: gvars.MyPrimaryYellowColor),
          Text('세팅 리스트'),
        ],
      ),
      onTap: () {
        Navigator.pushNamed(context, '/coach_adjust_preset');
      },
    );

    var saveSettingDialogCancel = FlatButton(
      child: Text("취소", style: TextStyle(color: gvars.MyPrimaryYellowColor)),
      onPressed: () {
        // setState((){
        //   this.toSaveName = toSaveTextController.text;
        // });
        Navigator.pop(context);
      },
    );

    var saveSettingDialogConfirm = FlatButton(
      child: Text("확인", style: TextStyle(color: gvars.MyPrimaryYellowColor)),
      onPressed: () {
        // setState(() {
        //   if (toSaveTextController.text == null) {
        //     toSaveName = '';
        //   } else {
        //     toSaveName = toSaveTextController.text;
        //   }
        // });
        if (toSaveTextController.text != null && toSaveTextController.text != '') {
          // _addCoachSaved();
          Navigator.pop(context);
        } else {
          FlutterToast.showToast(msg: "Name cannot be empty");
        }
      },
    );

    var saveSettingButton = GestureDetector(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(
          Icons.save_alt,
          color: gvars.MyPrimaryYellowColor,
        ),
        Text('세팅저장')
      ]),
      onTap: () {
        showDialog(
          context: context,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text("세팅 저장"),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "리스트 이름"),
                    controller: toSaveTextController,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      saveSettingDialogCancel,
                      saveSettingDialogConfirm,
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );

    var exerciseStateBadge = myState == "inSet"
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.red,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 12),
              child: Text('운동중'),
            ),
          )
        : myState == "inRest"
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.green,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 12),
                  child: Text('휴식중'),
                ),
              )
            : Container();

    var myCdt = CountdownTimer(
      endTime: cdtEndTime ?? 0,
      onEnd: () {
        if (myState == "inSet" && currentSetCount < totalSetCount) {
          if (gvars.isTboxConnected) {
            _stopAdjustLights();
          }
          myState = "inRest";
          cdtEndTime = DateTime.now().millisecondsSinceEpoch + (restTimeMin * 60 * 1000) + (restTimeSec * 1000);
          print('resttime starting');
        } else if (myState == "inRest" && currentSetCount < totalSetCount) {
          if (gvars.isTboxConnected) {
            _startAdjustLights();
          }
          myState = "inSet";
          currentSetCount++;
          cdtEndTime = DateTime.now().millisecondsSinceEpoch + (setTimeMin * 60 * 1000) + (setTimeSec * 1000);

          currentTouchCount = 0;
          _addSetToLog();

          print('settime starting');
        } else {
          if (gvars.isTboxConnected) {
            _stopAdjustLights();
          }
          myState = "stopped";
          cdtMin = 0;
          cdtSec = 0;
          cdtMsec = 0;
          print('ending adjust cdt');
          _showViewLogDialog(context);
        }
      },
    );

    var cdtRow = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text("${cdtMin.toString().padLeft(2, '0')}", style: TextStyle(fontSize: 80.0)),
        Text("m ", style: TextStyle(fontSize: 30.0)),
        Text("${cdtSec.toString().padLeft(2, '0')}", style: TextStyle(fontSize: 80.0)),
        Text("s ", style: TextStyle(fontSize: 30.0)),
        Text("${cdtMsec.toString().padLeft(2, '0').substring(0, 2)}", style: TextStyle(fontSize: 80.0)),
        Text("ms", style: TextStyle(fontSize: 30.0)),
      ],
    );

    var myRow = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text("${minStr.toString().padLeft(2, '0')}", style: TextStyle(fontSize: 80.0)),
        Text("m ", style: TextStyle(fontSize: 30.0)),
        Text("${secStr.toString().padLeft(2, '0')}", style: TextStyle(fontSize: 80.0)),
        Text("s ", style: TextStyle(fontSize: 30.0)),
        Text("${msecStr.toString().padLeft(2, '0').substring(0, 2)}", style: TextStyle(fontSize: 80.0)),
        Text("ms", style: TextStyle(fontSize: 30.0)),
      ],
    );

    var touchTracker = Expanded(
      flex: 1,
      child: Center(
        child: Row(
          children: [
            Text('터치', style: TextStyle(fontSize: 30)),
            Container(width: 10),
            Text(currentTouchCount.toString() + '/' + totalTouchCount.toString(), style: TextStyle(fontSize: 56)),
          ],
        ),
      ),
    );

    var vertDivider = Container(
      height: 50,
      child: Center(
        child: VerticalDivider(thickness: 1, color: Colors.white, indent: 10, endIndent: 10),
      ),
    );

    var setTracker = Expanded(
      flex: 1,
      child: Center(
        child: Row(
          children: [
            Text('세트', style: TextStyle(fontSize: 30)),
            Container(width: 10),
            Text(currentSetCount.toString() + '/' + totalSetCount.toString(), style: TextStyle(fontSize: 56)),
          ],
        ),
      ),
    );

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        constraints: BoxConstraints(maxWidth: bodyWidth),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                !gvars.isTboxConnected
                    ? Row(
                        children: [
                          Icon(Icons.bluetooth_disabled, color: Colors.red),
                          Text('T-BOX 디바이스를 연결해주세요', style: TextStyle(color: Colors.red))
                        ],
                      )
                    : Container(),
                SizedBox(height: 15),
                exerciseStateBadge,
                (timeMode == 'setTime' || timeMode == 'setTime and touchCount') &&
                        (myState == "inSet" || myState == "inRest")
                    ? myCdt
                    : (timeMode == 'setTime' || timeMode == 'setTime and touchCount') && myState == "stopped"
                        ? cdtRow
                        : !(timeMode == 'setTime' || timeMode == 'setTime and touchCount')
                            ? myRow
                            : Container(),
                totalSetCount != 0
                    ? Row(
                        children: [
                          touchTracker,
                          vertDivider,
                          setTracker,
                        ],
                      )
                    : Container(),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: myState != "stopped"
                          ? _buildYellowButton("PAUSE", Icons.pause, () => _adjustPausePressed())
                          : _buildYellowButton("START", Icons.play_arrow, () => _adjustStartPressed()),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 4,
                      child: _buildYellowButton("STOP", Icons.stop, () => _adjustStopPressed()),
                    ),
                    SizedBox(width: 10),
                    FlatButton(
                      shape: CircleBorder(),
                      color: gvars.MyPrimaryYellowColor,
                      onPressed: () {
                        _playSignal();
                      },
                      child: Icon(Icons.volume_up, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("설정", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    Row(
                      children: [
                        getSettingListButton,
                        SizedBox(width: 15),
                        saveSettingButton,
                      ],
                    ),
                  ],
                ),
                Divider(color: Colors.white, thickness: 2),
                setTimeHeader,
                setTimeController.status != AnimationStatus.dismissed ? setTimeBody : Container(),
                SizedBox(height: 20),
                restTimeHeader,
                restTimeController.status != AnimationStatus.dismissed ? restTimeBody : Container(),
                SizedBox(height: 20),
                setHeader,
                setController.status != AnimationStatus.dismissed ? setBody : Container(),
                SizedBox(height: 20),
                touchCountHeader,
                touchCountController.status != AnimationStatus.dismissed ? touchCountBody : Container(),
                SizedBox(height: 20),
                reactionTimeHeader,
                reactionTimeController.status != AnimationStatus.dismissed ? reactionTimeBody : Container(),
                SizedBox(height: 20),
                signalHeader,
                signalController.status != AnimationStatus.dismissed ? signalBody : Container(),
                SizedBox(height: 20),
                lightModeHeader,
                lightModeController.status != AnimationStatus.dismissed ? lightModeBody : Container(),
                SizedBox(height: 20),
                lightMotionHeader,
                lightMotionController.status != AnimationStatus.dismissed ? lightMotionBody : Container(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildHeader(myController, openStr, mainLabel, selPreview) {
    return Container(
      width: myWidth,
      color: Color(tileBgColor),
      child: OutlineButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        borderSide: myController.status == AnimationStatus.dismissed
            ? BorderSide(color: Colors.transparent)
            : BorderSide(color: gvars.MyPrimaryYellowColor),
        highlightedBorderColor: gvars.MyPrimaryYellowColor,
        onPressed: () {
          _closeOpenContainers(openStr);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(mainLabel),
            selPreview,
          ],
        ),
      ),
    );
  }

  Widget _buildYellowButton(myText, icon, callback) {
    return FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: gvars.MyPrimaryYellowColor,
      onPressed: callback,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(myText, style: TextStyle(color: Colors.black)),
        SizedBox(width: 1),
        Icon(icon, color: Colors.black)
      ]),
    );
  }

  Widget _buildColorButton(displayColorInt, actualColorInt) {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        color: Color(displayColorInt),
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          actualColorInt == lightModeSelColorInt
              ? BoxShadow(
                  color: Colors.white,
                  spreadRadius: 3,
                  blurRadius: 8,
                )
              : BoxShadow(
                  color: Colors.transparent,
                ),
        ],
      ),
      child: FlatButton(
        onPressed: () {
          lightModeSelColorInt = actualColorInt;
        },
        child: Container(),
      ),
    );
  }

  _readTboxValue(value) {
    print(value.toString());
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
        if (value[3] == 0) {
          //Front right
          if (myState == "inSet" &&
              (reactionSec == 0 || (DateTime.now().millisecondsSinceEpoch > latestTouchTime + (reactionSec * 1000))) &&
              (lightModeBR != offColorInt)) {
            currentTouchCount++;
            _addTouchToLog("전면 오른쪽");
          }
        } else if (value[3] == 1) {
          //Front left
          if (myState == "inSet" &&
              (reactionSec == 0 || (DateTime.now().millisecondsSinceEpoch > latestTouchTime + (reactionSec * 1000))) &&
              (lightModeBL != offColorInt)) {
            currentTouchCount++;
            _addTouchToLog("전면 왼쪽");
          }
        } else if (value[3] == 2) {
          //Back right
          if (myState == "inSet" &&
              (reactionSec == 0 || (DateTime.now().millisecondsSinceEpoch > latestTouchTime + (reactionSec * 1000))) &&
              (lightModeTR != offColorInt)) {
            currentTouchCount++;
            _addTouchToLog("후면 오른쪽");
          }
        } else if (value[3] == 3) {
          //Back left
          if (myState == "inSet" &&
              (reactionSec == 0 || (DateTime.now().millisecondsSinceEpoch > latestTouchTime + (reactionSec * 1000))) &&
              (lightModeTL != offColorInt)) {
            currentTouchCount++;
            _addTouchToLog("후면 왼쪽");
          }
        } else if (value[3] == 4) {
          // right
          if (myState == "inSet" &&
              (reactionSec == 0 || (DateTime.now().millisecondsSinceEpoch > latestTouchTime + (reactionSec * 1000))) &&
              (lightModeBR != offColorInt || lightModeTR != offColorInt)) {
            currentTouchCount++;
            _addTouchToLog("압력센서 오른쪽");
          }
        } else if (value[3] == 5) {
          // left
          if (myState == "inSet" &&
              (reactionSec == 0 || (DateTime.now().millisecondsSinceEpoch > latestTouchTime + (reactionSec * 1000))) &&
              (lightModeBL != offColorInt || lightModeTL != offColorInt)) {
            currentTouchCount++;
            _addTouchToLog("압력센서 왼쪽");
          }
        }
        _checkTouchCompletion();
      } else {
        print("Recieved index 2 not valid");
      }
    } else {
      print("Recieved index 1 not valid");
    }
  }

  _addTouchToLog(touchedSensor) {
    // Touch count, total touch count,
    // Time since set started
    // the touched sensor location

    String tempMin = '';
    String tempSec = '';
    String tempMilliSec = '';

    int diff = cdtEndTime - DateTime.now().millisecondsSinceEpoch;
    if (diff >= 60000) {
      tempMin = (diff / 60000).floor().toString().padLeft(2, '0');
      diff -= (diff / 60000).floor() * 60000;
    } else {
      tempMin = '00';
    }
    if (diff >= 1000) {
      tempSec = (diff / 1000).floor().toString().padLeft(2, '0');
      diff -= (diff / 1000).floor() * 1000;
    } else {
      tempSec = '00';
    }
    if (diff >= 10) {
      tempMilliSec = (diff / 10).floor().toString().padLeft(2, '0').substring(0, 2);
    } else {
      tempMilliSec = '00';
    }

    latestTouchTime = DateTime.now().millisecondsSinceEpoch;

    myLog[myLogCounter.toString()] = tempMin +
        ':' +
        tempSec +
        ':' +
        tempMilliSec +
        ' ' +
        touchedSensor +
        '\n터치 ' +
        currentTouchCount.toString() +
        '/' +
        totalTouchCount.toString();
    myLogCounter++;
  }

  _checkTouchCompletion() {
    if (currentTouchCount >= totalTouchCount && myState == "inSet") {
      myState = "stopped";
      myStopwatch.stop();
      _showViewLogDialog(context);
    }
  }

  @override
  void dispose() {
    _myDispose();
    super.dispose();
  }

  _myDispose() async {
    aap.dispose();
    myStopwatch.stop();
    stopwatchPeriodical.cancel();
    setTimeController.dispose();
    restTimeController.dispose();
    setController.dispose();
    touchCountController.dispose();
    reactionTimeController.dispose();
    signalController.dispose();
    lightModeController.dispose();
    lightMotionController.dispose();

    await readSubscription?.cancel();
    // await gvars.tboxReadChar?.setNotifyValue(false);

    return;
  }

  sendMessage(msg) {
    if (gvars.tboxDevice != null) {
      writeCommands.add(msg);
      if (writing == false) {
        startSendMessages();
      }
    }
  }

  startSendMessages() async {
    writing = true;
    while (writeCommands.length != 0) {
      try {
        await gvars.tboxWriteChar.write(Uint8List.fromList(writeCommands[0]), true);
        // tboxWriteChar.write(writeCommands[0]);
      } catch (error) {
        FlutterToast.showToast(msg: "Error with BLE write");
        print("Ble write message failed: " + writeCommands[0].toString());
        writing = false;
      }
      // myLog.insert(
      //   0,
      //   DateFormat('HH:mm:ss').format(DateTime.now()).toString() + ' Sent: ' + writeCommands[0].toString(),
      // );
      writeCommands.removeAt(0);
    }
    writing = false;
  }

  String getSelectedSignalName(selIdx) {
    String toReturn;
    switch (selIdx) {
      case 0:
        toReturn = "Whistle";
        break;
      case 1:
        toReturn = "Ready Set Go";
        break;
      case 2:
        toReturn = "titalau";
        break;
      case 3:
        toReturn = "bigbang";
        break;
      case 4:
        toReturn = "bebemon";
        break;
      case 5:
        toReturn = "b1a4";
        break;
      default:
        toReturn = "Whistle";
        break;
    }
    return toReturn;
  }

  String _getSelectedLightMode(selIdx) {
    String toReturn;
    switch (selIdx) {
      case 0:
        toReturn = "None";
        break;
      case 1:
        toReturn = "Reactive";
        break;
      case 2:
        toReturn = "Circle 1";
        break;
      case 3:
        toReturn = "Circle 2";
        break;
      case 4:
        toReturn = "Breathing";
        break;
      case 5:
        toReturn = "Twinkle";
        break;
      default:
        toReturn = "Gradient";
        break;
    }
    return toReturn;
  }

  _closeOpenContainers(tapped) {
    if (tapped == 'setTime' && setTimeController.status == AnimationStatus.dismissed) {
      setTimeController.forward();
    } else if (tapped == 'setTime' || setTimeController.status == AnimationStatus.completed) {
      setTimeController.reverse();
    }
    if (tapped == 'restTime' && restTimeController.status == AnimationStatus.dismissed) {
      restTimeController.forward();
    } else if (tapped == 'restTime' || restTimeController.status == AnimationStatus.completed) {
      restTimeController.reverse();
    }
    if (tapped == 'set' && setController.status == AnimationStatus.dismissed) {
      setController.forward();
    } else if (tapped == 'set' || setController.status == AnimationStatus.completed) {
      setController.reverse();
    }
    if (tapped == 'touchCount' && touchCountController.status == AnimationStatus.dismissed) {
      touchCountController.forward();
    } else if (tapped == 'touchCount' || touchCountController.status == AnimationStatus.completed) {
      touchCountController.reverse();
    }
    if (tapped == 'reactionTime' && reactionTimeController.status == AnimationStatus.dismissed) {
      reactionTimeController.forward();
    } else if (tapped == 'reactionTime' || reactionTimeController.status == AnimationStatus.completed) {
      reactionTimeController.reverse();
    }
    if (tapped == 'signal' && signalController.status == AnimationStatus.dismissed) {
      signalController.forward();
    } else if (tapped == 'signal' || signalController.status == AnimationStatus.completed) {
      signalController.reverse();
    }
    if (tapped == 'lightMode' && lightModeController.status == AnimationStatus.dismissed) {
      lightModeController.forward();
    } else if (tapped == 'lightMode' || lightModeController.status == AnimationStatus.completed) {
      lightModeController.reverse();
    }
    if (tapped == 'lightMotion' && lightMotionController.status == AnimationStatus.dismissed) {
      lightMotionController.forward();
    } else if (tapped == 'lightMotion' || lightMotionController.status == AnimationStatus.completed) {
      lightMotionController.reverse();
    }
  }

  _playSignal() {
    if (selIdx == 0) {
      aap.open(Audio("assets/audios/whistle.mp3"));
    } else if (selIdx == 1) {
      aap.open(Audio("assets/audios/readysetgo.mp3"));
    } else if (selIdx == 2) {
      aap.open(Audio("assets/audios/titalau.mp3"));
    } else if (selIdx == 3) {
      aap.open(Audio("assets/audios/bigbang.mp3"));
    } else if (selIdx == 4) {
      aap.open(Audio("assets/audios/bebemon.mp3"));
    } else if (selIdx == 5) {
      aap.open(Audio("assets/audios/b1a4.mp3"));
    }
  }

  _adjustStartPressed() {
    // print('_adjustStartPressed');

    /* Check for errors
     * // 1) Rest Time set but not Set Count
     * 2) Set Time and Touch Count are both not set
     * 3) Touch Count and Light Motion are both set
     */

    // if(!(restTimeMin == 0 && restTimeSec == 0) && setCount == 1 ){
    //   FlutterToast.showToast( msg: "Both" );
    //   return;
    // }

    if (setTimeMin == 0 && setTimeSec == 0 && touchCount == 0) {
      FlutterToast.showToast(msg: "Either 운동시간 or 터치횠수 needs to be set.");
      return;
    }

    if (touchCount == 0 && lightMotionIdx != 0) {
      FlutterToast.showToast(msg: "터치횠수 and 조명모드 cannot both be set.");
      return;
    }

    /* Set the mode
     * 1) Only Set Time
     * 2) Only Touch Count
     * 3) Both Set Time and Touch Count
     */
    myLog.clear();
    if ((setTimeMin != 0 || setTimeSec != 0) && touchCount != 0) {
      timeMode = 'setTime and touchCount';
      if (cdtMin != 0 || cdtSec != 0 || cdtMsec != 0) {
        cdtEndTime = DateTime.now().millisecondsSinceEpoch + (cdtMin * 60 * 1000) + (cdtSec * 1000) + cdtMsec;
      } else {
        cdtEndTime = DateTime.now().millisecondsSinceEpoch + (setTimeMin * 60 * 1000) + (setTimeSec * 1000);
      }
    } else if (setTimeMin != 0 || setTimeSec != 0) {
      timeMode = 'setTime';
      if (cdtMin != 0 || cdtSec != 0 || cdtMsec != 0) {
        cdtEndTime = DateTime.now().millisecondsSinceEpoch + (cdtMin * 60 * 1000) + (cdtSec * 1000) + cdtMsec;
      } else {
        cdtEndTime = DateTime.now().millisecondsSinceEpoch + (setTimeMin * 60 * 1000) + (setTimeSec * 1000);
      }
    } else if (touchCount != 0) {
      timeMode = 'touchCount';
      myStopwatch.start();
    } else {
      timeMode = 'error';
      FlutterToast.showToast(msg: "unhandled setting combination");
      return;
    }

    totalSetCount = setCount;
    currentSetCount = 1;
    totalTouchCount = touchCount;
    currentTouchCount = 0;

    _addSetToLog();

    myState = "inSet";
  }

  _adjustPausePressed() {
    // print('_adjustPausePressed');
    myState = "stopped";
    if (timeMode == 'setTime and touchCount') {
      myStopwatch.stop();
      int diff = cdtEndTime - DateTime.now().millisecondsSinceEpoch;
      if (diff >= 60000) {
        cdtMin = (diff / 60000).floor();
        diff -= cdtMin * 60000;
      } else {
        cdtMin = 0;
      }
      if (diff >= 1000) {
        cdtSec = (diff / 1000).floor();
        diff -= cdtSec * 1000;
      } else {
        cdtSec = 0;
      }
      if (diff >= 10) {
        cdtMsec = (diff / 10).floor();
      } else {
        cdtMsec = 0;
      }
    } else if (timeMode == 'setTime') {
      int diff = cdtEndTime - DateTime.now().millisecondsSinceEpoch;
      if (diff >= 60000) {
        cdtMin = (diff / 60000).floor();
        diff -= cdtMin * 60000;
      } else {
        cdtMin = 0;
      }
      if (diff >= 1000) {
        cdtSec = (diff / 1000).floor();
        diff -= cdtSec * 1000;
      } else {
        cdtSec = 0;
      }
      if (diff >= 10) {
        cdtMsec = (diff / 10).floor();
      } else {
        cdtMsec = 0;
      }
    } else if (timeMode == 'touchCount') {
      myStopwatch.stop();
    } else {
      // countdown
      FlutterToast.showToast(msg: "unhandled pause");
    }
  }

  _adjustStopPressed() {
    // print('_adjustStopPressed');
    myState = "stopped";
    if (timeMode == 'setTime and touchCount') {
      myStopwatch.stop();
      myStopwatch.reset();
    } else if (timeMode == 'setTime') {
      minStr = "00";
      secStr = "00";
      msecStr = "00";
      cdtMin = 0;
      cdtSec = 0;
      cdtMsec = 0;
    } else if (timeMode == 'touchCount') {
      myStopwatch.stop();
      myStopwatch.reset();
    } else {
      // countdown
      FlutterToast.showToast(msg: "unhandled pause");
    }
  }

  _startAdjustLights() {
    print('startAdjustLights called');
    // if (lightModeTL == offColorInt) {
    //   stopOneLight('tl');
    // } else {
    //   startOneLightWithEffect('tl', lightModeSelColorInt);
    // }
    // if (lightModeTR == offColorInt) {
    //   stopOneLight('tr');
    // } else {
    //   startOneLightWithEffect('tr', lightModeSelColorInt);
    // }
    // if (lightModeBL == offColorInt) {
    //   stopOneLight('bl');
    // } else {
    //   startOneLightWithEffect('bl', lightModeSelColorInt);
    // }
    // if (lightModeBR == offColorInt) {
    //   stopOneLight('br');
    // } else {
    //   startOneLightWithEffect('br', lightModeSelColorInt);
    // }
  }

  _stopAdjustLights() {
    // stopOneLight('tl');
    // stopOneLight('tr');
    // stopOneLight('bl');
    // stopOneLight('br');
  }

  _handleAdjustTouch(touchLocation) {
    // if (selectedTab == 'Adjust') {
    //   if (adjustTabState == "inSet" &&
    //       (reactionSec == 0 || (DateTime.now().millisecondsSinceEpoch > latestTouchTime + (reactionSec * 1000))) &&
    //       (lightModeTL != offColorInt)) {
    //     currentTouchCount++;
    //     if (touchLocation == 'tl') {
    //       _addTouchToLog("후면 왼쪽");
    //     } else if (touchLocation == 'tr') {
    //     } else if (touchLocation == 'bl') {
    //     } else if (touchLocation == 'br') {
    //     } else if (touchLocation == 'r') {
    //     } else if (touchLocation == 'l') {}
    //   }
    // } else if (selectedTab == 'Select') {
    //   if (touchLocation == 'tl') {
    //     selectToggle('tl');
    //   } else if (touchLocation == 'tr') {
    //     selectToggle('tr');
    //   } else if (touchLocation == 'bl') {
    //     selectToggle('bl');
    //   } else if (touchLocation == 'br') {
    //     selectToggle('br');
    //   } else if (touchLocation == 'l') {
    //     selectToggle('bl');
    //     selectToggle('tl');
    //   } else if (touchLocation == 'r') {
    //     selectToggle('br');
    //     selectToggle('tl');
    //   }
    // }
  }

  _addSetToLog() {
    myLog['Set ' + currentSetCount.toString()] = '세트 ' + currentSetCount.toString() + '/' + totalSetCount.toString();
  }

  void _showViewLogDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bluetooth'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('All sets complete.'),
                Text('Would you like to view the data log?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('View'),
              onPressed: () {
                Navigator.pop(context);
                // Navigator.pushNamed(context, '/coach_log', arguments: {
                //   'myLog': 'asdf',// any widget or function
                //   'mas': 'ff'
                // });
                Navigator.pushNamed(context, '/coach_log', arguments: myLog);
              },
            ),
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Future<List<CoachSaved>> _getCoachSaved() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var coach_saved = json.decode(prefs.getString('coach_saved'));
  //   return CoachSaved.decodeCoachSaved(coach_saved);
  // }

  // _addCoachSaved() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var coach_saved = json.decode(prefs.getString('coach_saved'));
  //   List<CoachSaved> myCoachSavedList = CoachSaved.decodeCoachSaved(coach_saved);
  //   CoachSaved newCoachSaved = CoachSaved(
  //     toSaveName: toSaveName,
  //     setTimeMin: setTimeMin,
  //     setTimeSec: setTimeSec,
  //     restTimeMin: restTimeMin,
  //     restTimeSec: restTimeSec,
  //     restTimeSecSelIdx: restTimeSecSelIdx,
  //     setCount: setCount,
  //     touchCount: touchCount,
  //     touchCountSelIdx: touchCountSelIdx,
  //     reactionSec: reactionSec,
  //     reactionSecSelIdx: reactionSecSelIdx,
  //     latestTouchTime: latestTouchTime,
  //     selIdx: selIdx,
  //     lightModeTL: lightModeTL,
  //     lightModeTR: lightModeTR,
  //     lightModeBL: lightModeBL,
  //     lightModeBR: lightModeBR,
  //     lightModeSelColorInt: lightModeSelColorInt,
  //     lightMotionIdx: lightMotionIdx,
  //   );
  //   myCoachSavedList.add(newCoachSaved);
  //   String myEncodedCoachSaved = CoachSaved.encodeCoachSaved(myCoachSavedList);
  //   prefs.setString('coach_saved', myEncodedCoachSaved);
  // }
}
