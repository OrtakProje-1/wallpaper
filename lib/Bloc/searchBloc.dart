import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaperApp/Bloc/searchBloc/searchEvent.dart';
import 'package:wallpaperApp/Bloc/searchBloc/serchState.dart';
import 'package:wallpaperApp/Models/wallpaper.dart';
import 'package:wallpaperApp/Service/network.dart';

class SearchBloc extends Bloc<ImageSearchEvent, ImageSearchState> {
  SearchBloc(): super(ImageSearchEmpty());

  @override
  Stream<ImageSearchState> mapEventToState(ImageSearchEvent event) async* {
    if (event is ChangeText) {
      if (event.query.isEmpty) {
        yield ImageSearchEmpty();
      } else {
        yield ImageSearchTextState();
      }
    } else if (event is SearchText) {
      yield ImageSearchLoading();
      Network net = Network();
      try {
        Wallpaper wall = await net.searchImage(event.query);
       if(wall.hits.isNotEmpty){
          yield ImageSearchSuccess(wall);
       }else{
         yield ImageSearchEmptySuccess();
       }
      } catch (e) {
        yield ImageSearchError("Hata = $e");
      }
    }
  }

 
}
