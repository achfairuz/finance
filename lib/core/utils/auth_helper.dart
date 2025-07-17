import 'package:finance/UI/auth/auth.dart';
import 'package:finance/UI/auth/loginWidget.dart';
import 'package:flutter/material.dart';
import 'package:finance/UI/components/navbar.dart';
import 'package:finance/data/data_sources/remotes/user_remote_datasource.dart';
import 'package:finance/data/repositories/user_repositories.dart';
import 'package:finance/core/services/api_service.dart';
import 'package:finance/core/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  static final _repository = UserRepository(UserRemoteDatasource(ApiService()));

  static Future<void> handleLogin({
    required BuildContext context,
    required String username,
    required String password,
    required VoidCallback onStart,
    required VoidCallback onDone,
  }) async {
    onStart();

    try {
      final user = await _repository.login(username, password);
      await AuthHelper.SaveUser(user);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Login berhasil! Selamat datang, ${user.username}')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Navbar()),
      );
    } catch (e) {
      print('Login error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login gagal: $e')),
      );
    } finally {
      onDone();
    }
  }

  static Future<void> handleRegister({
    required BuildContext context,
    required String name,
    required String username,
    required String email,
    required String password,
    required VoidCallback onStart,
    required VoidCallback onDone,
  }) async {
    onStart();
    try {
      final user = await _repository.register(name, username, email, password);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Register berhasil, silahkan login terlebih dahulu')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const Auth(initialTab: 1),
        ),
      );
    } catch (e) {
      print('Register error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Register gagal: $e')),
      );
    } finally {
      onDone();
    }
  }

  static Future<void> SaveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', user.id);
    await prefs.setString('name', user.name);
    await prefs.setString('username', user.username);
    await prefs.setString('email', user.email);
    if (user.token != null) {
      await prefs.setString('token', user.token!);
    }
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('id')) return null;
    return UserModel(
      id: prefs.getInt('id')!,
      name: prefs.getString('name') ?? 'User',
      username: prefs.getString('username') ?? '',
      email: prefs.getString('email') ?? '',
      token: prefs.getString('token'),
    );
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> updateProfile({
    required BuildContext context,
    required String name,
    required String username,
    required String email,
    required VoidCallback onStart,
    required VoidCallback onDone,
  }) async {
    onStart();
    try {
      final user = await _repository.updateProfile(name, username, email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(user)));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Navbar(),
        ),
      );
    } catch (e) {
      print('update error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update gagal: $e')),
      );
    } finally {
      onDone();
    }
  }

  static Future<UserModel> fetchProfile() {
    return _repository.getProfile();
  }

  static Future<void> changePass(
      {required BuildContext context,
      required String old_pass,
      required String new_pass,
      required VoidCallback onStart,
      required VoidCallback onDone}) async {
    onStart();
    try {
      final response = await _repository.changePass(old_pass, new_pass);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response)));

      Navigator.pop(context);
    } catch (e) {
      print('change pass error: $e');

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      onDone();
    }
  }
}
