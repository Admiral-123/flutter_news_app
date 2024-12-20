import 'dart:convert';

import 'package:api_project/my_news.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsApp extends StatefulWidget {
  const NewsApp({super.key});

  @override
  State<NewsApp> createState() => NewsAppPage();
}

class NewsAppPage extends State<NewsApp> {
  Future<MyNews> fetchNews() async {
    var url = dotenv.get("api_key");
    var response = await http.get(Uri.parse(
        url)); // Uri.parse converts into universal resource identifier(superset of url and uniform resource name)

    if (response.statusCode == 200) {
      // 200 means the response has been hit
      final result = jsonDecode(response
          .body); // jsonDecode = Parses the string and returns the resulting Json object.
      return MyNews.fromJson(result); // converts json into MyNews
    } else {
      throw Exception("failed to load");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("news app"),
      ),
      body: FutureBuilder(
          future: fetchNews(),
          builder: (context, snapsot) {
            final article = snapsot.data?.articles!;

            if (snapsot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (!snapsot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final newsSource = Uri.parse(article?[index].url ?? '');
                  DateTime time =
                      DateTime.parse(article?[index].publishedAt ?? '');
                  String finalTime =
                      DateFormat('HH:mm, MMM d, yyyy').format(time);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomLeft,
                              colors: [
                                Color(0xff3366cc),
                                Color(0xffffff99),
                              ])),
                      child: Column(
                        children: [
                          Stack(children: [
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0)),
                                child: Image(
                                  image: NetworkImage(
                                      article?[index].urlToImage ?? ''),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 20.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SizedBox(
                                    width: 300,
                                    child: Text(
                                      article?[index].title ?? 'no data',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          backgroundColor:
                                              Color.fromARGB(90, 0, 0, 0),
                                          fontSize: 18.0),
                                    ),
                                  ),
                                ))
                          ]),
                          ListTile(
                            title: Text(
                              article?[index].author ?? 'no data',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              finalTime,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              article?[index].title ?? 'no data',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                onPressed: () => launchUrl(newsSource),
                                child: const Text(
                                  'source',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              )),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: article?.length,
              );
            }
          }),
    );
  }
}
