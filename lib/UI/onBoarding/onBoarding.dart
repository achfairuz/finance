import 'package:finance/UI/auth/auth.dart';
import 'package:finance/UI/components/navbar.dart';
import 'package:finance/core/models/user_model.dart';
import 'package:finance/core/utils/session_helper.dart';
import 'package:flutter/material.dart';
import 'package:finance/core/constants/constants.dart';

class onBoarding1 extends StatefulWidget {
  const onBoarding1({super.key});

  @override
  State<onBoarding1> createState() => _onBoarding1State();
}

class _onBoarding1State extends State<onBoarding1> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  @override
  @override
  void initState() {
    super.initState();
    SessionHelper.checkLogin(context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: PageView(
          controller: _controller,
          onPageChanged: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          children: [
            OnBoardPage(
              controller: _controller,
              image: 'assets/images/onBoarding/OnBoarding1.png',
              title: 'Kelola Keuangan dengan Mudah',
              desc:
                  'Catat pemasukan dan pengeluaran harianmu untuk kontrol finansial yang lebih baik.',
              isLast: false,
            ),
            OnBoardPage(
              controller: _controller,
              image: 'assets/images/onBoarding/OnBoarding2.png',
              title: 'Pantau Pengeluaran Secara Real-Time',
              desc:
                  'Lihat ke mana uangmu pergi dan buat keputusan keuangan yang lebih bijak setiap hari.',
              isLast: false,
            ),
            OnBoardPage(
              controller: _controller,
              image: 'assets/images/onBoarding/OnBoarding3.png',
              title: 'Capai Tujuan Finansialmu',
              desc:
                  'Buat anggaran, tetapkan target tabungan, dan raih impianmu lebih cepat.',
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }
}

class OnBoardPage extends StatelessWidget {
  final String image;
  final String title;
  final String desc;
  final bool isLast;
  final PageController controller;

  const OnBoardPage({
    super.key,
    required this.image,
    required this.title,
    required this.desc,
    required this.controller,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            'assets/images/onBoarding/bg-onboarding.png',
            fit: BoxFit.cover,
          ),
        ),

        // Konten utama di tengah
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 140,
              ),
              Image.asset(image, height: 250),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                desc,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.darkGrey,
                ),
              ),
              const Spacer(), // dorong sisanya ke bawah
            ],
          ),
        ),

        // Tombol Next di bawah tengah
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
              padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      if (isLast) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Auth(initialTab: 0),
                            ));
                      } else {
                        controller.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Container(
                      child: Text(
                        'Next',
                        style: TextStyle(
                          color: AppColors.background,
                          fontWeight: FontWeight.bold,
                          fontSize: AppSizes.fontMedium,
                        ),
                      ),
                    )),
              )),
        ),
      ],
    );
  }
}
