class Genre {
  final dynamic id;
  final String name;
  Genre({
    this.id,
    required this.name,
  });
  Genre.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"];
}
