import 'package:finance/UI/components/components.dart';
import 'package:flutter/material.dart';
import 'package:finance/core/constants/constants.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatefulWidget {
  final TextEditingController? controller;
  final Function(DateTime)? onChanged;

  const DatePickerWidget({super.key, this.controller, this.onChanged});

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  /// Parse tanggal dari controller (jika ada)
  DateTime get selectedDate {
    final text = widget.controller?.text ?? '';
    if (text.isNotEmpty) {
      try {
        return DateFormat('yyyy-MM-dd').parse(text);
      } catch (e) {
        // fallback jika parsing gagal
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      helpText: 'Pilih Tanggal',
      cancelText: 'Batal',
      confirmText: 'OK',
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) => temaDateTime(context, child),
    );
    if (picked != null) {
      widget.controller?.text = DateFormat('yyyy-MM-dd').format(picked);
      if (widget.onChanged != null) {
        widget.onChanged!(picked);
      }
      setState(() {}); // agar label berubah juga
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedLabel = DateFormat('EEEE, dd/MM/yyyy', 'id_ID')
        .format(selectedDate); // tampilkan labelnya

    return ElevatedButton(
      style: buttonStyleDateTime(),
      onPressed: () => _selectDate(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              formattedLabel,
              style: TextStyle(color: AppColors.shade),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.date_range, color: AppColors.shade),
        ],
      ),
    );
  }
}
