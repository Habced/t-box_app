import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tboxapp/shared/global_vars.dart' as gvars;
import 'package:tboxapp/components/countdown_timer.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class CoachModeSelect extends StatefulWidget {
  @override
  CoachModeSelectState createState() => CoachModeSelectState();
}

class CoachModeSelectState extends State<CoachModeSelect> {
  double myWidth = 400.0;
  double myHeight = 400.0;
  double bodyWidth = 700;
  TextStyle s = TextStyle(color: Colors.white);
  TextStyle fontSize90 = TextStyle(fontSize: 90);
  TextStyle fontSize80 = TextStyle(fontSize: 80);

  String timeMode;
  bool isPlaying;

  Stopwatch myStopwatch;
  String minStr;
  String secStr;
  String msecStr;
  Timer stopwatchPeriodical;
  int cdtMin;
  int cdtSec;
  int cdtMsec;
  int cdtMinStart;
  int cdtSecStart;
  int cdtMsecStart;
  CountdownTimer myCdt;
  int cdtEndTime;

  int tlBtnColorInt;
  int trBtnColorInt;
  int blBtnColorInt;
  int brBtnColorInt;
  int selColorInt;
  final int offColorInt = 0xFFC4c4c4;

  var colorPickerRow;
  int signalSelIdx;

  var readSubscription;
  List<List<int>> writeCommands = [];
  bool writing = false;

  @override
  void initState() {
    super.initState();
    timeMode = 'stopwatch';
    isPlaying = false;
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
    // cdtEndTime = DateTime.now().millisecondsSinceEpoch + 1000 * 5 * 1;
    tlBtnColorInt = 0xFFC4c4c4;
    trBtnColorInt = 0xFFC4c4c4;
    blBtnColorInt = 0xFFC4c4c4;
    brBtnColorInt = 0xFFC4c4c4;
    selColorInt = 0xFFC4c4c4;

    signalSelIdx = 0;

    _setRead();
  }

  _setRead() async {
    if (gvars.isTboxConnected) {
      // await gvars.tboxReadChar.setNotifyValue(true);
      if (readSubscription == null) {
        readSubscription = gvars.tboxReadChar.monitor().listen((value) {
          _readTboxValue(value);
        });
      }
      sendMessage([gvars.packetHeader, 0x02, 0x02, 0x01, 0x01]);
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
    var topLeftBtn = _buildButton('tl', tlBtnColorInt);
    var topRightBtn = _buildButton('tr', trBtnColorInt);
    var bottomLeftBtn = _buildButton('bl', blBtnColorInt);
    var bottomRightBtn = _buildButton('br', brBtnColorInt);

    colorPickerRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildColorBtn(0xFFC32A2A, 0xFFFF0000), // Red
        _buildColorBtn(0xFFCD712E, 0xFFCD712E), // Orange
        _buildColorBtn(0xFFD5CE2C, 0xFFFFFF00), // Yellow
        _buildColorBtn(0xFF30CC36, 0xFF00FF00), // Green
        _buildColorBtn(0xFF3887D0, 0xFF3887D0), // Light Blue
        _buildColorBtn(0xFF191774, 0xFF0000FF), // Blue
        _buildColorBtn(0xFF6B1980, 0xFF6B1980), // Purple
        _buildColorBtn(0xFFFFFFFF, 0xFFFFFFFF), // White
      ],
    );

