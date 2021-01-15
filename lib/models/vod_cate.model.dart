class PrimaryCate {
  final int id;
  final String title;
  final String img;
  final bool isTboxCategory;
  final bool isTcyclingCategory;
  final bool isVisible;
  final int ordering;

  PrimaryCate({
    this.id,
    this.title,
    this.img,
    this.isTboxCategory,
    this.isTcyclingCategory,
    this.isVisible,
    this.ordering
  });
}

class SecondaryCate {
  final int id;
  final int primaryCateId;
  final String title;
  final String img;
  final bool isVisible;
  final int ordering;

  SecondaryCate({
    this.id,
    this.primaryCateId,
    this.title,
    this.img,
    this.isVisible,
    this.ordering,
  });
}