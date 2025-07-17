import 'package:finance/UI/components/components.dart';
import 'package:finance/UI/components/inputTextwithLabel.dart';
import 'package:finance/core/utils/auth_helper.dart';
import 'package:flutter/material.dart';
import 'package:finance/core/constants/constants.dart';

class FormChangepass extends StatefulWidget {
  const FormChangepass({super.key});

  @override
  State<FormChangepass> createState() => _FormChangepassState();
}

class _FormChangepassState extends State<FormChangepass> {
  TextEditingController _oldPassController = TextEditingController();
  TextEditingController _newPassController = TextEditingController();
  TextEditingController _newVerifyPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      AuthHelper.changePass(
        context: context,
        old_pass: _oldPassController.text,
        new_pass: _newPassController.text,
        onStart: () {
          setState(() {
            _isLoading = true;
          });
        },
        onDone: () {
          setState(() {
            _isLoading = false;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(24, 20, 24, 0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.arrow_back,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          'Change Password',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: AppSizes.fontMedium,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Make sure your new password is secure and easy to remember. Dont share it with anyone.',
                      style: TextStyle(
                        color: AppColors.black.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Inputtextwithlabel(
                          label: 'old password',
                          controller: _oldPassController,
                          isPassField: true,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Inputtextwithlabel(
                          label: 'new password',
                          controller: _newPassController,
                          isPassField: true,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Inputtextwithlabel(
                          label: 'verify new password',
                          controller: _newVerifyPassController,
                          isPassField: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            } else if (value != _newPassController.text) {
                              return 'Password is not the same as the new password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: buttonStylePrimary(),
                            onPressed: () => _submit(),
                            child: _isLoading
                                ? CircularProgressIndicator()
                                : Text(
                                    'Change Password',
                                    style: TextStyle(
                                      color: AppColors.white,
                                    ),
                                  ),
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
