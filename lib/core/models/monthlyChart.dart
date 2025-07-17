class MonthlyChart {
  final String month;
  final double amount;

  MonthlyChart({required this.month, required this.amount});

  factory MonthlyChart.fromJson(Map<String, dynamic> json) {
    return MonthlyChart(
      month: json['month'],
      amount: (json['amount'] as num).toDouble(),
    );
  }
  Map<String, dynamic> toJson() => {
        'month': month,
        'amount': amount,
      };
}
