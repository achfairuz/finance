import 'package:finance/UI/profile/form_editProfile.dart';
import 'package:finance/UI/profile/widget.dart';
import 'package:finance/core/models/user_model.dart';
import 'package:finance/core/utils/auth_helper.dart';
import 'package:finance/core/utils/session_helper.dart';
import 'package:flutter/material.dart';
import 'package:finance/core/constants/constants.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserModel? _user;
  @override
  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    final user = await AuthHelper.fetchProfile();
    if (!mounted) return;
    setState(() {
      _user = user;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'My Profile',
            style: TextStyle(
              fontSize: AppSizes.fontMedium,
              color: AppColors.black,
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings,
              ))
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image:
                                AssetImage('assets/images/default_profile.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -12,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GestureDetector(
                            onTap: () {
                              // aksi ketika ikon diklik
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.grey,
                                  width: 1.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                size: 20,
                                color: AppColors.darkGrey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          _user?.name ?? 'User',
                          style: TextStyle(
                            fontSize: AppSizes.fontMedium,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          _user?.email ?? 'user@mail.com',
                          style: TextStyle(
                            fontSize: AppSizes.fontBase,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black.withOpacity(0.6),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FormEditprofile(),
                                ));
                          },
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: AppSizes.fontBase,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 32,
              ),
              Expanded(
                child: CardSetting(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
