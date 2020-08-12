import 'package:wallpaperApp/Models/wallpaper.dart';

abstract class ImageSearchState{
 
}

class ImageSearchInitial extends ImageSearchState {}

class ImageSearchLoading extends ImageSearchState {
  @override
  String toString() => "Resimler yükleniyor";
}

class ImageSearchEmpty extends ImageSearchState {
  @override
  String toString() => "Boş";
}

class ImageSearchSuccess extends ImageSearchState {
  Wallpaper wallpaper;
  ImageSearchSuccess(this.wallpaper);
  @override
  String toString() => "Resimler yüklendi";
}
class ImageSearchTextState extends ImageSearchState {
  @override
  String toString() => "Resimleri yüklemek için arama tuşuna basın";
}

class ImageSearchError extends ImageSearchState {
  final String error;
  ImageSearchError(this.error);
  @override
  String toString()=>"ImageSearchError $error";
}

class ImageSearchEmptySuccess extends ImageSearchState {
 
  @override
  String toString()=>"ImageSearchEmptySuccess";
}
