import 'dart:convert';
import 'package:http/http.dart' as http;

class Movie {
  final String title;
  final String thumbnailUrl;
  final String summary;
  final dynamic show;

  Movie({
    required this.title,
    required this.thumbnailUrl,
    required this.summary,
    required this.show,
  });
}

Future<List<Movie>> getMovies(String url) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map<Movie>((json) {
        final show = json['show'] ?? 'Untitled';
        final title = show['name'];
        final thumbnail = show['image']?['medium'] ?? '';
        final summary = show['summary']?.replaceAll(RegExp(r'<[^>]*>'), '') ??
            'No summary available.';
        return Movie(
          title: title,
          thumbnailUrl: thumbnail,
          summary: summary,
          show: show,
        );
      }).toList();
    } else {
      throw Exception('Failed to load movies: ${response.statusCode}');
    }
  } catch (e) {
    return [];
  }
}
