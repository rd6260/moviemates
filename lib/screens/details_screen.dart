import 'package:flutter/material.dart';


class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> show;

  const DetailScreen({super.key, required this.show});

  @override
  Widget build(BuildContext context) {
    final image = show['image']?['original'];
    final name = show['name'] ?? 'Unknown Title';
    final summary = show['summary'] ?? 'No summary available.';
    final genres = show['genres'] ?? [];
    final rating = show['rating']?['average'] ?? 'N/A';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(name),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (image != null)
              Image.network(
                image,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Genres: ${genres.isNotEmpty ? genres.join(', ') : 'No genres available'}',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Rating: $rating',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Summary',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                summary.replaceAll(RegExp(r'<[^>]*>'), ''), // Remove HTML tags
                style: const TextStyle(color: Colors.white, height: 1.5),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}