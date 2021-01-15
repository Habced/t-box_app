import 'dart:convert';

// void main() {
//   final String encodedData = Music.encodeMusics([
//     Music(id: 1),
//     Music(id: 2),
//     Music(id: 3),
//   ]);

//   final List<Music> decodedData = Music.decodeMusics(encodedData);

//   print(decodedData);
// }

class CoachAdjust {
  final String name;
  final int setTimeMin, setTimeSec, restTimeMin, restTimeSec, setCount, touchCount, reactionMs, signalSelIdx, lightModeTL, lightModeTR, lightModeBL, lightModeBR, lightMotionIdx;

  CoachAdjust({
    this.name,
    this.setTimeMin, 
    this.setTimeSec, 
    this.restTimeMin, 
    this.restTimeSec, 
    this.setCount, 
    this.touchCount, 
    this.reactionMs, 
    this.signalSelIdx, 
    this.lightModeTL, 
    this.lightModeTR, 
    this.lightModeBL, 
    this.lightModeBR, 
    this.lightMotionIdx
  });

  factory CoachAdjust.fromJson(Map<String, dynamic> jsonData) {
    return CoachAdjust(
      name: jsonData['name'], 
      setTimeMin: jsonData['setTimeMin'], 
      setTimeSec: jsonData['setTimeSec'], 
      restTimeMin: jsonData['restTimeMin'], 
      restTimeSec: jsonData['restTimeSec'], 
      setCount: jsonData['setCount'], 
      touchCount: jsonData['touchCount'], 
      reactionMs: jsonData['reactionMs'], 
      signalSelIdx: jsonData['signalSelIdx'], 
      lightModeTL: jsonData['lightModeTL'], 
      lightModeTR: jsonData['lightModeTR'], 
      lightModeBL: jsonData['lightModeBL'], 
      lightModeBR: jsonData['lightModeBR'], 
      lightMotionIdx: jsonData['lightMotionIdx'], 
    );
  }

  static Map<String, dynamic> toMap(CoachAdjust coachAdjust) => {
    'name': coachAdjust.name, 
    'setTimeMin': coachAdjust.setTimeMin, 
    'setTimeSec': coachAdjust.setTimeSec, 
    'restTimeMin': coachAdjust.restTimeMin, 
    'restTimeSec': coachAdjust.restTimeSec, 
    'setCount': coachAdjust.setCount, 
    'touchCount': coachAdjust.touchCount, 
    'reactionMs': coachAdjust.reactionMs, 
    'signalSelIdx': coachAdjust.signalSelIdx, 
    'lightModeTL': coachAdjust.lightModeTL, 
    'lightModeTR': coachAdjust.lightModeTR, 
    'lightModeBL': coachAdjust.lightModeBL, 
    'lightModeBR': coachAdjust.lightModeBR, 
    'lightMotionIdx': coachAdjust.lightMotionIdx, 
  };

  static String encodeCoachAdjusts(List<CoachAdjust> coachAdjusts) => json.encode(
    coachAdjusts
      .map<Map<String, dynamic>>((coachAdjusts) => CoachAdjust.toMap(coachAdjusts))
      .toList(),
  );

  static List<CoachAdjust> decodeCoachAdjusts(String coachAdjusts) =>
    (json.decode(coachAdjusts) as List<dynamic>)
      .map<CoachAdjust>((item) => CoachAdjust.fromJson(item))
      .toList();
}