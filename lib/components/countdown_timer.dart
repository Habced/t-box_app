library flutter_package;

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';


// Inspired from v1.3.0 https://pub.dev/packages/flutter_countdown_timer
// but removed days and hours
// and added milliseconds

typedef CountdownTimerWidgetBuilder = Widget Function( BuildContext context, CurrentRemainingTime time);

/// A Countdown.
class CountdownTimer extends StatefulWidget {
  final int endTime;
  final Widget minSymbol;
  final Widget secSymbol;
  final Widget milliSecSymbol;
  final TextStyle textStyle;
  final VoidCallback onEnd;
  final Widget emptyWidget;
  final CountdownTimerWidgetBuilder widgetBuilder;

  CountdownTimer({
    Key key,
    this.endTime,
    this.minSymbol = const Text("m ", style: TextStyle( fontSize: 30.0, )),
    this.secSymbol = const Text("s ", style: TextStyle( fontSize: 30.0, )),
    this.milliSecSymbol = const Text("ms", style: TextStyle( fontSize: 30.0, )),
    this.textStyle = const TextStyle(fontSize: 90),
    this.onEnd,
    this.emptyWidget = const Center( child: Text("00:00:00", style: TextStyle(fontSize: 90) )),
    this.widgetBuilder,
  }) : super(key: key);
  @override
  _CountDownState createState() => _CountDownState();
}

class _CountDownState extends State<CountdownTimer> {
  CurrentRemainingTime currentRemainingTime = CurrentRemainingTime();
  Timer _diffTimer;
  VoidCallback get onEnd => widget.onEnd;
  TextStyle get textStyle => widget.textStyle;
  Widget get emptyWidget => widget.emptyWidget;
  Widget get minSymbol => widget.minSymbol;
  Widget get secSymbol => widget.secSymbol;
  Widget get milliSecSymbol => widget.milliSecSymbol;


  CountdownTimerWidgetBuilder get widgetBuilder => widget.widgetBuilder ?? builderCountdownTimer;
  

  @override
  void initState() {
    timerDiffDate();
    super.initState();
  }

  @override
  void didUpdateWidget(CountdownTimer oldWidget) {
    if (oldWidget.endTime != widget.endTime) {
      timerDiffDate();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return widgetBuilder(context, currentRemainingTime);
  }

  Widget builderCountdownTimer(
      BuildContext context, CurrentRemainingTime time) {
    return DefaultTextStyle(
      style: textStyle,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: timeListBuild(time),
      ),
    );
  }

  timeListBuild(CurrentRemainingTime time) {
    List<Widget> list = [];
    if (time == null) {
      list.add(emptyWidget);
      return list;
    }
    var min = _getNumberAddZero(time.min ?? 0);
    list.add(Text(min));
    list.add(minSymbol);
    var sec = _getNumberAddZero(time.sec??0);
    list.add(Text(sec));
    list.add(secSymbol);
    var milliSec = _getNumberAddZero(time.milliSec??0);
    list.add(Text(milliSec));
    list.add(milliSecSymbol);
    return list;
  }

  String _getNumberAddZero(int number) {
    if (number == null) {
      return null;
    }
    if (number < 10) {
      return "0" + number.toString();
    }
    return number.toString();
  }

  void checkDateEnd(CurrentRemainingTime data) {
    if (data == null) {
      onEnd?.call();
      disposeDiffTimer();
    }
  }

  CurrentRemainingTime getDateData() {
    if (widget.endTime == null) return null;
    // int diff = ((widget.endTime - DateTime.now().millisecondsSinceEpoch) / 1000).floor();
    int diff = widget.endTime - DateTime.now().millisecondsSinceEpoch;
    if (diff < 0) {
      return null;
    }
    int min,
        sec,
        milliSec = 0;
    if (diff >= 60000) {
      min = (diff / 60000).floor();
      diff -= min * 60000;
    } else {
      min = 0;
    }
    if (diff >= 1000) {
      sec = (diff / 1000).floor();
      diff -= sec * 1000;
    } else {
      sec = 0;
    }
    if (diff >= 10) {
      milliSec = (diff / 10).floor();
    } else {
      milliSec = 0;
    }
    return CurrentRemainingTime(min: min, sec: sec, milliSec: milliSec);
  }

  timerDiffDate() {
    CurrentRemainingTime data = getDateData();
    if (data != null) {
      setState(() { currentRemainingTime = data; });
    } 
    disposeDiffTimer();
    const period = const Duration(milliseconds: 1);
    _diffTimer = Timer.periodic(period, (timer) {
      CurrentRemainingTime data = getDateData();
      setState(() {
        currentRemainingTime = data;
      });
      checkDateEnd(data);
      if (data == null) {
        disposeDiffTimer();
      }
    });
  }
  
  @override
  void dispose() {
    disposeDiffTimer();
    super.dispose();
  }

  disposeDiffTimer() {
    _diffTimer?.cancel();
    _diffTimer = null;
  }

}

class CurrentRemainingTime {
  final int min;
  final int sec;
  final int milliSec;

  CurrentRemainingTime({this.min, this.sec, this.milliSec});
  
  @override
  String toString() {
    return 'CurrentRemainingTime{min: $min, sec: $sec, milliSec: $milliSec}';
  }

}