    var selectContainer = Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1, color: gvars.MyPrimaryYellowColor),
        color: Color(0x33E5E5E5),
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
                  topLeftBtn,
                  Text('후면', style: TextStyle(color: gvars.MyPrimaryYellowColor, fontSize: 18)),
                  topRightBtn,
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Image.asset('assets/images/tbox.png')],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  bottomLeftBtn,
                  Text('전면', style: TextStyle(color: gvars.MyPrimaryYellowColor, fontSize: 18)),
                  bottomRightBtn,
                ],
              ),
              colorPickerRow
            ],
          ),
        ),
      ),
    );

    var selectSignalContainer = Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1, color: gvars.MyPrimaryYellowColor),
        color: Color(0x33E5E5E5),
      ),
      child: Column(children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 40,
                child: Text("시그널"),
              ),
              Text(_getSelectedSignalName(signalSelIdx)),
            ],
          ),
        ),
        Divider(
          color: gvars.MyPrimaryYellowColor,
          thickness: 1,
        ),
        Container(
          height: 200,
          width: myWidth,
          // decoration: BoxDecoration(
          //   color: Color(tileBgColor),
          //   border: Border.all(width: 1, color: gvars.MyPrimaryYellowColor ),
          // ),
          // child: adjustSignalWidget
          // child: coachSignalWidget
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(initialItem: signalSelIdx),
            itemExtent: 26,
            // looping: true,
            useMagnifier: true,
            magnification: 1.2,
            onSelectedItemChanged: (value) {
              signalSelIdx = value;
            },
            children: [
              Text('Whistle', style: s),
              Text('Ready Set Go', style: s),
              Text('titalau', style: s),
              Text('bigbang', style: s),
              Text('bebemon', style: s),
              Text('b1a4', style: s),
            ],
          ),
        ),
      ]),
    );

    var modeBtn = Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          if (isPlaying) {
            return;
          }
          if (timeMode == 'stopwatch') {
            timeMode = 'countdown';
          } else {
            timeMode = 'stopwatch';
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [timeMode == "stopwatch" ? Text("스톱워치") : Text("타이머"), Icon(Icons.timer)],
        ),
      ),
    );

    var notPlayingMinEditor = Expanded(
      flex: 1,
      child: Column(children: [
        IconButton(
            icon: Icon(Icons.keyboard_arrow_up),
            onPressed: () {
              if (cdtMin < 59) {
                cdtMin++;
                cdtMinStart = cdtMin;
              }
            }),
        Text(cdtMin.toString().padLeft(2, '0').substring(0, 2), style: fontSize90),
        IconButton(
            icon: Icon(Icons.keyboard_arrow_down),
            onPressed: () {
              if (cdtMin > 0) {
                cdtMin--;
                cdtMinStart = cdtMin;
              }
            }),
      ]),
    );

    var notPlayingSecEditor = Expanded(
      flex: 1,
      child: Column(children: [
        IconButton(
            icon: Icon(Icons.keyboard_arrow_up),
            onPressed: () {
              if (cdtSec < 59) {
                cdtSec++;
                cdtSecStart = cdtSec;
              }
            }),
        Text(cdtSec.toString().padLeft(2, '0').substring(0, 2), style: fontSize90),
        IconButton(
            icon: Icon(Icons.keyboard_arrow_down),
            onPressed: () {
              if (cdtSec > 0) {
                cdtSec--;
                cdtSecStart = cdtSec;
              }
            }),
      ]),
    );

    var notPlayingMsec = Expanded(
      flex: 1,
      child: Column(children: [
        Text(cdtMsec.toString().padLeft(2, '0').substring(0, 2), style: fontSize90),
      ]),
    );

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        constraints: BoxConstraints(maxWidth: bodyWidth),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              modeBtn,
              isPlaying && timeMode == 'countdown'
                  ? CountdownTimer(
                      endTime: cdtEndTime ?? 0,
                      onEnd: () {
                        isPlaying = false;
                      },
                    )
                  : Container(),
              !isPlaying && timeMode == 'countdown'
                  ? Row(
                      children: [
                        notPlayingMinEditor,
                        _buildPaddedSymbol('m'),
                        notPlayingSecEditor,
                        _buildPaddedSymbol('s'),
                        notPlayingMsec,
                        _buildPaddedSymbol('ms'),
                      ],
                    )
                  : Container(),
              timeMode == 'stopwatch'
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("${minStr.toString().padLeft(2, '0')}", style: fontSize80),
                        Text("m ", style: TextStyle(fontSize: 30.0)),
                        Text("${secStr.toString().padLeft(2, '0')}", style: fontSize80),
                        Text("s ", style: TextStyle(fontSize: 30.0)),
                        Text("${msecStr.toString().padLeft(2, '0').substring(0, 2)}", style: fontSize80),
                        Text("ms", style: TextStyle(fontSize: 30.0)),
                      ],
                    )
                  : Container(),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: isPlaying
                        ? _buildYellowButton("PAUSE", Icons.pause, () => pause())
                        : _buildYellowButton("START", Icons.play_arrow, () => start()),
                  ),
                  SizedBox(width: 10),
                  Expanded(flex: 4, child: _buildYellowButton("STOP", Icons.stop, () => stop())),
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
              Align(
                alignment: Alignment.centerLeft,
                child: Text("설정", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Divider(color: Colors.white, thickness: 2),
              selectContainer,
              SizedBox(height: 20),
              selectSignalContainer
            ]),
          ),
        ),
      ),
    );
  }

  _buildButton(pos, cInt) {
    return GestureDetector(
      onTap: () {
        _selectToggle(pos);
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Color(cInt),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            cInt != offColorInt
                ? BoxShadow(
                    color: Color(cInt),
                    spreadRadius: 2,
                    blurRadius: 4,
                  )
                : BoxShadow(),
          ],
        ),
      ),
    );
  }

  _buildColorBtn(displayColorInt, actualColorInt) {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        color: Color(displayColorInt),
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          actualColorInt == selColorInt
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
          selColorInt = actualColorInt;
        },
        child: Container(),
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

  Padding _buildPaddedSymbol(symbol) {
    return Padding(
      padding: EdgeInsets.only(top: 45),
      child: Text(symbol + " ", style: TextStyle(fontSize: 30.0)),
    );
  }

  @override
  void dispose() {
    _myDispose();
    super.dispose();
  }

  _myDispose() async {
    myStopwatch.stop();
    stopwatchPeriodical.cancel();
    await readSubscription?.cancel();
    // await gvars.tboxReadChar?.setNotifyValue(false);
    return;
  }

  _selectToggle(pos) {
    print('selectToggle on pos: ' + pos.toString());
    var r = Color(selColorInt).red;
    var g = Color(selColorInt).green;
    var b = Color(selColorInt).blue;
    if (pos == 'tl') {
      if (tlBtnColorInt == offColorInt) {
        sendMessage([gvars.packetHeader, 0x06, 0x10, 0x01, 0x00, r, g, b, 0x58]);
        setState(() {
          tlBtnColorInt = selColorInt;
        });
      } else {
        sendMessage([gvars.packetHeader, 0x06, 0x10, 0x01, 0x00, 0x00, 0x00, 0x00, 0x58]);
        setState(() {
          tlBtnColorInt = offColorInt;
        });
      }
    } else if (pos == 'tr') {
      if (trBtnColorInt == offColorInt) {
        sendMessage([gvars.packetHeader, 0x06, 0x10, 0x00, 0x00, r, g, b, 0x58]);
        setState(() {
          trBtnColorInt = selColorInt;
        });
      } else {
        sendMessage([gvars.packetHeader, 0x06, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x58]);
        setState(() {
          trBtnColorInt = offColorInt;
        });
      }
    } else if (pos == 'bl') {
      if (blBtnColorInt == offColorInt) {
        sendMessage([gvars.packetHeader, 0x06, 0x10, 0x03, 0x00, r, g, b, 0x58]);
        setState(() {
          blBtnColorInt = selColorInt;
        });
      } else {
        sendMessage([gvars.packetHeader, 0x06, 0x10, 0x03, 0x00, 0x00, 0x00, 0x00, 0x58]);
        setState(() {
          blBtnColorInt = offColorInt;
        });
      }
    } else if (pos == 'br') {
      if (brBtnColorInt == offColorInt) {
        sendMessage([gvars.packetHeader, 0x06, 0x10, 0x02, 0x00, r, g, b, 0x58]);
        setState(() {
          brBtnColorInt = selColorInt;
        });
      } else {
        sendMessage([gvars.packetHeader, 0x06, 0x10, 0x02, 0x00, 0x00, 0x00, 0x00, 0x58]);
        setState(() {
          brBtnColorInt = offColorInt;
        });
      }
    }
  }

  String _getSelectedSignalName(selIdx) {
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

  start() {
    isPlaying = true;
    if (timeMode == 'stopwatch') {
      myStopwatch.start();
    } else {
      // countdown
      cdtEndTime = DateTime.now().millisecondsSinceEpoch + (cdtMin * 60 * 1000) + (cdtSec * 1000) + cdtMsec;
    }
  }

  pause() {
    isPlaying = false;
    if (timeMode == 'stopwatch') {
      myStopwatch.stop();
    } else {
      // countdown
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
    }
  }

  stop() {
    isPlaying = false;
    if (timeMode == 'stopwatch') {
      myStopwatch.stop();
      myStopwatch.reset();
    } else {
      // countdown
      // count
      cdtMin = cdtMinStart;
      cdtSec = cdtSecStart;
      cdtMsec = cdtMsecStart;
    }
  }

  _playSignal() {
    if (signalSelIdx == 0) {
      AssetsAudioPlayer.playAndForget(Audio("assets/audios/whistle.mp3"));
    } else if (signalSelIdx == 1) {
      AssetsAudioPlayer.playAndForget(Audio("assets/audios/readysetgo.mp3"));
    } else if (signalSelIdx == 2) {
      AssetsAudioPlayer.playAndForget(Audio("assets/audios/titalau.mp3"));
    } else if (signalSelIdx == 3) {
      AssetsAudioPlayer.playAndForget(Audio("assets/audios/bigbang.mp3"));
    } else if (signalSelIdx == 4) {
      AssetsAudioPlayer.playAndForget(Audio("assets/audios/bebemon.mp3"));
    } else if (signalSelIdx == 5) {
      AssetsAudioPlayer.playAndForget(Audio("assets/audios/b1a4.mp3"));
    }
  }

  _readTboxValue(value) {
    print(value.toString());
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
        await gvars.tboxWriteChar.write(writeCommands[0], false);
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
}
