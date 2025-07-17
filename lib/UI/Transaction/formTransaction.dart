import 'package:finance/UI/components/DatePickerWidget.dart';
import 'package:finance/UI/components/components.dart';
import 'package:finance/UI/components/dropdownInputWidget.dart';
import 'package:finance/UI/components/inputTextWidget.dart';
import 'package:finance/UI/components/timePickerWidget.dart';
import 'package:finance/core/models/transaction_model.dart';
import 'package:finance/core/utils/rekening_helper.dart';
import 'package:finance/core/utils/transaction_helper.dart';
import 'package:flutter/material.dart';
import 'package:finance/core/constants/constants.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class FormTransaction extends StatefulWidget {
  final int? id;
  final String select;
  final String action;
  const FormTransaction(
      {super.key, required this.select, this.id, required this.action});

  @override
  State<FormTransaction> createState() => _FormTransactionState();
}

class _FormTransactionState extends State<FormTransaction> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _rekeningController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _informationController = TextEditingController();

  final now = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  int _rekeningId = 0;
  bool _isLoading = false;
  List<Map<String, dynamic>> dataRekening = [];
  TransactionModel? dataTransaction;

  @override
  void initState() {
    super.initState();
    _loadRekening();

    if (widget.action == 'update' && widget.id != null) {
      _loadTransaction(widget.id!);
    } else {
      _dateController.text = DateFormat('yyyy-MM-dd').format(now);
      _timeController.text = DateFormat('HH:mm:ss').format(now);
    }
  }

  void _loadTransaction(int id) async {
    try {
      final transaction = await TransactionHelper.getById(id);
      setState(() {
        dataTransaction = transaction;

        _titleController.text = transaction.title;
        _categoryController.text = transaction.category;
        _informationController.text = transaction.information;
        _amountController.text = transaction.amount.toString();

        final date = transaction.date is DateTime
            ? transaction.date as DateTime
            : DateTime.parse(transaction.date.toString());

        _dateController.text = DateFormat('yyyy-MM-dd').format(date);

        _timeController.text = transaction.time;
        _rekeningController.text = transaction.rekening?.name_bank ?? '';
        _rekeningId = transaction.rekening_id;
      });
    } catch (e) {
      print('GAGAL memuat transaksi: ${e}');
    }
  }

  void _loadRekening() async {
    try {
      final userRekening = await RekeningHelper.getALLRekening();
      final extract = userRekening.map((rek) {
        return {
          'id': rek.id.toString(),
          'name_bank': rek.name_bank ?? '',
        };
      }).toList();

      setState(() {
        dataRekening = extract;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data rekening')),
      );
    }
  }

  void _submitTransaction() {
    if (_formKey.currentState!.validate()) {
      // final parsedAmount = int.tryParse(_amountController.text);
      // if (parsedAmount == null) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Jumlah tidak valid')),
      //   );
      //   return;
      // }

      if (widget.action.isNotEmpty && widget.action == 'create') {
        if (widget.select == 'pemasukan') {
          TransactionHelper.createIncome(
            context: context,
            rekening_id: _rekeningId,
            date: _dateController.text,
            time: _timeController.text,
            title: _titleController.text,
            category: _categoryController.text,
            amount: double.parse(_amountController.text),
            information: _informationController.text,
            onStart: () => setState(() => _isLoading = true),
            onDone: () => setState(() => _isLoading = false),
          );
        } else {
          TransactionHelper.createExpenditure(
            context: context,
            rekening_id: _rekeningId,
            date: _dateController.text,
            time: _timeController.text,
            title: _titleController.text,
            category: _categoryController.text,
            amount: double.parse(_amountController.text),
            information: _informationController.text,
            onStart: () => setState(() => _isLoading = true),
            onDone: () => setState(() => _isLoading = false),
          );
        }
      } else if (widget.action.isNotEmpty && widget.action == 'update') {
        if (_amountController == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Jumlah tidak valid')),
          );
          return;
        }
        TransactionHelper.updateTransaction(
          context: context,
          id: widget.id!,
          rekening_id: _rekeningId,
          date: _dateController.text,
          time: _timeController.text,
          title: _titleController.text,
          category: _categoryController.text,
          amount: double.parse(_amountController.text),
          information: _informationController.text,
          type: widget.select,
          onStart: () {
            setState(() {
              _isLoading = true;
            });
            debugPrint('--- [DEBUG] Update Transaction ---');
            debugPrint('ID: ${widget.id}');
            debugPrint('Rekening ID: $_rekeningId');
            debugPrint('Date: ${_dateController.text}');
            debugPrint('Time: ${_timeController.text}');
            debugPrint('Title: ${_titleController.text}');
            debugPrint('Category: ${_categoryController.text}');
            debugPrint('Amount: ${_amountController.text}');
            debugPrint('Information: ${_informationController.text}');
            debugPrint('Type: ${widget.select}');
            debugPrint('-----------------------------------');
          },
          onDone: () => setState(() {
            _isLoading = false;
          }),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: AppColors.white),
        ),
        title: Text(
          widget.select == 'pengeluaran' ? 'Pengeluaran' : 'Pemasukan',
          style: TextStyle(
            fontSize: AppSizes.fontLarge,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: DatePickerWidget(controller: _dateController),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                        flex: 2,
                        child: Timepickerwidget(
                          controller: _timeController,
                          dateController: _dateController,
                        )),
                  ],
                ),
                const SizedBox(height: 12),
                CustomDropdownField(
                  controller: _rekeningController,
                  options: dataRekening,
                  onChanged: (value) {
                    setState(() {
                      _rekeningId = int.parse(value);
                    });
                  },
                ),
                const SizedBox(height: 12),
                InputText(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  filteringTextInputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  hintText: 'Masukkan jumlahnya ya..',
                ),
                const SizedBox(height: 12),
                InputText(
                  controller: _titleController,
                  keyboardType: TextInputType.text,
                  hintText: 'Ketik disini untuk judul...',
                ),
                const SizedBox(height: 12),
                InputText(
                  controller: _categoryController,
                  keyboardType: TextInputType.text,
                  hintText: 'Ketik disini untuk kategori...',
                ),
                const SizedBox(height: 12),
                InputText(
                  controller: _informationController,
                  keyboardType: TextInputType.text,
                  hintText: 'Ketik disini untuk menambah keterangan...',
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 140,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitTransaction,
                      style: buttonStylePrimary(),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              widget.action == 'create' ? 'Create' : 'update',
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
          ),
        ),
      ),
    );
  }
}
