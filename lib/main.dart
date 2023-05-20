// ignore_for_file: unused_import

import 'package:api_networking/events_calendar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';

import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      debugShowCheckedModeBanner: false,
      home: EventsCalendar(),
    );
  }
}

// String? stringResponse;
// Map? mapResponse;
// Map? dataResponse;
// List? listResponse;

// class HomePage extends StatefulWidget {
//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   //Map mapResponse;

//   Future apicall() async {
//     http.Response response;
//     response = await http.get(Uri.parse(
//         "https://newsapi.org/v2/everything?q=women%20empowerment&from=2023-02-15&sortBy=publishedAt&apiKey=6b1fae3f2b31407faf66f5d5338f6304"));
//     // we are getting body,headers,request and status code
//     if (response.statusCode == 200) {
//       setState(() {
//         //stringResponse = response.body;
//         mapResponse = json.decode(response.body);
//         listResponse = mapResponse!['articles'];
//       });
//     }
//   }

//   @override
//   void initState() {
//     apicall();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("API Demo"),
//       ),
//       body: GridView.builder(
//         shrinkWrap: true,
//         itemCount: listResponse == null ? 0 : listResponse!.length,
//         gridDelegate:
//             SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
//         itemBuilder: ((context, index) {
//           return Container(
//             height: 440,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: InkWell(
//                     onTap: () async {
//                       final url = listResponse![index]['url'];
//                       await launchUrl(Uri.parse("${url}"));
//                     },
//                     child: Container(
//                       height: 160,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                           image: DecorationImage(
//                               image: NetworkImage(
//                                   listResponse![index]['urlToImage'] == null
//                                       ? CircularProgressIndicator().toString()
//                                       : listResponse![index]['urlToImage']),
//                               fit: BoxFit.cover)),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: Text(
//                     listResponse![index]['title'].toString(),
//                     style:
//                         TextStyle(fontWeight: FontWeight.w600, fontSize: 16.5),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: Text(
//                     listResponse![index]['description'].toString(),
//                     style:
//                         TextStyle(fontWeight: FontWeight.w400, fontSize: 14.5),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
