import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:quickcare/constants/app_strings.dart';
import 'package:quickcare/constants/color_constants.dart';
import 'package:quickcare/provider/custom_auth_provider.dart';
import 'package:quickcare/provider/themeprovider.dart';

class ChangePasswordWebContainer extends StatefulWidget {
  ChangePasswordWebContainer({super.key, required this.token});
  String token;
  @override
  State<ChangePasswordWebContainer> createState() =>
      _ChangePasswordWebContainerState();
}

class _ChangePasswordWebContainerState
    extends State<ChangePasswordWebContainer> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final GlobalKey<FlutterPwValidatorState> validatorKey =
      GlobalKey<FlutterPwValidatorState>();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 414.w,
      height: 517.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.setNewPassword,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              height: 0.04,
              letterSpacing: 0.33,
            ),
          ),
          SizedBox(
            height: 50.h,
          ),
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
          SizedBox(height: 50.h),
          ElevatedButton(
            onPressed: () async {
              if (_confirmPassController.text == _passwordController.text) {
                try {
                  bool result = await Provider.of<CustomAuthProvider>(context,
                          listen: false)
                      .resetPassword(
                          widget.token, _confirmPassController.text.trim());

                  if (result) {
                    Fluttertoast.showToast(
                        msg:
                            "Password reset successfully , now you can close this page");
                  }
                } catch (e) {
                  Fluttertoast.showToast(msg: e.toString());
                }
              } else {
                Fluttertoast.showToast(msg: "Passwords do not match");
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: DarkTheme.primaryBlue,
              padding: EdgeInsets.zero,
              minimumSize: Size(
                220.w,
                80.h,
              ),
            ),
            child: Text(
              "Set password",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500),
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
