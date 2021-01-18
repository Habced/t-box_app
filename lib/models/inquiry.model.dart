class Inquiry {
  final int id;
  final String title;
  final String inquiry;
  List<InquiryReply> replies;
  bool isExpanded;

  Inquiry({
    this.id,
    this.title,
    this.inquiry,
    this.isExpanded,
    this.replies,
  });
}

class InquiryReply {
  final String userFullname;
  final int replyId;
  final String reply;
  final String createDate;

  InquiryReply({this.userFullname, this.replyId, this.reply, this.createDate});
}
