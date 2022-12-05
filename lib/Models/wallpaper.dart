// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:wallpaper/Models/hit.dart';

class Wallpaper {
  int? total;
  int? totalHits;
  List<Hit>? hits;
  Wallpaper({
    this.total,
    this.totalHits,
    this.hits,
  });

  Wallpaper copyWith({
    int? total,
    int? totalHits,
    List<Hit>? hits,
  }) {
    return Wallpaper(
      total: total ?? this.total,
      totalHits: totalHits ?? this.totalHits,
      hits: hits ?? this.hits,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'total': total,
      'totalHits': totalHits,
      'hits': hits?.map((x) => x.toMap()).toList(),
    };
  }

  factory Wallpaper.fromMap(Map<String, dynamic> map) {
    return Wallpaper(
      total: map['total'] != null ? map['total'] as int : null,
      totalHits: map['totalHits'] != null ? map['totalHits'] as int : null,
      hits: map['hits'] != null
          ? List<Hit>.from(
              (map['hits'] as List<dynamic>).map<Hit?>(
                (x) => Hit.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Wallpaper.fromJson(String source) =>
      Wallpaper.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Wallpaper(total: $total, totalHits: $totalHits, hits: $hits)';

  @override
  bool operator ==(covariant Wallpaper other) {
    if (identical(this, other)) return true;

    return other.total == total &&
        other.totalHits == totalHits &&
        listEquals(other.hits, hits);
  }

  @override
  int get hashCode => total.hashCode ^ totalHits.hashCode ^ hits.hashCode;
}
