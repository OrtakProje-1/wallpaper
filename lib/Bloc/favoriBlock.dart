import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaperApp/Models/favoriImage.dart';
import 'package:wallpaperApp/Models/hits.dart';

abstract class Block {
  dispose();
}

class FavoriBlock extends Block {
  FavoriBlock() {
    initStream();
    retrieveFavourite();
  }

  SharedPreferences _prefs;
  BehaviorSubject<List<FavoriImage>> _favoriImage;

  List<FavoriImage> get favoriImages => _favoriImage.value;
  Stream<List<FavoriImage>> get favStream => _favoriImage.stream;

  initStream() async {
    
    _favoriImage = BehaviorSubject.seeded([]);
  }

  addFavourites(Hits h) {
    List<FavoriImage> favImage = favoriImages;
    favImage.add(FavoriImage.builder(h));
    _favoriImage.add(favImage);
    saveFavoriImage(favImage);
  }


  removeFavourites(int id) {
    List<FavoriImage> favImage = favoriImages;
    int index = favImage.indexWhere((e) => e.id == id);
    favImage.removeAt(index);
    _favoriImage.add(favImage);
    saveFavoriImage(favImage);
  }

  retrieveFavourite() async {
    _prefs = await SharedPreferences.getInstance();
    List<String> stringFavori=[];
    try {
      stringFavori = _prefs.getStringList("favori") ?? [];
    } catch (e) {
    }
    if (stringFavori.isNotEmpty) {
      List<FavoriImage> favImage = [];
      for (var i in stringFavori) {
        favImage.add(FavoriImage.fromJson(jsonDecode(i)));
      }
      _favoriImage.add(favImage);
    }
  }

  saveFavoriImage(List<FavoriImage> favs) async {
    List<String> stringList = [];
    for (var i in favs) {
      stringList.add(jsonEncode(i.toMap()));
    }
    bool result = await _prefs.setStringList("favori", stringList);
    print("sonuc= $result");
  }

  @override
  void dispose() {
    _favoriImage.close();
  }
}
