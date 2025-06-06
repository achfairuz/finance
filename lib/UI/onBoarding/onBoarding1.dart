import 'package:flutter/material.dart';

class onBoarding1 extends StatefulWidget {
  const onBoarding1({super.key});

  @override
  State<onBoarding1> createState() => _onBoarding1State();
}

class _onBoarding1State extends State<onBoarding1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              // Expanded(
              //   flex: 6,
              //   child: Image.asset(
              //     'assets/images/onBoarding/bg-onboarding1.png',
              //     fit: BoxFit.contain,
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
