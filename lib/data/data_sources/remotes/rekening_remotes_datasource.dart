import 'package:finance/core/models/rekening_model.dart';
import 'package:finance/core/services/api_service.dart';

class RekeningRemotesDatasource {
  final ApiService apiService;

  RekeningRemotesDatasource({required this.apiService});

  Future<List<RekeningModel>> getAllRekening() async {
    final response = await apiService.get('/get-rekening/rekening');

    if (response['code'] == 200) {
      final List<dynamic> rekeningJson = response['data'];
      return rekeningJson.map((json) => RekeningModel.fromJson(json)).toList();
    } else if (response['code'] == 404) {
      return [];
    } else {
      final errorMessage = response['message'] ?? 'Gagal memuat data rekening';
      throw Exception(errorMessage);
    }
  }

  double getSumBalance(List<RekeningModel> rekeningList) {
    return rekeningList.fold(
      0.0,
      (sum, item) => sum + (item.balance ?? 0.0),
    );
  }

  Future<RekeningModel> createRekening(String name_bank, double balance) async {
    final response = await apiService.post('/add-bank/rekening', {
      'name_bank': name_bank,
      'balance': balance,
    });

    return RekeningModel.fromJson(response['data']);
  }

  Future<RekeningModel> getRekeningByID(int id) async {
    try {
      final response = await apiService.get('/get-rekening/$id');
      if (response['code'] == 200 || response['code'] == 201) {
        return RekeningModel.fromJson(response['data']);
      } else {
        print('error: ${response['message']}');
        return response['message'];
      }
    } catch (e) {
      throw Exception('Error: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }

  Future<String> updateRekening(
      int id, String name_bank, double balance) async {
    try {
      final response = await apiService.put('/update-balance/rekening/$id', {
        'name_bank': name_bank,
        'balance': balance,
      });
      if (response['code'] == 200 || response['code'] == 201) {
        return response['message'];
      } else {
        print(response['error']);
        return response['message'];
      }
    } catch (e) {
      throw Exception('Error: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }
}
