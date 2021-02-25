import 'package:tboxapp/models/vod.model.dart';

class PrimaryCate {
  final int id;
  final String title;
  // final String img;
  final bool isTboxCategory;
  final bool isTcyclingCategory;
  final bool isVisible;
  final int ordering;

  PrimaryCate({
    this.id,
    this.title,
    // this.img,
    this.isTboxCategory,
    this.isTcyclingCategory,
    this.isVisible,
    this.ordering,
  });
}

class PcShort {
  final int id;
  final String title;

  PcShort({
    this.id,
    this.title,
  });
}

class SecondaryCate {
  final int id;
  final int primaryCateId;
  final String title;
  final String img;
  final String color;
  final bool isVisible;
  final int ordering;

  SecondaryCate({
    this.id,
    this.primaryCateId,
    this.title,
    this.img,
    this.color,
    this.isVisible,
    this.ordering,
  });
}

class SecondaryCateVods {
  final SecondaryCate sc;
  List<Vod> vodList;

  SecondaryCateVods({
    this.sc,
  });
}

class PcScV {
  final PrimaryCate pc;
  List<SecondaryCateVods> sc;

  PcScV({
    this.pc,
  });
}

class PcLatestVods {
  final PcShort pc;
  List<VodMinimal> vodList;

  PcLatestVods({
    this.pc,
  });
}
