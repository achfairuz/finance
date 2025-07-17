import 'package:finance/core/models/transaction_model.dart';
import 'package:finance/core/models/monthlyChart.dart';

import 'package:finance/core/services/api_service.dart';

class TransactionRemoteDatasources {
  final ApiService apiService;

  TransactionRemoteDatasources({required this.apiService});

  Future<TransactionModel> createExpenditure(
    int rekening_id,
    String date,
    String time,
    String title,
    String category,
    double amount,
    String information,
  ) async {
    try {
      final response = await apiService.post(
        '/transaction/expenditure',
        {
          'date': date.toString(),
          'time': time.toString(),
          'rekening_id': rekening_id,
          'title': title,
          'category': category,
          'amount': amount,
          'information': information,
        },
        useToken: true,
      );
      return TransactionModel.fromJson(response['data']);
    } catch (e) {
      print('❌ Error saat mengirim transaksi: $e');
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<TransactionModel> createIncome(
    int rekening_id,
    String date,
    String time,
    String title,
    String category,
    double amount,
    String information,
  ) async {
    try {
      final response = await apiService.post(
        '/transaction/income',
        {
          'date': date.toString(),
          'time': time.toString(),
          'rekening_id': rekening_id,
          'title': title,
          'category': category,
          'amount': amount,
          'information': information,
        },
        useToken: true,
      );

      return TransactionModel.fromJson(response['data']);
    } catch (e) {
      print('❌ Error saat mengirim transaksi: $e');
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<List<TransactionModel>> getAllTransaction() async {
    try {
      final response = await apiService.get('/get-all-transaction');

      if (response['code'] == 200) {
        final List<dynamic> jsonTransaction = response['data'];
        return jsonTransaction
            .map(
              (data) => TransactionModel.fromJson(data),
            )
            .toList();
      } else if (response['code'] == 404) {
        print('error 404 = ${response['message']}');
        return [];
      } else {
        final errorMessage = response['message'] ?? 'Error get all transation';
        print(
            'error response transaction ${response['code']} = ${response['message']}');
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<TransactionModel> getById(int id) async {
    try {
      final response = await apiService.get('/get-transaction/${id}');

      if (response['code'] == 200) {
        return TransactionModel.fromJson(response['data']);
      } else {
        throw Exception('error response');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
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
    String type,
  ) async {
    try {
      final response = await apiService.put('/update-transaction/$id', {
        'date': date.toString(),
        'time': time.toString(),
        'rekening_id': rekening_id,
        'title': title,
        'category': category,
        'amount': amount,
        'information': information,
        'type': type,
      });
      print(response);
      if (response['code'] == 200 || response['code'] == 201) {
        return response['message'];
      } else {
        throw Exception(
            'response update error: ${response['message'].toString().replaceAll('Exception: ', '')}');
      }
    } catch (e) {
      throw Exception(
          'response error: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }

  Future<String> deleteTransaction(int id) async {
    try {
      final response = await apiService.delete('/delete-transaction/$id');

      if (response['code'] == 200 || response['code'] == 201) {
        return response['message'];
      } else {
        throw Exception(
            'response delete error: ${response['message'].toString().replaceAll('Exception: ', '')}');
      }
    } catch (e) {
      throw Exception(
          'response error: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }

  Future<Map<String, List<MonthlyChart>>> fetchMonthlyChart(String type) async {
    final endpoint = (type == 'pengeluaran')
        ? '/get-chart-expenditure'
        : '/get-chart-income';
    try {
      final response = await apiService.get(endpoint);
      if (response['code'] == 200 || response['code'] == 201) {
        final Map<String, dynamic> data = response['data'];
        Map<String, List<MonthlyChart>> result = {};
        data.forEach((year, list) {
          result[year] = List<MonthlyChart>.from(
            (list as List).map((item) => MonthlyChart.fromJson(item)),
          );
        });
        return result;
      } else {
        return response['message'];
      }
    } catch (e) {
      throw Exception('Error: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }
}
