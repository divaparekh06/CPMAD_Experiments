class TransactionItem {
  final String id;
  final String title;
  final double amount;
  final String category;
  final String type; // 'Expense' or 'Income'
  final DateTime date;

  TransactionItem({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.type,
    required this.date,
  });
}
