import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = "https://api.themoviedb.org/3";
  static const String _apiKey = '10c18dfa53630f23e70c0fa063de6456';

  Future<List<Map<String, dynamic>>> _fetchMovies(String endpoint) async {
    final response = await http.get(Uri.parse("$_baseUrl/$endpoint?api_key=$_apiKey"));
    final data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }

  Future<List<Map<String, dynamic>>> getAllMovies() async {
    return _fetchMovies("movie/now_playing");
  }

  Future<List<Map<String, dynamic>>> getTrendingMovies() async {
    return _fetchMovies("trending/movie/week");
  }

  Future<List<Map<String, dynamic>>> getPopularMovies() async {
    return _fetchMovies("movie/popular");
  }

  Future<List<Map<String, dynamic>>> searchMovies(String query) async {
    final response = await http.get(Uri.parse("$_baseUrl/search/movie?query=$query&api_key=$_apiKey"));
    final data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }
}
