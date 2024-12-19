import 'package:api_project/news_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "api app",
      debugShowCheckedModeBanner: false,
      home: NewsApp(),
    );
  }
}

// class Main extends StatelessWidget {
//   const Main({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const PreferredSize(
//           preferredSize: Size(double.infinity, 30), child: Text('news app')),
//       body: Container(),
//     );
//   }
// }
