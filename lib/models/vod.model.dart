class Vod {
  final int id;
  final String title;
  final String contents;
  final String vod;
  final String mrbg;
  final String thumbnail;
  final int pcType;
  final String pcTitle;
  final String scTitle;
  final int levelId;
  final List<dynamic> viewableTo;
  final bool usingPoints;
  final int earnablePoints;
  final int earnableTimes;
  final int sensingType;
  final int sensingStartMin;
  final int sensingStartSec;
  final int sensingEndMin;
  final int sensingEndSec;
  final int pointGoal;
  final int pointSuccess;
  bool isFavorite;

  Vod({
    this.id,
    this.title,
    this.contents,
    this.vod,
    this.mrbg,
    this.thumbnail,
    this.pcType,
    this.pcTitle,
    this.scTitle,
    this.levelId,
    this.viewableTo,
    this.usingPoints,
    this.earnablePoints,
    this.earnableTimes,
    this.sensingType,
    this.sensingStartMin,
    this.sensingStartSec,
    this.sensingEndMin,
    this.sensingEndSec,
    this.pointGoal,
    this.pointSuccess,
    this.isFavorite,
  });
}

class VodShort {
  final int id;
  final String title;
  final String contents;
  final String thumbnail;
  final String pcTitle;
  final String scTitle;
  final String timestamp;
  bool isFavorite;

  VodShort({
    this.id,
    this.title,
    this.contents,
    this.thumbnail,
    this.pcTitle,
    this.scTitle,
    this.timestamp,
  });
}

class VodMinimal {
  final int id;
  final String title;
  final String thumbnail;

  VodMinimal({
    this.id,
    this.title,
    this.thumbnail,
  });
}
