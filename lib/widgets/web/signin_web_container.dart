// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quickcare/constants/app_strings.dart';
import 'package:quickcare/constants/color_constants.dart';
import 'package:quickcare/provider/custom_auth_provider.dart';
import 'package:quickcare/provider/loginprovider.dart';
import 'package:quickcare/screens/web/homescreen_web.dart';

class SigninWebContainer extends StatefulWidget {
  SigninWebContainer({super.key, required this.tabController});

  TabController tabController;

  @override
  State<SigninWebContainer> createState() => _SigninWebContainerState();
}

class _SigninWebContainerState extends State<SigninWebContainer> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 414.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.welcomeToQuickCare,
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
            height: 24.h,
          ),
          Text(
            AppStrings.emailID,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          TextField(
            controller: _userNameController,
            style: TextStyle(
              color: DarkTheme.primaryWhite,
              fontSize: 15.sp,
            ),
            decoration: InputDecoration(
              enabled: true,
              isDense: true,
              contentPadding: const EdgeInsets.all(15),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 1,
                  color: Color(0xFFD5D5D5),
                ),
                borderRadius: BorderRadius.circular(30.w),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 1,
                  color: Color(0xFFD5D5D5),
                ),
                borderRadius: BorderRadius.circular(30.w),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 1,
                  color: Color(0xFFD5D5D5),
                ),
                borderRadius: BorderRadius.circular(30.w),
              ),
            ),
          ),
          SizedBox(
            height: 24.h,
          ),
          Text(
            AppStrings.password,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          TextField(
            controller: _passwordController,
            style: TextStyle(
              color: DarkTheme.primaryWhite,
              fontSize: 15.sp,
            ),
            decoration: InputDecoration(
              enabled: true,
              isDense: true,
              contentPadding: const EdgeInsets.all(15),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 1,
                  color: Color(0xFFD5D5D5),
                ),
                borderRadius: BorderRadius.circular(30.w),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 1,
                  color: Color(0xFFD5D5D5),
                ),
                borderRadius: BorderRadius.circular(
                  30.w,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 1,
                  color: Color(0xFFD5D5D5),
                ),
                borderRadius: BorderRadius.circular(30.w),
              ),
            ),
          ),
          SizedBox(
            height: 24.h,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                widget.tabController.animateTo(1);
                log("Forgot password");
              },
              child: Text(
                AppStrings.forgotPass,
                style: TextStyle(
                  color: const Color(0xFFD7D7D7),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w300,
                  height: 0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 24.h,
          ),
          ElevatedButton(
            onPressed: () => _validateAndSignIn(),
            style: ElevatedButton.styleFrom(
              backgroundColor: DarkTheme.primaryBlue,
              padding: EdgeInsets.zero,
              minimumSize: Size(
                414.w,
                80.h,
              ),
            ),
            child: Text(
              AppStrings.login,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _validateAndSignIn() {
    if (_userNameController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your username.");
      return;
    }
    if (_passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your password.");
      return;
    }

    _signIn();
  }

  void _signIn() async {
    try {
      bool result =
          await Provider.of<CustomAuthProvider>(context, listen: false).signIn(
              _userNameController.text.trim(), _passwordController.text.trim());
      if (result) {
        GoRouter.of(context).go('/home');
        // // Navigator.pushReplacement(
        // //   context,
        // //   MaterialPageRoute(
        // //     builder: (context) => const HomeScreenWeb(),
        // //   ),
        // );
      } else {
        Fluttertoast.showToast(msg: "Login failed. Please try again.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
