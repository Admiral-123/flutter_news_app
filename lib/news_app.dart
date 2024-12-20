import 'dart:convert';

import 'package:api_project/my_news.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
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

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomLeft,
                              colors: [
                            Color.fromARGB(255, 51, 204, 255),
                            Color.fromARGB(255, 255, 255, 0),
                          ])),
                      child: Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  article?[index].urlToImage ?? 'no data'),
                            ),
                            title: Text(article?[index].author ?? 'no data'),
                            trailing: Text(
                              article?[index].publishedAt ?? 'no data',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(article?[index].title ?? 'no data'),
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
