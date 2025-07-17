import 'package:finance/UI/components/components.dart';
import 'package:finance/UI/components/inputTextWidget.dart';
import 'package:finance/UI/components/navbar.dart';
import 'package:finance/core/utils/auth_helper.dart';
import 'package:flutter/material.dart';
import 'package:finance/core/constants/constants.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleText('Buat Akun Baru'),
          subTitleText(
              'Mulai atur keuanganmu sekarang dan capai tujuan finansial dengan lebih mudah.'),
          const SizedBox(height: 40),
          Form(
            key: _formKey,
            child: Column(
              children: [
                InputText(
                  controller: _namaController,
                  keyboardType: TextInputType.text,
                  hintText: 'Masukkan nama lengkap',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                InputText(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'Masukkan Email anda',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                InputText(
                  controller: _usernameController,
                  keyboardType: TextInputType.text,
                  hintText: 'Masukkan username anda',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                InputText(
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
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
                const SizedBox(height: 12),
                InputText(
                  controller: _confirmpasswordController,
                  keyboardType: TextInputType.text,
                  hintText: 'Masukkan konfirmasi password anda',
                  validator: (value) {
                    if (value == null || value != _passwordController.text) {
                      return 'Password tidak cocok';
                    }
                    return null;
                  },
                ),
              ],
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
                          AuthHelper.handleRegister(
                            context: context,
                            name: _namaController.text,
                            username: _usernameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                            onStart: () => setState(() => _isLoading = true),
                            onDone: () => setState(() => _isLoading = false),
                          );
                        }
                      },
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(
                        'Sign Up',
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
    );
  }
}
