import 'package:finance/UI/components/components.dart';
import 'package:finance/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputText extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? filteringTextInputFormatter;
  final String? Function(String?)? validator;
  const InputText({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.hintText,
    this.validator,
    this.filteringTextInputFormatter,
  });

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  bool get isPassField => widget.hintText.toLowerCase().contains('password');

  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        obscureText: isPassField ? !isVisible : false,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.filteringTextInputFormatter != null
            ? widget.filteringTextInputFormatter!
            : [],
        validator: widget.validator,
        controller: widget.controller,
        decoration: customInputDecoration(),
      ),
    );
  }

  InputDecoration customInputDecoration() {
    return InputDecoration(
      hintText: widget.hintText,
      hintStyle: TextStyle(color: AppColors.darkGrey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        // tanpa garis luar
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.danger),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.danger),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      filled: true,
      fillColor: Colors.white,
      errorStyle: errorStyleInput(),
      suffixIcon: isPassField
          ? IconButton(
              onPressed: () {
                setState(() {
                  isVisible = !isVisible;
                });
              },
              icon: Icon(
                isVisible ? Icons.visibility_off : Icons.visibility,
              ),
            )
          : null,
    );
  }
}
