import 'package:finance/UI/components/components.dart';
import 'package:finance/UI/components/navbar.dart';
import 'package:finance/core/models/rekening_model.dart';
import 'package:finance/core/services/api_service.dart';
import 'package:finance/data/data_sources/remotes/rekening_remotes_datasource.dart';
import 'package:finance/data/repositories/rekening_repositories.dart';
import 'package:flutter/material.dart';

class RekeningHelper {
  static final _repository = RekeningRepositories(
    rekeningRemotesDatasource: RekeningRemotesDatasource(
      apiService: ApiService(),
    ),
  );

  static Future<List<RekeningModel>> getALLRekening() {
    return _repository.getALLRekening();
  }

  static Future<double> fetchSumBalance() async {
    final sumBalance = await _repository.fetchTotalBalance();
    return sumBalance;
  }

  static Future<void> createRekening({
    required BuildContext context,
    required String name_bank,
    required double balance,
    required VoidCallback onStart,
    required VoidCallback onDone,
  }) async {
    onStart();
    try {
      final rekening = await _repository.createRekening(name_bank, balance);

      SnackBar(
        content: Text('Data berhasil di tambahkan'),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Navbar()),
      );
    } catch (e) {
      print('Error create rekening: $e');
      errorInput(
        context,
        e.toString(),
      );
    }
  }

  static Future<RekeningModel> fetchRekeningById(int id) async {
    final rekening = await _repository.getRekeningByID(id);

    return rekening;
  }

  static Future<void> updateRekening({
    required BuildContext context,
    required int id,
    required String name_bank,
    required double balance,
    required VoidCallback onStart,
    required VoidCallback onDone,
  }) async {
    onStart();
    try {
      final response = await _repository.updateRekening(id, name_bank, balance);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response)));
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Navbar(),
          ));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      onDone();
    }
  }
}
