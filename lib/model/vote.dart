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
