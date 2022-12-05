// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:wallpaper/Models/wallpaper.dart';

class SearchWallpaper {
  String query;
  Wallpaper wallpaper;
  SearchWallpaper({
    required this.query,
    required this.wallpaper,
  });

  SearchWallpaper copyWith({
    String? query,
    Wallpaper? wallpaper,
  }) {
    return SearchWallpaper(
      query: query ?? this.query,
      wallpaper: wallpaper ?? this.wallpaper,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'query': query,
      'wallpaper': wallpaper.toMap(),
    };
  }

  factory SearchWallpaper.fromMap(Map<String, dynamic> map) {
    return SearchWallpaper(
      query: map['query'] as String,
      wallpaper: Wallpaper.fromMap(map['wallpaper'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchWallpaper.fromJson(String source) =>
      SearchWallpaper.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SearchWallpaper(query: $query, wallpaper: $wallpaper)';

  @override
  bool operator ==(covariant SearchWallpaper other) {
    if (identical(this, other)) return true;

    return other.query == query && other.wallpaper == wallpaper;
  }

  @override
  int get hashCode => query.hashCode ^ wallpaper.hashCode;
}
