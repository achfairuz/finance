import 'package:finance/UI/auth/loginWidget.dart';
import 'package:finance/UI/auth/registerWidget.dart';
import 'package:flutter/material.dart';

class Auth extends StatefulWidget {
  final int initialTab;
  const Auth({super.key, required this.initialTab});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab, // ← Gunakan parameter dari constructor
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/onBoarding/bg-onboarding.png',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  children: [
                    TabBar(
                      tabs: const [
                        Tab(
                          text: 'Sign In',
                        ),
                        Tab(
                          text: 'Sign Up',
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: Align(
                              key: ValueKey(
                                  'login'), // Ganti key jika ingin animasi aktif
                              alignment: Alignment.topCenter,
                              child: SingleChildScrollView(
                                child: const Login(), // atau widget lainnya
                              ),
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: Duration(
                              milliseconds: 300,
                            ),
                            child: Align(
                              key: ValueKey(
                                  'register'), // Ganti key jika ingin animasi aktif
                              alignment: Alignment.topCenter,
                              child: SingleChildScrollView(
                                child: const Register(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
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
