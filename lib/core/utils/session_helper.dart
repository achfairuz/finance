import 'package:finance/UI/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:finance/core/utils/auth_helper.dart';
import 'package:finance/UI/components/navbar.dart';

class SessionHelper {
  static Future<void> checkLogin(BuildContext context) async {
    final user = await AuthHelper.getUser();
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Navbar()),
      );
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Auth(initialTab: 1),
          ));
    }
  }
}
