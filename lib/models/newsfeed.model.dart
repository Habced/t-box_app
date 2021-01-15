class Newsfeed {
  final int id;
  final String title;
  final String body;
  final int clickCount;
  final bool pin;
  bool hasRead;
  final String createDate;
  final String lastUpdate;

  Newsfeed({
    this.id,
    this.title,
    this.body,
    this.clickCount,
    this.pin,
    this.hasRead,
    this.createDate,
    this.lastUpdate,
  });
}

class NewsfeedList {
  List<Newsfeed> newsfeed;
  int totalUnread;

  NewsfeedList({
    this.newsfeed,
    this.totalUnread,
  });
}
