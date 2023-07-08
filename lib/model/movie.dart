class Movie {
  final dynamic id;
  final double popularity, rating;
  final String? title, backposter, poster, overview;
  Movie({
    this.id,
    required this.popularity,
    required this.rating,
    required this.title,
    required this.backposter,
    required this.poster,
    required this.overview,
  });
  Movie.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        popularity = json["popularity"].toDouble(),
        rating = json["vote_average"].toDouble(),
        title = json["title"],
        backposter = json["backdrop_path"],
        poster = json["poster_path"],
        overview = json["overview"];
}
