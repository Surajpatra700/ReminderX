import 'dart:convert';

import 'package:api_networking/notification_services.dart';
import 'package:api_networking/pagetwo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class EventsCalendar extends StatefulWidget {
  const EventsCalendar({super.key});

  @override
  State<EventsCalendar> createState() => _EventsCalendarState();
}

class _EventsCalendarState extends State<EventsCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusDate = DateTime.now();
  DateTime? _selectedDate;

  Map<String, List> mySelectedEvents = {};

  NotificationServices services = NotificationServices();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _selectedDate = _focusDate;
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

  List _listOfDayEvents(DateTime dateTime) {
    if (mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)] != null) {
      return mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)]!;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
        title: Text("ReminderX"),
        actions: [
          IconButton(
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
              icon: Icon(Icons.notifications)),
        ],
      ),

      // BODY
      body: Column(
        children: [
          TableCalendar(
            calendarFormat: _calendarFormat,
            focusedDay: _focusDate,
            firstDay: DateTime(2023),
            lastDay: DateTime(2024),
            onDaySelected: (selectedDate, focusedDay) {
              if (!isSameDay(_selectedDate, selectedDate)) {
                setState(() {
                  _selectedDate = selectedDate;
                  _focusDate = focusedDay;
                });
              }
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDate, day);
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusDate = focusedDay;
            },
            eventLoader: _listOfDayEvents,
          ),
          SizedBox(
            height: 40,
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  //margin: EdgeInsets.all(10),
                  padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    borderRadius: BorderRadius.horizontal(left: Radius.circular(25),right: Radius.circular(25)),
                  ),
                  child: Text("${_selectedDate!.day.toString()}-${_selectedDate!.month.toString()}-${_selectedDate!.year.toString()}"))),
          ),
          ..._listOfDayEvents(_selectedDate!).map(
            (myEvents) => ListTile(
              leading: Icon(
                Icons.done,
                color: Colors.blue.shade700,
              ),
              title: Text("Event title: ${myEvents['eventTitle']}"),
              subtitle: Text("Event title: ${myEvents['eventDesc']}"),
            ),
          ),
        ],
      ),
      // Floating Action Button
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.blue.shade700,
        spaceBetweenChildren: 12,
        spacing: 12,
        children: [
          SpeedDialChild(
            label: "Events add",
            child: Icon(Icons.add_task),
            onTap: () {
              _showAddEventDialog();
            },
          ),
          SpeedDialChild(
            label: "dark mode",
            child: Icon(Icons.dark_mode),
            onTap: () => Get.changeTheme(ThemeData.dark()),
          ),
          SpeedDialChild(
            label: "light mode",
            child: Icon(Icons.light_mode),
            onTap: () => Get.changeTheme(ThemeData.light()),
          ),
          SpeedDialChild(
            label: "remainder",
            child: Icon(Icons.notifications),
            //onTap: ()=> PageThree(),
          ),
        ],
      ),
    );
  }

  void _showAddEventDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        elevation: 3,
        shadowColor: Colors.blue.shade700,
        title: Text(
          "Add Event",
          textAlign: TextAlign.center,
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: titleController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextFormField(
              controller: descriptionController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Cancel")),
          TextButton(
              onPressed: () {
                if (titleController.text.isEmpty &&
                    descriptionController.text.isEmpty) {
                  Get.snackbar("Add Events", "Required title and description",
                      duration: Duration(seconds: 2));
                  return;
                } else {
                  if (mySelectedEvents[
                          DateFormat('yyyy-MM-dd').format(_selectedDate!)] !=
                      null) {
                    mySelectedEvents[
                            DateFormat('yyyy-MM-dd').format(_selectedDate!)]!
                        .add({
                      "eventTitle": titleController.text,
                      "eventDesc": descriptionController.text,
                    });
                  } else {
                    mySelectedEvents[
                        DateFormat('yyyy-MM-dd').format(_selectedDate!)] = [
                      {
                        "eventTitle": titleController.text,
                        "eventDesc": descriptionController.text,
                      }
                    ];
                  }
                  print(
                      "New event for my 2nd task ${json.encode(mySelectedEvents)}");
                  titleController.clear();
                  descriptionController.clear();
                  Get.back();
                }
              },
              child: Text("Add Event")),
        ],
      ),
    );
  }
}
