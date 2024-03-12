class Transaction {
  String type;
  int amount;
  DateTime date;

  Transaction(this.type, this.amount, this.date);

  Transaction.fromJson(Map<String, dynamic> json)
      : type = json['status'] as String,
        amount = json['amount'] as int,
        date = DateTime.parse(json['date']);
}
