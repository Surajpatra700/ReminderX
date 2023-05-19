import 'dart:convert';

import 'package:api_networking/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationServices services = NotificationServices();

  @override
  void initState() {
    // TODO: implement initState
    services.getNotificationRequest();
    services.FirebaseInit(context);
    services.setupInteractMessage(context);
    //services.handleMessage(context, msg);
    //services.initLocalNotification(context, msg);
    services.getDeviceToken().then((value) {
      print(value);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text"),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              services.getDeviceToken().then((value) async {
                var data = {
                  'to': value.toString(),
                  'priority': 'high',
                  'notification': {
                    'title': 'Suraj',
                    'body': 'Your Birthday is comming soon',
                  },
                  'data': {
                    'data': 'msg',
                  }
                };
                // http.post request is used to send data to the server to create/update a resource.
                await http.post(
                    Uri.parse("https://fcm.googleapis.com/fcm/send"),
                    body: jsonEncode(data),
                    headers: {
                      'Content-Type': 'application/json; charset=UTF-8',
                      'Authorization':
                          'key=AAAA2NSWFaU:APA91bGJnVTVjBuXMq8AZaavAUZRzUwxdqoBrBsB9VEZtVlkI56-lKlIy83DDgGB5_5wjqfCXok4U720jds7BPz5k_KmgPfuvH3CDIUsI18VIOzqwjXpcpQCmh6wzAA2FZvZQvZMBIUK'
                    });
              });
            },
            child: Text("show Notification")),
      ),
    );
  }
}
