import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:finance/core/constants/constants.dart';
import 'package:intl/intl.dart';

Widget titleText(String title) {
  return Text(
    title,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontTitle,
      color: AppColors.primary,
    ),
  );
}

Widget subTitleText(String subTitle) {
  return Text(
    'Masuk untuk melanjutkan pencatatan keuanganmu dan pantau progres finansialmu setiap hari.',
    style: TextStyle(
      fontSize: AppSizes.fontBase,
      color: AppColors.black.withOpacity(0.6),
    ),
  );
}

void errorInput(BuildContext context, String error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        error,
        style: TextStyle(color: AppColors.white),
      ),
      backgroundColor: AppColors.danger,
    ),
  );
}

TextStyle errorStyleInput() {
  return const TextStyle(
    color: Colors.red,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.italic,
    height: 1.5,
  );
}

ButtonStyle buttonStyleDateTime() {
  return ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(color: AppColors.primary),
    ),
  );
}

ButtonStyle buttonStylePrimary() {
  return ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(color: AppColors.primary),
    ),
  );
}

Widget temaDateTime(BuildContext context, Widget? child) {
  return Theme(
    data: Theme.of(context).copyWith(
      colorScheme: ColorScheme.light(
        primary: AppColors.primary, // Warna tombol OK / jam
        onPrimary: AppColors.white, // Warna teks tombol OK
        onSurface: AppColors.black, // Warna teks jam
      ),
      dialogBackgroundColor: Colors.white,
    ),
    child: child!,
  );
}

final formatRupiah = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp. ',
  decimalDigits: 0,
);

String formatToRupiah(dynamic number) {
  final formatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
  return formatter.format(number);
}
