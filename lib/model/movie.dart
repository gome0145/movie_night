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
