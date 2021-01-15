class Inquiry {
  final int id;
  final String userFullname;
  final String title;
  final String inquiry;
  List<InquiryReply> replies;
  bool isExpanded;

  Inquiry({
    this.id,
    this.userFullname,
    this.title,
    this.inquiry,
    this.isExpanded,
  });
}

class InquiryReply {
  final int id;
  final String userFullname;
  final int replyId;
  final String reply;
  final String createDate;

  InquiryReply(
      {this.id, this.userFullname, this.replyId, this.reply, this.createDate});
}
