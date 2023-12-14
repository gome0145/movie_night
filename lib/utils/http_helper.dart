import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../components/SharedPreferencesManager.dart';

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

//Data Models

class MovieNight {
  late String message;
  late String code;
  late String sessionId;

  MovieNight({
    required this.message,
    required this.code,
    required this.sessionId,
  });

  MovieNight.fromJson(Map<String, dynamic> data) {
    message = data['data']['message'] ?? '';
    code = data['data']['code'] ?? '';
    sessionId = data['data']['session_id'] ?? '';
  }
}

class Movie {
  late int id;
  late String title;
  late double popularity;
  late String posterPath;
  late double voteAverage;
  late int voteCount;
  late String overview;

  Movie({
    required this.id,
    required this.title,
    required this.popularity,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
    required this.overview,
  });

  Movie.fromJson(Map<String, dynamic> data) {
    id = data['id'] ?? 0;
    title = data['title'] ?? '';
    popularity = data['popularity'] ?? 0.0;
    posterPath = data['poster_path'] ?? "";
    voteAverage = data['vote_average'] ?? 0.0;
    voteCount = data['vote_count'] ?? 0;
    overview = data['overview'] ?? "";
  }
}

class VoteResult {
  late String movieId;
  late bool match;

  VoteResult({
    required this.movieId,
    required this.match,
  });

  VoteResult.fromJson(Map<String, dynamic> data) {
    movieId = data['data']['movie_id'] ?? "";
    match = data['data']['match'] ?? false;
  }
}
