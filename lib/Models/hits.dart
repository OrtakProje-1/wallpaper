library hits;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:wallpaperApp/Models/serializers.dart';

part 'hits.g.dart';

abstract class Hits implements Built<Hits, HitsBuilder> {
  Hits._();

  factory Hits([updates(HitsBuilder b)]) = _$Hits;

  @BuiltValueField(wireName: 'id')
  int get id;
  @BuiltValueField(wireName: 'pageURL')
  String get pageURL;
  @BuiltValueField(wireName: 'type')
  String get type;
  @BuiltValueField(wireName: 'tags')
  String get tags;
  @BuiltValueField(wireName: 'previewURL')
  String get previewURL;
  @BuiltValueField(wireName: 'previewWidth')
  int get previewWidth;
  @BuiltValueField(wireName: 'previewHeight')
  int get previewHeight;
  @BuiltValueField(wireName: 'webformatURL')
  String get webformatURL;
  @BuiltValueField(wireName: 'webformatWidth')
  int get webformatWidth;
  @BuiltValueField(wireName: 'webformatHeight')
  int get webformatHeight;
  @BuiltValueField(wireName: 'largeImageURL')
  String get largeImageURL;

  @nullable
  @BuiltValueField(wireName: 'fullHDURL')
  String get fullHDURL;
  @BuiltValueField(wireName: 'imageURL')
  String get imageURL;
  @BuiltValueField(wireName: 'imageWidth')
  int get imageWidth;
  @BuiltValueField(wireName: 'imageHeight')
  int get imageHeight;
  @BuiltValueField(wireName: 'imageSize')
  int get imageSize;
  @BuiltValueField(wireName: 'views')
  int get views;
  @BuiltValueField(wireName: 'downloads')
  int get downloads;
  @BuiltValueField(wireName: 'favorites')
  int get favorites;
  @BuiltValueField(wireName: 'likes')
  int get likes;
  @BuiltValueField(wireName: 'comments')
  int get comments;
  @BuiltValueField(wireName: 'user_id')
  int get userId;
  @BuiltValueField(wireName: 'user')
  String get user;
  @BuiltValueField(wireName: 'userImageURL')
  String get userImageURL;
  String toJson() {
    return json.encode(serializers.serializeWith(Hits.serializer, this));
  }

  static Hits fromJson(String jsonString) {
    return serializers.deserializeWith(
        Hits.serializer, json.decode(jsonString));
  }

  static Serializer<Hits> get serializer => _$hitsSerializer;
}
