library wallpaper;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:wallpaperApp/Models/hits.dart';
import 'package:wallpaperApp/Models/serializers.dart';

part 'wallpaper.g.dart';

abstract class Wallpaper implements Built<Wallpaper, WallpaperBuilder> {
  Wallpaper._();

  factory Wallpaper([updates(WallpaperBuilder b)]) = _$Wallpaper;

  @BuiltValueField(wireName: 'total')
  int get total;
  @BuiltValueField(wireName: 'totalHits')
  int get totalHits;

  @BuiltValueField(wireName: 'hits')
  BuiltList<Hits> get hits;
  String toJson() {
    return json.encode(serializers.serializeWith(Wallpaper.serializer, this));
  }

  static Wallpaper fromJson(String jsonString) {
    return serializers.deserializeWith(
        Wallpaper.serializer, json.decode(jsonString));
  }

  static Serializer<Wallpaper> get serializer => _$wallpaperSerializer;
}