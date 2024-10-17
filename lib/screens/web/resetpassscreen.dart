import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickcare/constants/asset_constants.dart';
import 'package:quickcare/widgets/web/change_password_web_container.dart';
import 'package:quickcare/widgets/web/reset_pass_web_container.dart';

class ResetPasswordScreen extends StatefulWidget {
  ResetPasswordScreen({super.key, required this.token});
  String token;
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with SingleTickerProviderStateMixin {
  bool isCreateAcc = false;
  bool isForgotPass = false;

  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage(AssetConstants.backgroundImageAsset),
          fit: BoxFit.fill,
        )),
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5.0,
                  sigmaY: 5.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0XFF282A2D).withOpacity(.5),
                        const Color(0XFF282A2D).withOpacity(.5),
                        const Color(0XFF030303),
                        const Color(0XFF030303),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 190.w,
              top: 50.h,
              bottom: 50.h,
              child: Container(
                padding: EdgeInsets.all(50.w),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image(
                      image:
                          const AssetImage(AssetConstants.newDeviceImageAsset),
                      width: 350.w,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              child: SizedBox(
                width: 200.w,
                child: Image.asset(
                  AssetConstants.splashScreenAsset,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              right: 20.w,
              top: 50.h,
              bottom: 50.h,
              child: Container(
                width: 414.w,
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [ChangePasswordWebContainer(token: widget.token)],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
