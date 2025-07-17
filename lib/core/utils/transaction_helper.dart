import 'package:finance/UI/components/navbar.dart';
import 'package:finance/core/models/monthlyChart.dart';
import 'package:finance/core/models/transaction_model.dart';
import 'package:finance/core/services/api_service.dart';
import 'package:finance/data/data_sources/remotes/transaction_remote_datasources.dart';
import 'package:finance/data/repositories/transaction_repositories.dart';
import 'package:flutter/material.dart';

class TransactionHelper {
  static final _repository = TransactionRepositories(
      transactionRemoteDatasources:
          TransactionRemoteDatasources(apiService: ApiService()));

  static Future<void> createExpenditure({
    required BuildContext context,
    required int rekening_id,
    required String date,
    required String time,
    required String title,
    required String category,
    required double amount,
    required String information,
    required VoidCallback onStart,
    required VoidCallback onDone,
  }) async {
    onStart();
    try {
      final transaction = await _repository.createExpenditure(
          rekening_id, date, time, title, category, amount, information);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaksi berhasil ditambahkan')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Navbar()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      onDone();
    }
  }

  static Future<void> createIncome({
    required BuildContext context,
    required int rekening_id,
    required String date,
    required String time,
    required String title,
    required String category,
    required double amount,
    required String information,
    required VoidCallback onStart,
    required VoidCallback onDone,
  }) async {
    onStart();
    try {
      final transaction = await _repository.createIncome(
          rekening_id, date, time, title, category, amount, information);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaksi berhasil ditambahkan')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Navbar()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      onDone();
    }
  }

  static Future<List<TransactionModel>> fetchTransaction() {
    return _repository.getAllTransaction();
  }

  static Future<TransactionModel> getById(int id) {
    return _repository.getById(id);
  }

  static Future<void> updateTransaction({
    required BuildContext context,
    required int id,
    required int rekening_id,
    required String date,
    required String time,
    required String title,
    required String category,
    required double amount,
    required String information,
    required String type,
    required VoidCallback onStart,
    required VoidCallback onDone,
  }) async {
    onStart();
    try {
      final _updateTransaction = await _repository.updateTransaction(id,
          rekening_id, date, time, title, category, amount, information, type);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_updateTransaction)));

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Navbar(),
          ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      onDone();
    }
  }

  static Future<void> deleteTransaction(
      {required BuildContext context,
      required int id,
      required VoidCallback onStart,
      required VoidCallback onDone}) async {
    onStart();
    try {
      final _deleteTransaction = await _repository.deleteTransaction(id);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_deleteTransaction)));

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Navbar(),
          ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      onDone();
    }
  }

  static Future<Map<String, List<MonthlyChart>>> fetchMonthlyChart(
      String type) {
    return _repository.fetchMonthlyChart(type);
  }
}
