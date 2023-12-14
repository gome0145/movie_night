import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../components/SharedPreferencesManager.dart';
import '../model/movie.dart';
import '../model/movieNight.dart';
import '../model/vote.dart';

class HttpHelper {
  static Future<MovieNight> fetchCode(String method) async {
    String? deviceId = await SharedPreferencesManager.getDeviceId();
    Uri uri = Uri.parse(
        "https://movie-night-api.onrender.com/start-session?device_id=$deviceId");

    await Future<bool>.delayed(
      const Duration(seconds: 3),
      () => true,
    );

    switch (method) {
      case 'get':
        http.Response resp = await http.get(uri);
        if (resp.statusCode == 200) {
          Map<String, dynamic> data =
              jsonDecode(resp.body) as Map<String, dynamic>;
          print(data);
          SharedPreferencesManager.setSessionID(
              data['data']['session_id'].toString());
          return MovieNight.fromJson(data);
        } else {
          throw Exception('Did not get a valid response.');
        }

      default:
        throw Exception('Not a valid method.');
    }
  }

  static Future<MovieNight> fetchEnterCode(String method, int code) async {
    String? deviceId = await SharedPreferencesManager.getDeviceId();
    Uri uri = Uri.parse(
        "https://movie-night-api.onrender.com/join-session?device_id=$deviceId&code=$code");

    await Future<bool>.delayed(
      Duration(seconds: 3),
      () => true,
    );

    switch (method) {
      case 'get':
        http.Response resp = await http.get(uri);
        if (resp.statusCode == 200) {
          Map<String, dynamic> data =
              jsonDecode(resp.body) as Map<String, dynamic>;
          SharedPreferencesManager.setSessionID(
              data["data"]["session_id"].toString());
          return MovieNight.fromJson(data);
        } else {
          throw Exception('Did not get a valid response.');
        }

      default:
        throw Exception('Not a valid method.');
    }
  }

  static Future<List<Movie>> fetchMovies(String method, int page) async {
    String? deviceId = await SharedPreferencesManager.getDeviceId();
    const tmdbApiKey = 'dbf182325919178264e2a6e6ae7b8d69';

    Uri uri = Uri.parse(
        "https://api.themoviedb.org/3/movie/popular?api_key=$tmdbApiKey&page=$page");

    await Future<bool>.delayed(
      Duration(seconds: 2),
      () => true,
    );

    switch (method) {
      case 'get':
        http.Response resp = await http.get(uri);
        if (resp.statusCode == 200) {
          Map<String, dynamic> data =
              jsonDecode(resp.body) as Map<String, dynamic>;
          List<dynamic> results = data['results'] ?? [];
          List<Movie> movies = results.map((movieData) {
            return Movie.fromJson(movieData);
          }).toList();
          return movies;
        } else {
          throw Exception('Did not get a valid response.');
        }

      default:
        throw Exception('Not a valid method.');
    }
  }

  static Future<VoteResult> fetchVote(
      String method, int movieId, bool vote) async {
    String? sessionID = await SharedPreferencesManager.getSessionID();

    Uri uri = Uri.parse(
        "https://movie-night-api.onrender.com/vote-movie?session_id=$sessionID&movie_id=$movieId&vote=$vote");

    switch (method) {
      case 'get':
        http.Response resp = await http.get(uri);
        if (resp.statusCode == 200) {
          Map<String, dynamic> data =
              jsonDecode(resp.body) as Map<String, dynamic>;
          SharedPreferencesManager.setVote(data['data']['match']);
          return VoteResult.fromJson(data);
        } else {
          throw Exception('Did not get a valid response.');
        }

      default:
        throw Exception('Not a valid method.');
    }
  }
}
