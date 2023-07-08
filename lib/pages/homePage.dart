import 'package:flutter/material.dart';
import 'package:movisius/widgets/genres.dart';
import 'package:movisius/widgets/now_playing.dart';
import 'package:movisius/widgets/persons.dart';

import '../widgets/best_movies.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController searchController;
  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SafeArea(
              child: SizedBox(
                height: 80,
                width: double.infinity,
                child: isSearching
                    ? Row(children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() => isSearching = false);
                          },
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: TextField(
                              controller: searchController,
                              onChanged: (text) async {},
                              decoration: InputDecoration(
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'search ...',
                                suffixIcon: const Icon(Icons.search),
                                suffixIconColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ])
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(flex: 1, child: Container()),
                          const Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                'Movisius',
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              onPressed: () {
                                setState(() => isSearching = true);
                              },
                              icon: const Icon(Icons.search),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            Expanded(
              child: Center(
                child: ListView(
                  children: <Widget>[
                    NowPlaying(),
                    GenresScreen(),
                    PersonsList(),
                    BestMovies(),
                  ],
                ),
              ),
            ),
          ]),
    );
  }

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
