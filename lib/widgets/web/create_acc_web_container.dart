import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:quickcare/constants/app_strings.dart';
import 'package:quickcare/constants/color_constants.dart';
import 'package:quickcare/provider/custom_auth_provider.dart';
import 'package:quickcare/provider/themeprovider.dart';

class CreateAccountWebContainer extends StatefulWidget {
  CreateAccountWebContainer({super.key});

  @override
  State<CreateAccountWebContainer> createState() =>
      _CreateAccountWebContainerState();
}

class _CreateAccountWebContainerState extends State<CreateAccountWebContainer> {
  bool isAdmin = false;

  final GlobalKey<FlutterPwValidatorState> validatorKey =
      GlobalKey<FlutterPwValidatorState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              'Create Account',
              style: TextStyle(
                color: Provider.of<ThemeProvider>(context).isDarkTheme
                    ? DarkTheme.primaryWhite
                    : LightTheme.textColorPrimary,
                fontSize: 20.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 0.07,
                letterSpacing: 0.33,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          _buildTextField('Username', _usernameController),
          SizedBox(height: 24.h),
          _buildTextField('Email ID', _emailController),
          SizedBox(height: 24.h),
          _buildTextField('Name', _nameController),
          SizedBox(height: 24.h),
          _buildTextField('Phone', _phoneController),
          SizedBox(height: 24.h),
          _buildTextField('Password', _passwordController, isPassword: true),
          SizedBox(height: 12.h),
          FlutterPwValidator(
            key: validatorKey,
            controller: _passwordController,
            minLength: 8,
            lowercaseCharCount: 0,
            uppercaseCharCount: 1,
            numericCharCount: 1,
            specialCharCount: 1,
            width: 300.w,
            height: 120.h,
            defaultColor: Provider.of<ThemeProvider>(context).isDarkTheme
                ? DarkTheme.primaryWhite
                : LightTheme.textColorPrimary,
            onSuccess: () {},
            onFail: () {},
          ),
          SizedBox(height: 12.h),
          _buildTextField('Confirm Password', _confirmPassController,
              isPassword: true),
          SizedBox(height: 24.h),
          Row(children: [
            Text(
              "isAdmin",
              style: TextStyle(
                color: Provider.of<ThemeProvider>(context).isDarkTheme
                    ? DarkTheme.primaryWhite
                    : LightTheme.textColorPrimary,
                fontSize: 16.sp,
              ),
            ),
            Checkbox(
                value: isAdmin,
                onChanged: (value) {
                  setState(() {
                    isAdmin = value!;
                  });
                }),
          ]),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: MaterialButton(
              onPressed: () async {
                if (_confirmPassController.text == _passwordController.text) {
                  try {
                    bool result = await Provider.of<CustomAuthProvider>(context,
                            listen: false)
                        .createAccount(
                      username: _usernameController.text.trim(),
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                      name: _nameController.text.trim(),
                      phone: _phoneController.text.trim(),
                      isAdmin: isAdmin,
                    );
                    if (result) {
                      Fluttertoast.showToast(
                          msg: "Account created successfully");
                    } else {
                      Fluttertoast.showToast(msg: "Failed to create account");
                    }
                  } catch (e) {
                    Fluttertoast.showToast(
                        msg: "Failed to create account , ${e.toString()}");
                  }
                } else {
                  Fluttertoast.showToast(msg: "Passwords do not match.");
                }
              },
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                'Create account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Provider.of<ThemeProvider>(context).isDarkTheme
                      ? DarkTheme.primaryWhite
                      : LightTheme.textColorPrimary,
                  fontSize: 14.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  height: 0.18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Provider.of<ThemeProvider>(context).isDarkTheme
                ? DarkTheme.primaryWhite
                : LightTheme.textColorPrimary,
            fontSize: 14.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            height: 0,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          keyboardType:
              isPassword ? TextInputType.visiblePassword : TextInputType.text,
          textAlignVertical: TextAlignVertical.center,
          obscureText: isPassword,
          style: TextStyle(
            color: Provider.of<ThemeProvider>(context).isDarkTheme
                ? DarkTheme.primaryWhite
                : LightTheme.textColorPrimary,
          ),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: const BorderSide(color: Color(0xFFD5D5D5), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: const BorderSide(color: Color(0xFFD5D5D5), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: const BorderSide(color: Color(0xFFD5D5D5), width: 1),
            ),
            filled: true,
            fillColor: Provider.of<ThemeProvider>(context).isDarkTheme
                ? LightTheme.textColorPrimary
                : DarkTheme.primaryWhite,
            hintText: label,
            hintStyle: TextStyle(
              color: Provider.of<ThemeProvider>(context).isDarkTheme
                  ? DarkTheme.primaryWhite
                  : LightTheme.textColorPrimary,
              fontSize: 14.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}
