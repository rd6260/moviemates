import 'package:flutter/material.dart';
import 'package:moviemates/custom_widgets/movie_card.dart';
import 'package:moviemates/screens/search_screen.dart';
import 'package:moviemates/types/movie.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // const String apiUrl = 'https://api.tvmaze.com/search/shows?q=all';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Movies', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),
      body: getScreen(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        fixedColor: Colors.white,
        
        currentIndex: _selectedIndex, 
        onTap: _onItemTapped, 
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.white,),
            label: 'Search',
          ),
        ],
      ),
    );
  }
}




Widget getScreen(index) {
  switch (index){
    case 0:
      return FutureBuilder<List<Movie>>(
        future: getMovies('https://api.tvmaze.com/search/shows?q=all'),
        builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No movies found'));
          } else {
            final movies = snapshot.data!;

            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return MovieCard(movie: movie);
              },
            );
          }
        },
      );
    case 1:
      return const SearchScreen();
    default:
      return const SearchScreen();
  }
}