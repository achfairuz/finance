import 'package:flutter/material.dart';

class CustomDropdownField extends StatefulWidget {
  final TextEditingController controller;
  final List<dynamic> options;
  final void Function(String)? onChanged;

  const CustomDropdownField({
    super.key,
    required this.controller,
    required this.options,
    this.onChanged,
  });

  @override
  State<CustomDropdownField> createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField> {
  bool _isMapList() {
    return widget.options.isNotEmpty &&
        widget.options.first is Map<String, dynamic>;
  }

  void _showPicker(BuildContext context) {
    final bool isMap = _isMapList();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shrinkWrap: true,
          children: widget.options.map((item) {
            late String display;
            late String value;

            if (isMap) {
              final mapItem = item as Map<String, dynamic>;
              display = mapItem['name_bank'] ?? '';
              value = mapItem['id'].toString();
            } else {
              display = item as String;
              value = item;
            }

            return ListTile(
              title: Text(display),
              onTap: () {
                widget.controller.text = display;
                widget.onChanged?.call(value);
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true,
      onTap: () => _showPicker(context),
      decoration: const InputDecoration(
        labelText: 'Pilih Rekening',
        suffixIcon: Icon(Icons.arrow_drop_down),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Silakan pilih rekening';
        }
        return null;
      },
    );
  }
}
