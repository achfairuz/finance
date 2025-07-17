import 'package:finance/UI/auth/auth.dart';
import 'package:finance/UI/profile/form_changePass.dart';
import 'package:finance/core/utils/auth_helper.dart';
import 'package:flutter/material.dart';
import 'package:finance/core/constants/constants.dart';

Widget _buildSettingItem(BuildContext context, IconData icon, String title,
    String route, VoidCallback onTap) {
  return ListTile(
    leading: Icon(
      icon,
      color: title == 'Logout' ? AppColors.danger : AppColors.grey,
    ),
    title: Text(
      title,
      style: TextStyle(
        color: title == 'Logout' ? AppColors.danger : AppColors.black,
      ),
    ),
    trailing: Icon(
      Icons.arrow_forward_ios,
      color: title == 'Logout' ? AppColors.danger : AppColors.grey,
      size: 16,
    ),
    onTap: onTap,
  );
}

class CardSetting extends StatelessWidget {
  const CardSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildSettingItem(
          context,
          Icons.favorite_border,
          'Favourites',
          '/favourites',
          () => Navigator.pushNamed(context, '/favourites'),
        ),
        const Divider(),
        _buildSettingItem(context, Icons.download_outlined, 'Downloads',
            '/downloads', () => Navigator.pushNamed(context, '/favourites')),
        const Divider(),
        _buildSettingItem(context, Icons.language, 'Language', '/language',
            () => Navigator.pushNamed(context, '/favourites')),
        const Divider(),
        _buildSettingItem(context, Icons.location_on_outlined, 'Location',
            '/location', () => Navigator.pushNamed(context, '/favourites')),
        const Divider(),
        _buildSettingItem(
          context,
          Icons.password,
          'Change Password',
          '/change-password',
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FormChangepass(),
            ),
          ),
        ),
        const Divider(),
        _buildSettingItem(context, Icons.logout, 'Logout', '/logout', () async {
          await AuthHelper.logout();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const Auth(initialTab: 0),
            ),
            (route) => false,
          );
        }),
      ],
    );
  }
}
