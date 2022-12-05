import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper/Bloc/searchBloc/searchEvent.dart';
import 'package:wallpaper/Bloc/searchBloc/serchState.dart';
import 'package:wallpaper/Models/search_wallpaper.dart';
import 'package:wallpaper/Models/wallpaper.dart';
import 'package:wallpaper/Service/network.dart';
import 'package:wallpaper/main.dart';

class SearchBloc extends Bloc<ImageSearchEvent, ImageSearchState> {
  SearchBloc() : super(ImageSearchEmpty()) {
    on((ImageSearchEvent event, emit) async {
      if (event is ChangeText) {
        if (event.query.isEmpty) {
          emit(ImageSearchEmpty());
        } else {
          emit(ImageSearchTextState());
        }
      } else if (event is SearchText) {
        emit(ImageSearchLoading());
        Network net = Network();
        try {
          List<SearchWallpaper> searchModels = getSearchHistoryModels();
          int index = searchModels.indexWhere(
              (element) => element.query == event.query.trim().toLowerCase());
          if (index != -1) {
            SearchWallpaper sw = searchModels[index];
            if ((sw.wallpaper.hits ?? []).isNotEmpty) {
              print("cache den çekiliyor");
              emit(ImageSearchSuccess(sw.wallpaper));
              return;
            }
          }
          Wallpaper? wall = await net.searchImage(event.query);
          if (wall != null) {
            SearchWallpaper searchWallpaper = SearchWallpaper(
                query: event.query.trim().toLowerCase(), wallpaper: wall);
            searchModels.add(searchWallpaper);
            putSearchModel(searchModels);
          }
          if (wall == null) {
            emit(ImageSearchError("Hata = null reference"));
          } else {
            if ((wall.hits ?? []).isNotEmpty) {
              emit(ImageSearchSuccess(wall));
            } else {
              emit(ImageSearchEmptySuccess());
            }
          }
        } catch (e) {
          emit(ImageSearchError("Hata = $e"));
        }
      }
    });
  }

  List<SearchWallpaper> getSearchHistoryModels() {
    List<String> searchHistory =
        (searchBox!.get("searchHistory", defaultValue: []))!;
    List<SearchWallpaper> searchModels =
        searchHistory.map((e) => SearchWallpaper.fromJson(e)).toList();
    return searchModels;
  }

  void putSearchModel(List<SearchWallpaper> wallpapers) {
    searchBox!.put("searchHistory", wallpapers.map((e) => e.toJson()).toList());
  }
}
