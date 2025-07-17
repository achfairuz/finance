import 'package:finance/UI/components/components.dart';
import 'package:finance/UI/components/inputTextWidget.dart';
import 'package:finance/UI/components/navbar.dart';
import 'package:finance/core/services/api_service.dart';
import 'package:finance/core/utils/auth_helper.dart';
import 'package:finance/data/data_sources/remotes/user_remote_datasource.dart';
import 'package:finance/data/repositories/user_repositories.dart';
import 'package:flutter/material.dart';
import 'package:finance/core/constants/constants.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _repository = UserRepository(UserRemoteDatasource(ApiService()));
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleText('Selamat Datang Kembali!'),
          subTitleText(
            'Masuk untuk melanjutkan pencatatan keuanganmu dan pantau progres finansialmu setiap hari.',
          ),
          const SizedBox(height: 40),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputText(
                  keyboardType: TextInputType.text,
                  controller: _username,
                  hintText: 'Masukkan username anda',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                InputText(
                  keyboardType: TextInputType.text,
                  controller: _password,
                  hintText: 'Masukkan password anda',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      // Aksi lupa password
                    },
                    child: Text(
                      'Lupa password?',
                      style: TextStyle(
                        color: AppColors.black.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    width: 140,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shadowColor: AppColors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                AuthHelper.handleLogin(
                                  context: context,
                                  username: _username.text,
                                  password: _password.text,
                                  onStart: () => setState(() {
                                    _isLoading = true;
                                  }),
                                  onDone: () => setState(() {
                                    _isLoading = false;
                                  }),
                                );
                              } else {
                                errorInput(context, 'Isi semua data');
                              }
                            },
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              'Sign in',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: AppSizes.fontBase,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
