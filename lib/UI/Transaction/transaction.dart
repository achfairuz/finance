import 'package:finance/core/models/transaction_model.dart';
import 'package:finance/core/utils/transaction_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finance/UI/components/components.dart';
import 'package:finance/core/constants/constants.dart';
import 'package:finance/UI/Transaction/data.dart';
import 'package:finance/UI/Transaction/widget.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  DateTime _selectedDate = DateTime.now();
  List<TransactionModel> allTransaction = [];
  bool isLoading = false;

  Future<void> _loadTransaction() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await TransactionHelper.fetchTransaction();
      isLoading = true;
      setState(() {
        allTransaction = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error get data transaction: $e');
    }
  }

  List<Map<String, dynamic>> get pengeluaranListMap {
    return allTransaction
        .where(
          (data) =>
              data.type == 'pengeluaran' &&
              isSameDate(DateTime.parse(data.date), _selectedDate),
        )
        .map((e) => e.toJson())
        .toList();
  }

  List<Map<String, dynamic>> get pemasukanListMap {
    return allTransaction
        .where(
          (data) =>
              data.type == 'pemasukan' &&
              isSameDate(DateTime.parse(data.date), _selectedDate),
        )
        .map((e) => e.toJson())
        .toList();
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      helpText: 'Pilih Tanggal',
      cancelText: 'Batal',
      confirmText: 'OK',
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
      builder: (context, child) => temaDateTime(context, child),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Widget _buttonDatePicker() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppColors.white),
        ),
      ),
      onPressed: () => _selectDate(context),
      child: Row(
        children: [
          Icon(Icons.date_range, color: AppColors.white),
          const SizedBox(width: 4),
          Text(
            DateFormat('EEEE, d MMMM y', 'id_ID').format(_selectedDate),
            style: TextStyle(color: AppColors.white),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadTransaction();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                height: 160,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaksi',
                      style: TextStyle(
                        fontSize: AppSizes.fontTitle,
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tanggal',
                          style: TextStyle(
                            fontSize: AppSizes.fontMedium,
                            color: AppColors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        _buttonDatePicker(),
                      ],
                    ),
                  ],
                ),
              ),

              // TabBar
              TabBar(
                labelColor: AppColors.coolGray,
                unselectedLabelColor: AppColors.coolGray.withOpacity(0.6),
                indicatorColor: AppColors.coolGray,
                tabs: const [
                  Tab(text: 'Pengeluaran'),
                  Tab(text: 'Pemasukan'),
                ],
              ),

              // TabBarView
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: MyCarts(
                        dataTransaction: pengeluaranListMap,
                        key: ValueKey('pengeluaran'),
                        isLoading: isLoading,
                      ),
                    ),
                    SingleChildScrollView(
                      child: MyCarts(
                        dataTransaction: pemasukanListMap,
                        key: ValueKey('pemasukan'),
                        isLoading: isLoading,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
