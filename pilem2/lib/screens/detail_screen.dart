import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pilem2/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;
  const DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIsFavorite();
  }

  Future<void> _checkIsFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFavorite = prefs.containsKey('movie_${widget.movie.id}');
    });
  }

  Future<void> _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => _isFavorite = !_isFavorite);

    List<String> favoriteMovieIds = prefs.getStringList('favoriteMovies') ?? [];
    if (_isFavorite) {
      prefs.setString('movie_${widget.movie.id}', jsonEncode(widget.movie.toJson()));
      favoriteMovieIds.add(widget.movie.id.toString());
    } else {
      prefs.remove('movie_${widget.movie.id}');
      favoriteMovieIds.remove(widget.movie.id.toString());
    }
    prefs.setStringList('favoriteMovies', favoriteMovieIds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.movie.title)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMovieImage(),
              const SizedBox(height: 20),
              _buildSectionTitle('Overview:'),
              const SizedBox(height: 10),
              Text(widget.movie.overview),
              const SizedBox(height: 20),
              _buildMovieDetail(Icons.calendar_month, 'Release Date:', widget.movie.releaseDate),
              const SizedBox(height: 20),
              _buildMovieDetail(Icons.star, 'Rating:', widget.movie.voteAverage.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMovieImage() {
    return Stack(
      children: [
        Image.network(
          'https://image.tmdb.org/t/p/w500${widget.movie.backdropPath}',
          height: 300,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: _toggleFavorite,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildMovieDetail(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(width: 10),
        Text(value),
      ],
    );
  }
}
