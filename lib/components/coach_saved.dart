import 'dart:convert';

class CoachSaved {
  final String toSaveName;
  final int setTimeMin;
  final int setTimeSec;
  final int restTimeMin;
  final int restTimeSec;
  final int restTimeSecSelIdx;
  final int setCount;
  final int touchCount;
  final int touchCountSelIdx;
  final double reactionSec;
  final int reactionSecSelIdx;
  final int latestTouchTime;
  final int selIdx;
  final int lightModeTL;
  final int lightModeTR;
  final int lightModeBL;
  final int lightModeBR;
  final int lightModeSelColorInt;
  final int lightMotionIdx;
  
  CoachSaved({
    this.toSaveName,
    this.setTimeMin,
    this.setTimeSec,
    this.restTimeMin,
    this.restTimeSec,
    this.restTimeSecSelIdx,
    this.setCount,
    this.touchCount,
    this.touchCountSelIdx,
    this.reactionSec,
    this.reactionSecSelIdx,
    this.latestTouchTime,
    this.selIdx,
    this.lightModeTL,
    this.lightModeTR,
    this.lightModeBL,
    this.lightModeBR,
    this.lightModeSelColorInt,
    this.lightMotionIdx,
  });

  factory CoachSaved.fromJson(Map<String, dynamic> jsonData) {
    return CoachSaved(
      toSaveName: jsonData['toSaveName'],
      setTimeMin: jsonData['setTimeMin'],
      setTimeSec: jsonData['setTimeSec'],
      restTimeMin: jsonData['restTimeMin'],
      restTimeSec: jsonData['restTimeSec'],
      restTimeSecSelIdx: jsonData['restTimeSecSelIdx'],
      setCount: jsonData['setCount'],
      touchCount: jsonData['touchCount'],
      touchCountSelIdx: jsonData['touchCountSelIdx'],
      reactionSec: jsonData['reactionSec'],
      reactionSecSelIdx: jsonData['reactionSecSelIdx'],
      latestTouchTime: jsonData['latestTouchTime'],
      lightModeTL: jsonData['lightModeTL'],
      lightModeTR: jsonData['lightModeTR'],
      lightModeBL: jsonData['lightModeBL'],
      lightModeBR: jsonData['lightModeBR'],
      lightModeSelColorInt: jsonData['lightModeSelColorInt'],
      lightMotionIdx: jsonData['lightMotionIdx'],
    );
  }

  static Map<String, dynamic> toMap(CoachSaved coachSaved) => {
    'toSaveName': coachSaved.toSaveName,
    'setTimeMin': coachSaved.setTimeMin,
    'setTimeSec': coachSaved.setTimeSec,
    'restTimeMin': coachSaved.restTimeMin,
    'restTimeSec': coachSaved.restTimeSec,
    'restTimeSecSelIdx': coachSaved.restTimeSecSelIdx,
    'setCount': coachSaved.setCount,
    'touchCount': coachSaved.touchCount,
    'touchCountSelIdx': coachSaved.touchCountSelIdx,
    'reactionSec': coachSaved.reactionSec,
    'reactionSecSelIdx': coachSaved.reactionSecSelIdx,
    'latestTouchTime': coachSaved.latestTouchTime,
    'lightModeTL': coachSaved.lightModeTL,
    'lightModeTR': coachSaved.lightModeTR,
    'lightModeBL': coachSaved.lightModeBL,
    'lightModeBR': coachSaved.lightModeBR,
    'lightModeSelColorInt': coachSaved.lightModeSelColorInt,
    'lightMotionIdx': coachSaved.lightMotionIdx,
  };

  static String encodeCoachSaved(List<CoachSaved> coachSaved) => json.encode(
    coachSaved 
      .map<Map<String, dynamic>>((coachSaved) => CoachSaved.toMap(coachSaved))
      .toList(),
  );

  static List<CoachSaved> decodeCoachSaved(String coachSaved) =>
    (json.decode(coachSaved) as List<dynamic>)
      .map<CoachSaved>((item) => CoachSaved.fromJson(item))
      .toList();
}