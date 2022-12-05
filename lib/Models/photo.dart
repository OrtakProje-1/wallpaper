// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Photo {
  String id;
  String lowImageUrl;
  String maxImageUrl;
  String url;
  double width;
  double height;
  Photo({
    required this.id,
    required this.lowImageUrl,
    required this.maxImageUrl,
    required this.url,
    required this.width,
    required this.height,
  });

  Photo copyWith({
    String? id,
    String? lowImageUrl,
    String? maxImageUrl,
    String? url,
    double? width,
    double? height,
  }) {
    return Photo(
      id: id ?? this.id,
      lowImageUrl: lowImageUrl ?? this.lowImageUrl,
      maxImageUrl: maxImageUrl ?? this.maxImageUrl,
      url: url ?? this.url,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'lowImageUrl': lowImageUrl,
      'maxImageUrl': maxImageUrl,
      'url': url,
      'width': width,
      'height': height,
    };
  }

  factory Photo.fromMap(Map<String, dynamic> map) {
    return Photo(
      id: map['id'] as String,
      lowImageUrl: map['lowImageUrl'] as String,
      maxImageUrl: map['maxImageUrl'] as String,
      url: map['url'] as String,
      width: map['width'] as double,
      height: map['height'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Photo.fromJson(String source) =>
      Photo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Photo(id: $id, lowImageUrl: $lowImageUrl, maxImageUrl: $maxImageUrl, url: $url, width: $width, height: $height)';
  }

  @override
  bool operator ==(covariant Photo other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.lowImageUrl == lowImageUrl &&
        other.maxImageUrl == maxImageUrl &&
        other.url == url &&
        other.width == width &&
        other.height == height;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        lowImageUrl.hashCode ^
        maxImageUrl.hashCode ^
        url.hashCode ^
        width.hashCode ^
        height.hashCode;
  }
}
