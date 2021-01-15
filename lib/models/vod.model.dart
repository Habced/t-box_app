class Vod {
  final int id;
  final String title;
  final String contents;
  final String vod;
  final String mrbg;
  final String thumbnail;
  final int primaryCate;
  final int secondaryCate;
  final String gangsaName;
  final List<int> viewableTo;
  bool isFavorite;

  Vod({
    this.id,
    this.title,
    this.contents,
    this.vod,
    this.mrbg,
    this.thumbnail,
    this.primaryCate,
    this.secondaryCate,
    this.gangsaName,
    this.viewableTo
  });

}