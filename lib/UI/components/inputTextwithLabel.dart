import 'package:flutter/material.dart';
import 'package:finance/core/constants/constants.dart';

class Inputtextwithlabel extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? isPassField;
  final String? Function(String?)? validator;
  const Inputtextwithlabel(
      {super.key,
      required this.label,
      required this.controller,
      this.keyboardType,
      this.isPassField,
      this.validator});

  @override
  State<Inputtextwithlabel> createState() => _InputtextwithlabelState();
}

class _InputtextwithlabelState extends State<Inputtextwithlabel> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final isFilled = widget.controller.text.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label),
        SizedBox(
          height: 4,
        ),
        TextFormField(
          obscureText:
              (widget.isPassField != null && widget.isPassField == true)
                  ? !_isVisible
                  : false,
          decoration: InputDecoration(
            hintText: (widget.isPassField != null && widget.isPassField == true)
                ? ''
                : (isFilled)
                    ? widget.controller.text
                    : '',
            hintStyle: TextStyle(
              color: AppColors.black.withOpacity(0.6),
            ),
            suffixIcon: (widget.isPassField != null &&
                    widget.isPassField == true)
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _isVisible = !_isVisible;
                      });
                    },
                    icon: Icon(
                        _isVisible ? Icons.visibility_off : Icons.visibility),
                  )
                : null,
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.black.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(40),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.primary,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.danger,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.danger,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          controller: widget.controller,
          validator: widget.validator ??
              (value) {
                // validasi default
                if (value == null || value.isEmpty) {
                  return 'Field ini wajib diisi';
                } else if (value.length <= 6) {
                  return 'Password must be more than 6 characters';
                }
                return null;
              },
        )
      ],
    );
  }
}
