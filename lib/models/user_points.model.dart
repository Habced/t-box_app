class UserPoints {
  final int id;
  final String amount;
  final String label;
  final String createDate;
  final String lastUpdate;

  UserPoints({
    this.id,
    this.amount,
    this.label,
    this.createDate,
    this.lastUpdate,
  });
}

class UserPointsList {
  List<UserPoints> userPoints;
  int totalPoints;

  UserPointsList({
    this.userPoints,
    this.totalPoints,
  });
}
