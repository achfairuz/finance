import 'package:finance/core/models/rekening_model.dart';
import 'package:finance/data/data_sources/remotes/rekening_remotes_datasource.dart';

class RekeningRepositories {
  final RekeningRemotesDatasource rekeningRemotesDatasource;

  RekeningRepositories({required this.rekeningRemotesDatasource});

  Future<List<RekeningModel>> getALLRekening() {
    return rekeningRemotesDatasource.getAllRekening();
  }

  Future<double> fetchTotalBalance() async {
    final rekeningList = await rekeningRemotesDatasource.getAllRekening();
    return rekeningRemotesDatasource.getSumBalance(rekeningList);
  }

  Future<RekeningModel> createRekening(String name_bank, double balance) {
    return rekeningRemotesDatasource.createRekening(name_bank, balance);
  }

  Future<RekeningModel> getRekeningByID(int id) {
    return rekeningRemotesDatasource.getRekeningByID(id);
  }

  Future<String> updateRekening(int id, String name_bank, double balance) {
    return rekeningRemotesDatasource.updateRekening(id, name_bank, balance);
  }
}
