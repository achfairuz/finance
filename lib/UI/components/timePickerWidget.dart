import 'package:finance/UI/components/components.dart';
import 'package:flutter/material.dart';
import 'package:finance/core/constants/constants.dart';
import 'package:intl/intl.dart';

class Timepickerwidget extends StatefulWidget {
  final TextEditingController? controller;
  final TextEditingController? dateController;

  const Timepickerwidget({super.key, this.controller, this.dateController});

  @override
  State<Timepickerwidget> createState() => _TimepickerwidgetState();
}

class _TimepickerwidgetState extends State<Timepickerwidget> {
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();

    if (widget.controller?.text.isNotEmpty ?? false) {
      final parts = widget.controller!.text.split(":");
      if (parts.length >= 2) {
        final hour = int.tryParse(parts[0]) ?? 0;
        final minute = int.tryParse(parts[1]) ?? 0;
        _selectedTime = TimeOfDay(hour: hour, minute: minute);
      }
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      helpText: 'Pilih waktu',
      cancelText: 'Batal',
      confirmText: 'Pilih',
      builder: (context, child) => temaDateTime(context, child),
    );

    if (picked != null) {
      final now = DateTime.now();

      // Ambil tanggal dari controller
      final dateText = widget.dateController?.text ?? '';
      DateTime selectedDate;

      try {
        selectedDate = DateFormat('yyyy-MM-dd').parse(dateText);
      } catch (_) {
        selectedDate = now;
      }

      final combinedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        picked.hour,
        picked.minute,
      );

      if (combinedDateTime.isAfter(now)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak bisa memilih waktu di masa depan')),
        );
        return;
      }

      setState(() {
        _selectedTime = picked;
        widget.controller?.text =
            "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00";
      });
    }
  }

  String _getFormattedTime() {
    if (widget.controller?.text.isNotEmpty ?? false) {
      return widget.controller!.text.substring(0, 5); // hh:mm
    } else {
      return _selectedTime.format(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _selectTime(context),
      style: buttonStyleDateTime(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _getFormattedTime(),
            style: const TextStyle(color: AppColors.primary),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.access_time, color: AppColors.primary),
        ],
      ),
    );
  }
}
