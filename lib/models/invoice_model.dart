class Invoice {
  final int amount;
  final String bolt11;
  final String paymentHash;

  Invoice({
    required this.amount,
    required this.bolt11,
    required this.paymentHash,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      amount: json['amount'],
      bolt11: json['bolt11'],
      paymentHash: json['payment_hash'],
    );
  }
}