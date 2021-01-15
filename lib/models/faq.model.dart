class Faq {
  final int id;
  final String question;
  final String answer;
  final int clickCount;
  final String createDate;
  final String lastUpdate;

  Faq({
    this.id,
    this.question,
    this.answer,
    this.clickCount,
    this.createDate,
    this.lastUpdate,
  });
}

class FaqList {
  List<Faq> faq;

  FaqList({
    this.faq,
  });
}
