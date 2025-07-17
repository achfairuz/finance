import 'package:finance/UI/Transaction/formTransaction.dart';
import 'package:finance/UI/components/components.dart';
import 'package:finance/UI/components/showModalBottomSet.dart';
import 'package:finance/core/utils/transaction_helper.dart';
import 'package:flutter/material.dart';
import 'package:finance/core/constants/constants.dart';
import 'package:intl/intl.dart';

class Detailtransaction extends StatefulWidget {
  final Map<String, dynamic> data;

  const Detailtransaction({super.key, required this.data});

  @override
  State<Detailtransaction> createState() => _DetailtransactionState();
}

class _DetailtransactionState extends State<Detailtransaction> {
  bool _isLoading = false;
  void _deleteTransaction(int id) async {
    try {
      final _deleteTransaction = await TransactionHelper.deleteTransaction(
        context: context,
        id: id,
        onStart: () => setState(() {
          _isLoading = true;
        }),
        onDone: () => setState(() {
          _isLoading = false;
        }),
      );
      print("$id berhasil di hapus");
    } catch (e) {
      print("error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    String capitalize(String text) {
      if (text.isEmpty) return text;
      return text[0].toUpperCase() + text.substring(1);
    }

    String formattedDate =
        DateFormat('dd MMMM yyyy').format(DateTime.parse(widget.data['date']));

    String formattedTime =
        DateFormat.Hm().format(DateFormat("HH:mm").parse(widget.data['time']));

    return Scaffold(
      backgroundColor: (widget.data['type'] == 'pengeluaran'
          ? AppColors.danger
          : AppColors.success),
      body: Column(
        children: [
          // HEADER
          Padding(
            padding: const EdgeInsets.only(top: 48, left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tombol Back
                IconButton(
                  icon: Icon(Icons.arrow_back, color: AppColors.white),
                  onPressed: () => Navigator.pop(context),
                ),

                // Judul
                Text(
                  capitalize(widget.data['type']),
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: AppSizes.fontTitle,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Tombol Edit dan Delete
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: AppColors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FormTransaction(
                              select: widget.data['type'],
                              id: widget.data['id'],
                              action: 'update',
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: AppColors.white),
                      onPressed: () {
                        customShowModalBottomSheet(
                          context,
                          'Delete',
                          AppColors.danger,
                          () => _deleteTransaction(widget.data['id']),
                          _isLoading,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // NOMINAL
          Text(
            '${widget.data['type'] == 'pengeluaran' ? '-' : '+'} ${formatToRupiah(widget.data['amount']).toString()}',
            style: TextStyle(
              fontSize: AppSizes.fontLarge + 4,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),

          const SizedBox(height: 40),

          // BODY
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ICON
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      widget.data['icon'],
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Date
                  detailRow('Date', formattedDate),
                  const SizedBox(height: 16),

                  detailRow('Time', formattedTime),
                  const SizedBox(height: 16),

                  //TITLE
                  detailRow('Title', widget.data['title']),
                  const SizedBox(height: 16),

                  // CATEGORY
                  detailRow('Category', widget.data['category']),
                  const SizedBox(height: 16),

                  detailRow('Information', widget.data['information']),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget helper untuk setiap baris detail
  Widget detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontSize: AppSizes.fontMedium,
            fontWeight: FontWeight.w500,
            color: AppColors.coolGray,
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: AppSizes.fontMedium,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }
}
