import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moviemates/screens/details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _results = [];
  bool _isLoading = false;

  Future<void> _searchShows(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://api.tvmaze.com/search/shows?q=$query');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _results = json.decode(response.body);
        });
      } else {
        setState(() {
          _results = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
            'Failed to fetch data',
            style: TextStyle(
              color: Colors.white,
            ),
          )),
        );
      }
    } catch (e) {
      setState(() {
        _results = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Search TV Shows',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[900],
                hintText: 'Search for a TV show...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: _searchShows,
            ),
            const SizedBox(height: 16.0),
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.red))
                : Expanded(
                    child: _results.isEmpty
                        ? const Center(
                            child: Text(
                              'No results found',
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.white),
                            ),
                          )
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              childAspectRatio: 0.7,
                            ),
                            itemCount: _results.length,
                            itemBuilder: (context, index) {
                              final show = _results[index]['show'];
                              final image = show['image']?['medium'];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailScreen(show: show),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: image != null
                                        ? DecorationImage(
                                            image: NetworkImage(image),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                    color: Colors.grey[800],
                                  ),
                                  child: image == null
                                      ? const Center(
                                          child: Icon(
                                            Icons.tv,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                        )
                                      : null,
                                ),
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
