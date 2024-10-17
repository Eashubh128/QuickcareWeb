import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationController {
  static ReceivedAction? initialAction;
  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
        null, //'resource://drawable/res_app_icon',//
        [
          NotificationChannel(
              channelKey: 'QuickCareNotificationChannelKey',
              channelName: 'QuickCareNotifications',
              channelDescription: 'NotificationTests',
              playSound: true,
              onlyAlertOnce: true,
              groupAlertBehavior: GroupAlertBehavior.Children,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: Colors.deepPurple,
              ledColor: Colors.deepPurple)
        ],
        debug: true);
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      } else {}
    });

    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  static createNotification(String deviceName) {
    try {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: "QuickCareNotificationChannelKey",
          title: "QuickCare Attention",
          body: "Device $deviceName may need attention !!!",
        ),
      );
    } catch (e) {
      log("Error ocurred in displaying the notification ${e.toString()}");
    }
  }
}
