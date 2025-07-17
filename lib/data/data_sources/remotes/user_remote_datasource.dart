import 'package:finance/core/models/user_model.dart';
import 'package:finance/core/services/api_service.dart';

class UserRemoteDatasource {
  final ApiService apiService;
  UserRemoteDatasource(this.apiService);

  Future<UserModel> login(
    String username,
    String password,
  ) async {
    final response = await apiService.post(
        '/login',
        {
          'username': username,
          'password': password,
        },
        useToken: false);
    if (response.isNotEmpty) {
      print('response: $response');
    } else {
      print('response null');
    }
    final userJson = response['data'];
    return UserModel.fromJson(userJson);
  }

  Future<UserModel> register(
      String name, String username, String email, String password) async {
    final response = await apiService.post(
        '/register',
        {
          'name': name,
          'username': username,
          'email': email,
          'password': password,
        },
        useToken: false);
    print(response);
    return UserModel.fromJson(response['data']);
  }

  Future<UserModel> fetchProfile() async {
    final response = await apiService.get('/profile/user');
    return UserModel.fromJson(response['data']);
  }

  Future<String> updateProfile(
      String name, String username, String email) async {
    try {
      final response = await apiService.put('/update/profile/user',
          {'name': name, 'username': username, 'email': email});
      if (response['code'] == 200 || response['code'] == 201) {
        return response['message'];
      } else {
        return response['error'];
      }
    } catch (e) {
      throw Exception('Error: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }

  Future<String> changePass(String old_pass, String new_pass) async {
    try {
      final response = await apiService.put('/change-password/user', {
        'old_pass': old_pass,
        'new_pass': new_pass,
      });
      if (response == 200 || response == 201) {
        return response['message'];
      } else {
        return response['message'];
      }
    } catch (e) {
      throw Exception('Error: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }
}
