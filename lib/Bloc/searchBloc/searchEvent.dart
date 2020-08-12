import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaperApp/Bloc/searchBloc/serchState.dart';

abstract class ImageSearchEvent extends Cubit<ImageSearchState> {
  ImageSearchEvent([s= ImageSearchEmpty]) : super(s);
}

class ChangeText extends ImageSearchEvent{
  final String query;
  ChangeText(this.query):super(ImageSearchLoading());
  @override
  String toString()=>query;
}

class SearchText extends ImageSearchEvent{
  final String query;
  SearchText(this.query):super(ImageSearchLoading());
  @override
  String toString()=>"SearchText";
}


class InitialSearchEvent extends ImageSearchEvent{
 
  @override
  String toString()=>"initial event";
}