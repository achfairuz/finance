import 'package:flutter/material.dart';
import 'package:finance/UI/home/home.dart';
import 'package:finance/UI/Transaction/transaction.dart';
import 'package:finance/UI/chat/chatBot.dart';
import 'package:finance/UI/profile/profile.dart';
import 'package:finance/UI/Transaction/formTransaction.dart';
import 'package:finance/core/constants/app_colors.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Home(),
    const Transaction(),
    const ChatBot(),
    const Profile(),
  ];

  void _onCenterButtonPressed() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    icon: const Icon(Icons.arrow_downward, color: Colors.white),
                    label: const Text(
                      'Pemasukan',
                      style: TextStyle(
                        color: AppColors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FormTransaction(
                            select: 'pemasukan',
                            action: 'create',
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    icon: const Icon(Icons.arrow_upward, color: Colors.white),
                    label: const Text(
                      'Pengeluaran',
                      style: TextStyle(
                        color: AppColors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FormTransaction(
                            select: 'pengeluaran',
                            action: 'create',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_currentIndex],
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 80,
              color: AppColors.shade,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(Icons.home, 0),
                  _navItem(Icons.currency_exchange, 1),
                  const SizedBox(width: 56), // Tempat tombol tengah
                  _navItem(Icons.chat, 2),
                  _navItem(Icons.person, 3),
                ],
              ),
            ),
          ),

          // Tombol tengah menggunakan Positioned
          Positioned(
            bottom: 48,
            left: MediaQuery.of(context).size.width / 2 - 28,
            child: GestureDetector(
              onTap: _onCenterButtonPressed,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          color:
              isSelected ? AppColors.white : AppColors.white.withOpacity(0.4),
        ),
      ),
    );
  }
}
