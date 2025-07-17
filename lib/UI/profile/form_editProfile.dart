import 'package:finance/UI/components/components.dart';
import 'package:finance/UI/components/inputTextwithLabel.dart';
import 'package:finance/UI/components/showModalBottomSet.dart';
import 'package:finance/core/models/user_model.dart';
import 'package:finance/core/utils/auth_helper.dart';
import 'package:flutter/material.dart';
import 'package:finance/core/constants/constants.dart';

class FormEditprofile extends StatefulWidget {
  const FormEditprofile({super.key});

  @override
  State<FormEditprofile> createState() => _FormEditprofileState();
}

class _FormEditprofileState extends State<FormEditprofile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  UserModel? _user;
  final _formkey = GlobalKey<FormState>();

  void _loadUser() async {
    final user = await AuthHelper.fetchProfile();
    if (!mounted) return;
    setState(() {
      _user = user;
      _nameController.text = _user?.name ?? '';
      _usernameController.text = _user?.username ?? '';
      _emailController.text = _user?.email ?? '';
      print("User loaded: $_user");
    });
  }

  @override
  void initState() {
    super.initState();

    _loadUser();
  }

  void _submitProfile() {
    if (_formkey.currentState!.validate()) {
      AuthHelper.updateProfile(
        context: context,
        name: _nameController.text,
        username: _usernameController.text,
        email: _emailController.text,
        onStart: () => setState(() {
          _isLoading = true;
        }),
        onDone: () => setState(() {
          _isLoading = false;
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: AppSizes.fontMedium,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 12, vertical: 20),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  height: 40,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadiusDirectional.circular(20),
                  ),
                  child: Column(
                    children: [
                      Inputtextwithlabel(
                        label: 'Name',
                        controller: _nameController,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Inputtextwithlabel(
                          label: 'Username', controller: _usernameController),
                      SizedBox(
                        height: 12,
                      ),
                      Inputtextwithlabel(
                          label: 'Email', controller: _emailController),
                      SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: buttonStylePrimary(),
                          onPressed: () => _submitProfile(),
                          child: _isLoading
                              ? CircularProgressIndicator()
                              : Text(
                                  'Update Profile',
                                  style: TextStyle(
                                    color: AppColors.white,
                                  ),
                                ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
