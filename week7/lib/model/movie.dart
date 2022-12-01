class Movie {
  final String status;
  final String release_date;
  final String title;

  const Movie({
    required this.status,
    required this.release_date,
    required this.title,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      status: json['status'],
      release_date: json['release_date'],
      title: json['title'],
    );
  }
}