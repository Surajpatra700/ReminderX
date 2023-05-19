import 'dart:math';

import 'package:api_networking/main.dart';
import 'package:api_networking/pagetwo.dart';
import 'package:api_networking/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  FirebaseMessaging message = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //1. Requesting Permission
  void getNotificationRequest() async {
    NotificationSettings settings = await message.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: false,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      //Toast.show("Permission Granted",backgroundColor: const Color(0xff00FF00));
      //Utils().toastMessage("Permission Granted");
      print("Permission Granted");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      //Toast.show("Provisional Permission Granted",backgroundColor: const Color(0xff00FF00));
      //Utils().toastMessage("Provisional Permission Granted");
      print("Provinsional Permission Granted");
    } else {
      //Toast.show("No Permission Granted");
      //Utils().toastMessage("No permission granted");
      print("Permission not Granted");
    }
  }

  // 2. Initializing Local Notification in android device
  void initLocalNotification(BuildContext context, RemoteMessage msg) async {
    
    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {
      handleMessage(context, msg);
    });
  }

  // 3.  Initializing Local Notification For Foreground
  void FirebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((event) {
      initLocalNotification(context, event);
      showNotification(event);
    });
  }

  void showNotification(RemoteMessage msg) {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100).toString(),
      "Notification",
      importance: Importance.max,
    );
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      importance: Importance.high,
      priority: Priority.high,
    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    Future.delayed(Duration(seconds: 0), () {
      _flutterLocalNotificationsPlugin.show(
        1,
        msg.notification!.title.toString(),
        msg.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

  Future<String?> getDeviceToken() async {
    return await message.getToken();
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    // When app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    // when app is inbackground
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  // For Click on notification to navigate it to any screen

  void handleMessage(BuildContext context, RemoteMessage msg) {
    // msg.data refers to any additional data sent with the message.
    if (msg.data["data"] == "msg") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PageThree()));
    }
  }
}
