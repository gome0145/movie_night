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
