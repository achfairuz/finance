import 'package:flutter/material.dart';
import 'package:finance/core/constants/constants.dart';

void customShowModalBottomSheet(BuildContext context, String titleButtonPrimary,
    Color color, VoidCallback onTap, bool _isLoading) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsetsGeometry.fromLTRB(16, 16, 16, 32),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _isLoading
                  ? CircularProgressIndicator()
                  : _listTileItem(
                      title: titleButtonPrimary, color: color, onTap: onTap),
              Divider(),
              _listTileItem(
                title: 'Batal',
                color: AppColors.black.withOpacity(0.8),
                onTap: () => Navigator.pop(context),
              )
            ],
          ),
        ),
      );
    },
  );
}

Widget _listTileItem({
  required String title,
  required Color color,
  required VoidCallback onTap,
}) {
  return ListTile(
    title: Align(
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: AppSizes.fontMedium,
        ),
      ),
    ),
    onTap: onTap,
  );
}
