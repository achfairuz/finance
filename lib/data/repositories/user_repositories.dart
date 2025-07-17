import 'package:finance/core/models/user_model.dart';
import 'package:finance/data/data_sources/remotes/user_remote_datasource.dart';

class UserRepository {
  final UserRemoteDatasource remoteDatasource;

  UserRepository(this.remoteDatasource);

  Future<UserModel> login(String username, String password) {
    return remoteDatasource.login(username, password);
  }

  Future<UserModel> register(
      String name, String username, String email, String password) {
    return remoteDatasource.register(name, username, email, password);
  }

  Future<UserModel> getProfile() {
    return remoteDatasource.fetchProfile();
  }

  Future<String> updateProfile(String name, String username, String email) {
    return remoteDatasource.updateProfile(name, username, email);
  }

  Future<String> changePass(String old_pass, String new_pass) {
    return remoteDatasource.changePass(old_pass, new_pass);
  }
}
