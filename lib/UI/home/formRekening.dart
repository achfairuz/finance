import 'package:finance/core/models/rekening_model.dart';
import 'package:finance/core/utils/rekening_helper.dart';
import 'package:flutter/material.dart';
import 'package:finance/UI/components/components.dart';
import 'package:finance/UI/components/dropdownInputWidget.dart';
import 'package:finance/UI/components/inputTextWidget.dart';
import 'package:finance/core/constants/constants.dart';
import 'package:flutter/services.dart';
import 'package:finance/UI/home/dataRekening.dart';

class FormRekening extends StatefulWidget {
  final String action;
  final int? id;
  final String? name_bank;
  final double? balance;

  const FormRekening(
      {super.key, required this.action, this.id, this.name_bank, this.balance});

  @override
  State<FormRekening> createState() => _FormRekeningState();
}

class _FormRekeningState extends State<FormRekening> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _rekeningController = TextEditingController();
  final TextEditingController _customRekeningController =
      TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  bool _isLoading = false;
  String? selectedRekening;
  RekeningModel? _rekening;

  void _loadRekening() async {
    final rekening = await RekeningHelper.fetchRekeningById(widget.id!);
    setState(() {
      _rekening = rekening;
      final nameBank = rekening.name_bank;
      if (dataRekening.contains(nameBank)) {
        _rekeningController.text = nameBank.toString();
        selectedRekening = nameBank;
      } else {
        _rekeningController.text = 'Lainnya';
        _customRekeningController.text = nameBank.toString();
        selectedRekening = "Lainnya";
      }
      _balanceController.text = rekening.balance.toString();
    });
  }

  void _submitForm() {
    if (widget.action.isNotEmpty && widget.action == 'create') {
      if (_formKey.currentState!.validate()) {
        final rekening = (selectedRekening == 'Lainnya')
            ? _customRekeningController.text
            : _rekeningController.text;

        RekeningHelper.createRekening(
          context: context,
          name_bank: rekening,
          balance: double.parse(_balanceController.text),
          onStart: () {
            setState(() {
              _isLoading = true;
            });
          },
          onDone: () {
            _isLoading = false;
          },
        );
      }
    } else if (widget.action.isNotEmpty && widget.action == 'update') {
      if (_formKey.currentState!.validate()) {
        final rekening = (selectedRekening == 'Lainnya')
            ? _customRekeningController.text
            : _rekeningController.text;
        RekeningHelper.updateRekening(
          context: context,
          id: widget.id!,
          name_bank: rekening,
          balance: double.parse(_balanceController.text),
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
  }

  @override
  void initState() {
    super.initState();
    if (widget.action.isNotEmpty && widget.action == 'update') {
      _loadRekening();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: AppColors.white),
        ),
        title: Text(
          (widget.action.toLowerCase() == 'tambah')
              ? "Tambah Rekening"
              : "Update Rekening",
          style: TextStyle(color: AppColors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomDropdownField(
                  controller: _rekeningController,
                  options: dataRekening,
                  onChanged: (value) {
                    setState(() {
                      selectedRekening = value;
                    });
                  },
                ),
                if (selectedRekening == 'Lainnya') ...[
                  SizedBox(height: 16),
                  InputText(
                    controller: _customRekeningController,
                    hintText: "Masukkan nama rekening",
                    keyboardType: TextInputType.name,
                  ),
                ],
                SizedBox(height: 16),
                InputText(
                  controller: _balanceController,
                  keyboardType: TextInputType.number,
                  filteringTextInputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  hintText: "Silahkan isi saldo terlebih dahulu",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'tidak boloh kosong';
                    }
                  },
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: buttonStylePrimary(),
                    onPressed: () {
                      _submitForm();
                    },
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text(
                            (widget.action.toLowerCase() == 'tambah')
                                ? "Create"
                                : "Update",
                            style: TextStyle(color: AppColors.white),
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
