// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Hit {
  int? id;
  String? pageURL;
  String? type;
  String? tags;
  String? previewURL;
  int? previewWidth;
  int? previewHeight;
  String? webformatURL;
  int? webformatWidth;
  int? webformatHeight;
  String? largeImageURL;
  int? imageWidth;
  int? imageHeight;
  int? imageSize;
  int? views;
  int? downloads;
  int? collections;
  int? likes;
  int? comments;
  int? userId;
  String? user;
  String? userImageURL;
  Hit({
    this.id,
    this.pageURL,
    this.type,
    this.tags,
    this.previewURL,
    this.previewWidth,
    this.previewHeight,
    this.webformatURL,
    this.webformatWidth,
    this.webformatHeight,
    this.largeImageURL,
    this.imageWidth,
    this.imageHeight,
    this.imageSize,
    this.views,
    this.downloads,
    this.collections,
    this.likes,
    this.comments,
    this.userId,
    this.user,
    this.userImageURL,
  });

  Hit copyWith({
    int? id,
    String? pageURL,
    String? type,
    String? tags,
    String? previewURL,
    int? previewWidth,
    int? previewHeight,
    String? webformatURL,
    int? webformatWidth,
    int? webformatHeight,
    String? largeImageURL,
    int? imageWidth,
    int? imageHeight,
    int? imageSize,
    int? views,
    int? downloads,
    int? collections,
    int? likes,
    int? comments,
    int? userId,
    String? user,
    String? userImageURL,
  }) {
    return Hit(
      id: id ?? this.id,
      pageURL: pageURL ?? this.pageURL,
      type: type ?? this.type,
      tags: tags ?? this.tags,
      previewURL: previewURL ?? this.previewURL,
      previewWidth: previewWidth ?? this.previewWidth,
      previewHeight: previewHeight ?? this.previewHeight,
      webformatURL: webformatURL ?? this.webformatURL,
      webformatWidth: webformatWidth ?? this.webformatWidth,
      webformatHeight: webformatHeight ?? this.webformatHeight,
      largeImageURL: largeImageURL ?? this.largeImageURL,
      imageWidth: imageWidth ?? this.imageWidth,
      imageHeight: imageHeight ?? this.imageHeight,
      imageSize: imageSize ?? this.imageSize,
      views: views ?? this.views,
      downloads: downloads ?? this.downloads,
      collections: collections ?? this.collections,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      userImageURL: userImageURL ?? this.userImageURL,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'pageURL': pageURL,
      'type': type,
      'tags': tags,
      'previewURL': previewURL,
      'previewWidth': previewWidth,
      'previewHeight': previewHeight,
      'webformatURL': webformatURL,
      'webformatWidth': webformatWidth,
      'webformatHeight': webformatHeight,
      'largeImageURL': largeImageURL,
      'imageWidth': imageWidth,
      'imageHeight': imageHeight,
      'imageSize': imageSize,
      'views': views,
      'downloads': downloads,
      'collections': collections,
      'likes': likes,
      'comments': comments,
      'userId': userId,
      'user': user,
      'userImageURL': userImageURL,
    };
  }

  factory Hit.fromMap(Map<String, dynamic> map) {
    return Hit(
      id: map['id'] != null ? map['id'] as int : null,
      pageURL: map['pageURL'] != null ? map['pageURL'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      tags: map['tags'] != null ? map['tags'] as String : null,
      previewURL:
          map['previewURL'] != null ? map['previewURL'] as String : null,
      previewWidth:
          map['previewWidth'] != null ? map['previewWidth'] as int : null,
      previewHeight:
          map['previewHeight'] != null ? map['previewHeight'] as int : null,
      webformatURL:
          map['webformatURL'] != null ? map['webformatURL'] as String : null,
      webformatWidth:
          map['webformatWidth'] != null ? map['webformatWidth'] as int : null,
      webformatHeight:
          map['webformatHeight'] != null ? map['webformatHeight'] as int : null,
      largeImageURL:
          map['largeImageURL'] != null ? map['largeImageURL'] as String : null,
      imageWidth: map['imageWidth'] != null ? map['imageWidth'] as int : null,
      imageHeight:
          map['imageHeight'] != null ? map['imageHeight'] as int : null,
      imageSize: map['imageSize'] != null ? map['imageSize'] as int : null,
      views: map['views'] != null ? map['views'] as int : null,
      downloads: map['downloads'] != null ? map['downloads'] as int : null,
      collections:
          map['collections'] != null ? map['collections'] as int : null,
      likes: map['likes'] != null ? map['likes'] as int : null,
      comments: map['comments'] != null ? map['comments'] as int : null,
      userId: map['userId'] != null ? map['userId'] as int : null,
      user: map['user'] != null ? map['user'] as String : null,
      userImageURL:
          map['userImageURL'] != null ? map['userImageURL'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Hit.fromJson(String source) =>
      Hit.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Hit(id: $id, pageURL: $pageURL, type: $type, tags: $tags, previewURL: $previewURL, previewWidth: $previewWidth, previewHeight: $previewHeight, webformatURL: $webformatURL, webformatWidth: $webformatWidth, webformatHeight: $webformatHeight, largeImageURL: $largeImageURL, imageWidth: $imageWidth, imageHeight: $imageHeight, imageSize: $imageSize, views: $views, downloads: $downloads, collections: $collections, likes: $likes, comments: $comments, userId: $userId, user: $user, userImageURL: $userImageURL)';
  }

  @override
  bool operator ==(covariant Hit other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.pageURL == pageURL &&
        other.type == type &&
        other.tags == tags &&
        other.previewURL == previewURL &&
        other.previewWidth == previewWidth &&
        other.previewHeight == previewHeight &&
        other.webformatURL == webformatURL &&
        other.webformatWidth == webformatWidth &&
        other.webformatHeight == webformatHeight &&
        other.largeImageURL == largeImageURL &&
        other.imageWidth == imageWidth &&
        other.imageHeight == imageHeight &&
        other.imageSize == imageSize &&
        other.views == views &&
        other.downloads == downloads &&
        other.collections == collections &&
        other.likes == likes &&
        other.comments == comments &&
        other.userId == userId &&
        other.user == user &&
        other.userImageURL == userImageURL;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        pageURL.hashCode ^
        type.hashCode ^
        tags.hashCode ^
        previewURL.hashCode ^
        previewWidth.hashCode ^
        previewHeight.hashCode ^
        webformatURL.hashCode ^
        webformatWidth.hashCode ^
        webformatHeight.hashCode ^
        largeImageURL.hashCode ^
        imageWidth.hashCode ^
        imageHeight.hashCode ^
        imageSize.hashCode ^
        views.hashCode ^
        downloads.hashCode ^
        collections.hashCode ^
        likes.hashCode ^
        comments.hashCode ^
        userId.hashCode ^
        user.hashCode ^
        userImageURL.hashCode;
  }
}
