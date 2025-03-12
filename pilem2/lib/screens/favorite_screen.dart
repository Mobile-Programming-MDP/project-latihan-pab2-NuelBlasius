import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pilem2/models/movie.dart';
import 'package:pilem2/screens/detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  FavoriteScreenState createState() => FavoriteScreenState();
}

class FavoriteScreenState extends State<FavoriteScreen> {
  List<Movie> _favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteMovies();
  }

  Future<void> _loadFavoriteMovies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> favoriteMovieIds =
        prefs.getKeys().where((key) => key.startsWith('movie_')).toList();
    
    setState(() {
      _favoriteMovies = favoriteMovieIds
          .map((id) {
            final String? movieJson = prefs.getString(id);
            if (movieJson != null && movieJson.isNotEmpty) {
              return Movie.fromJson(jsonDecode(movieJson));
            }
            return null;
          })
          .whereType<Movie>()
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Movies')),
      body: _favoriteMovies.isEmpty
          ? const Center(child: Text('No favorite movies yet'))
          : ListView.builder(
              itemCount: _favoriteMovies.length,
              itemBuilder: (context, index) {
                final Movie movie = _favoriteMovies[index];
                return _buildMovieTile(movie);
              },
            ),
    );
  }

  Widget _buildMovieTile(Movie movie) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Image.network(
          'https://image.tmdb.org/t/p/w500${movie.posterPath}',
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        ),
        title: Text(movie.title),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(movie: movie),
            ),
          );
        },
      ),
    );
  }
}
