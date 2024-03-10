class Transaction {
  String type;
  int amount;

  Transaction(this.type, this.amount);

  Transaction.fromJson(Map<String, dynamic> json)
      : type = json['status'] as String,
        amount = json['amount'] as int;
}
