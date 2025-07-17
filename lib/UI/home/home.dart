import 'package:finance/core/models/monthlyChart.dart';
import 'package:finance/core/utils/transaction_helper.dart';
import 'package:flutter/material.dart';
import 'package:finance/UI/components/components.dart';
import 'package:finance/UI/home/cardWidget.dart';
import 'package:finance/UI/home/chartWidget.dart';
import 'package:finance/UI/home/formRekening.dart';
import 'package:finance/core/constants/constants.dart';
import 'package:finance/core/models/rekening_model.dart';
import 'package:finance/core/models/user_model.dart';
import 'package:finance/core/utils/auth_helper.dart';
import 'package:finance/core/utils/rekening_helper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String selectedYear;
  late List<String> availableYears;
  List<MonthlyChart> incomeChartData = [];
  List<MonthlyChart> expenditureChartData = [];

  bool invisible = false;
  bool _isLoadingIndicator = false;

  UserModel? _user;
  late Future<List<RekeningModel>> futureRekening;
  double _sumBalance = 0.0;

  @override
  void initState() {
    super.initState();
    selectedYear = DateTime.now().year.toString();
    availableYears =
        List.generate(5, (index) => (DateTime.now().year - index).toString());

    _loadUser();
    futureRekening = RekeningHelper.getALLRekening();
    _loadBalance();
    _loadChartData(selectedYear);
  }

  void _loadUser() async {
    final user = await AuthHelper.fetchProfile();
    setState(() {
      _user = user;
    });
  }

  void _loadBalance() async {
    setState(() => _isLoadingIndicator = true);
    final balance = await RekeningHelper.fetchSumBalance();
    if (!mounted) return;
    setState(() {
      _sumBalance = balance;
      _isLoadingIndicator = false;
    });
  }

  void _loadChartData(String year) async {
    try {
      final dataPengeluaran =
          await TransactionHelper.fetchMonthlyChart('pengeluaran');
      final dataPemasukan =
          await TransactionHelper.fetchMonthlyChart('pemasukan');

      setState(() {
        selectedYear = year;
        expenditureChartData = dataPengeluaran[year] ?? [];
        incomeChartData = dataPemasukan[year] ?? [];
      });
    } catch (e) {
      print('Gagal memuat chart: $e');
      setState(() {
        expenditureChartData = [];
        incomeChartData = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildTotalMoneyCard(),
              const SizedBox(height: 20),
              _buildMyRekeningSection(),
              const Divider(),
              const SizedBox(height: 20),
              _buildExpenditureSection(),
              const SizedBox(height: 20),
              _buildIncomeSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your Finance',
                style: TextStyle(fontSize: 14, color: Colors.grey)),
            Text(
              _user?.name ?? 'User',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
            image: const DecorationImage(
              image: AssetImage('assets/images/default_profile.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTotalMoneyCard() {
    final textValue = invisible
        ? '*********'
        : formatRupiah.format(_sumBalance == 0.0 ? 0 : _sumBalance);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      height: 112,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.primary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Money',
                  style: TextStyle(
                    fontSize: AppSizes.fontMedium,
                    color: Colors.white.withOpacity(0.6),
                  )),
              const SizedBox(height: 4),
              _isLoadingIndicator
                  ? const Text('Loading...',
                      style: TextStyle(color: Colors.white))
                  : Text(
                      textValue,
                      style: TextStyle(
                        fontSize: AppSizes.fontTitle,
                        color: AppColors.background,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ],
          ),
          IconButton(
            onPressed: () => setState(() => invisible = !invisible),
            icon: Icon(
              invisible ? Icons.visibility_off : Icons.visibility,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyRekeningSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('MyRekenings',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: AppSizes.fontMedium)),
        const SizedBox(height: 12),
        FutureBuilder<List<RekeningModel>>(
          future: futureRekening,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Gagal memuat rekening: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const FormRekening(action: 'create'),
                    ),
                  );
                },
                child: Container(
                  width: 120,
                  height: 108,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: AppColors.disaturate,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child:
                          const Icon(Icons.add, color: Colors.white, size: 36),
                    ),
                  ),
                ),
              );
            } else {
              return MyCardRekening(bankData: snapshot.data!);
            }
          },
        ),
      ],
    );
  }

  Widget _buildExpenditureSection() {
    final totalExpenditure = expenditureChartData.fold<double>(
        0.0, (sum, item) => sum + item.amount.toDouble());

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.secondary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Expenditure',
                  style: TextStyle(
                    fontSize: AppSizes.fontMedium,
                    color: Colors.white.withOpacity(0.6),
                  )),
              DropdownButton<String>(
                value: selectedYear,
                dropdownColor: AppColors.secondary,
                style: const TextStyle(color: Colors.white),
                underline: const SizedBox(),
                iconEnabledColor: Colors.white,
                items: availableYears.map((String year) {
                  return DropdownMenuItem<String>(
                    value: year,
                    child: Text(year),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedYear = newValue;
                      _loadChartData(selectedYear);
                    });
                  }
                },
              ),
            ],
          ),
          Text(
            invisible ? '*********' : formatRupiah.format(totalExpenditure),
            style: TextStyle(
              fontSize: AppSizes.fontTitle,
              color: AppColors.background,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ChartRekening(monthlyData: expenditureChartData),
        ],
      ),
    );
  }

  Widget _buildIncomeSection() {
    final totalIncome = incomeChartData.fold<double>(
        0.0, (sum, item) => sum + item.amount.toDouble());

    return Container(
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 100),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.secondary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Income',
                  style: TextStyle(
                    fontSize: AppSizes.fontMedium,
                    color: Colors.white.withOpacity(0.6),
                  )),
              DropdownButton<String>(
                value: selectedYear,
                dropdownColor: AppColors.secondary,
                style: const TextStyle(color: Colors.white),
                underline: const SizedBox(),
                iconEnabledColor: Colors.white,
                items: availableYears.map((String year) {
                  return DropdownMenuItem<String>(
                    value: year,
                    child: Text(year),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedYear = newValue;
                      _loadChartData(selectedYear);
                    });
                  }
                },
              ),
            ],
          ),
          Text(
            invisible ? '*********' : formatRupiah.format(totalIncome),
            style: TextStyle(
              fontSize: AppSizes.fontTitle,
              color: AppColors.background,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ChartRekening(monthlyData: incomeChartData),
        ],
      ),
    );
  }
}
