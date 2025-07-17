import 'package:finance/core/models/monthlyChart.dart';
import 'package:finance/core/models/transaction_model.dart';
import 'package:finance/data/data_sources/remotes/transaction_remote_datasources.dart';

class TransactionRepositories {
  final TransactionRemoteDatasources transactionRemoteDatasources;

  TransactionRepositories({required this.transactionRemoteDatasources});

  Future<TransactionModel> createExpenditure(
    int rekening_id,
    String date,
    String time,
    String title,
    String category,
    double amount,
    String information,
  ) {
    return transactionRemoteDatasources.createExpenditure(
        rekening_id, date, time, title, category, amount, information);
  }

  Future<TransactionModel> createIncome(
    int rekening_id,
    String date,
    String time,
    String title,
    String category,
    double amount,
    String information,
  ) {
    return transactionRemoteDatasources.createIncome(
        rekening_id, date, time, title, category, amount, information);
  }

  Future<List<TransactionModel>> getAllTransaction() {
    return transactionRemoteDatasources.getAllTransaction();
  }

  Future<TransactionModel> getById(int id) {
    return transactionRemoteDatasources.getById(id);
  }

  Future<String> updateTransaction(
      int id,
      int rekening_id,
      String date,
      String time,
      String title,
      String category,
      double amount,
      String information,
      String type) {
    return transactionRemoteDatasources.updateTransaction(id, rekening_id, date,
        time, title, category, amount, information, type);
  }

  Future<String> deleteTransaction(int id) {
    return transactionRemoteDatasources.deleteTransaction(id);
  }

  Future<Map<String, List<MonthlyChart>>> fetchMonthlyChart(String type) {
    return transactionRemoteDatasources.fetchMonthlyChart(type);
  }
}
