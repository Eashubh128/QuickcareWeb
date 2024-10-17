import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quickcare/controllers/notification_controller.dart';
import 'package:quickcare/firebase_options.dart';
import 'package:quickcare/provider/bledeviceprovider.dart';
import 'package:quickcare/provider/custom_auth_provider.dart';
import 'package:quickcare/provider/deviceslistprovider.dart';
import 'package:quickcare/provider/loginprovider.dart';
import 'package:quickcare/provider/themeprovider.dart';
import 'package:quickcare/router.dart';
import 'package:quickcare/screens/web/homescreen_web.dart';
import 'package:quickcare/screens/web/splashscreen_web.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

///Mobile Screen size 357 * 812
///Desktop Screen size 1280 * 832

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(
  //   fileName: "assets/dotenv",
  // );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationController.initializeLocalNotifications();

  try {
    String? token = await FirebaseMessaging.instance.getToken(
        vapidKey:
            "BFK9sXPRPHFOveaYnpE00qUFstaRI-bAy5Gqlc4lBGjMfUlQkKY422jRqzsE-ypE1n1dd21FAiuwRSwG7Flvizo");
    print("token is $token");
  } catch (e) {
    log("Error in getting token ");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BleDeviceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DevicesListProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (context) => CustomAuthProvider(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(1280, 832),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: "Poppins"),
          routerConfig: router,
        ),
      ),
    ),
  );
}
