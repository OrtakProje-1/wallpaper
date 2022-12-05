import 'package:wallpaper/Models/hit.dart';

class FavoriImage {
  int? id;

  String? pageURL;

  String? type;

  String? tags;

  String? previewURL;

  String? largeImageURL;

  String? imageURL;

  int? views;

  int? downloads;

  int? favorites;

  int? likes;

  int? comments;

  int? userId;

  String? user;

  String? userImageURL;

  FavoriImage(
      {this.comments,
      this.downloads,
      this.favorites,
      this.id,
      this.imageURL,
      this.largeImageURL,
      this.likes,
      this.pageURL,
      this.previewURL,
      this.tags,
      this.type,
      this.user,
      this.userId,
      this.userImageURL,
      this.views});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = this.id;
    map["imageUrl"] = this.imageURL;
    map["largeImageURL"] = this.largeImageURL;
    map["likes"] = this.likes;
    map["pageURL"] = this.pageURL;
    map["previewURL"] = this.previewURL;
    map["tags"] = this.tags;
    map["type"] = this.type;
    map["user"] = this.user;
    map["userId"] = this.userId;
    map["userImageURL"] = this.userImageURL;
    map["views"] = this.views;
    map["comments"] = this.comments;
    map["downloads"] = this.downloads;
    map["favorites"] = this.favorites;
    return map;
  }

  FavoriImage.fromJson(dynamic map) {
    this.id = map["id"];
    this.imageURL = map["imageUrl"];
    this.largeImageURL = map["largeImageURL"];
    this.likes = map["likes"];
    this.pageURL = map["pageURL"];
    this.previewURL = map["previewURL"];
    this.tags = map["tags"];
    this.type = map["type"];
    this.user = map["user"];
    this.userId = map["userId"];
    this.userImageURL = map["userImageURL"];
    this.views = map["views"];
    this.comments = map["comments"];
    this.downloads = map["downloads"];
    this.favorites = map["favorites"];
  }

  static FavoriImage builder(Hit h) {
    return FavoriImage(
        comments: h.comments,
        downloads: h.downloads,
        id: h.id,
        imageURL: h.largeImageURL,
        largeImageURL: h.largeImageURL,
        likes: h.likes,
        pageURL: h.pageURL,
        previewURL: h.previewURL,
        tags: h.tags,
        type: h.type,
        user: h.user,
        userId: h.userId,
        userImageURL: h.userImageURL,
        views: h.views);
  }
}
