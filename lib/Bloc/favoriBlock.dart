import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wallpaper/Models/hit.dart';
import 'package:wallpaper/main.dart';

// abstract class Block {
//   dispose();
// }

class FavoriBlock {
  static FavoriBlock? _instance;
  FavoriBlock._();
  factory FavoriBlock() => _instance ??= FavoriBlock._();


Box<List<String>>? favoriBox;
  late BehaviorSubject<List<Hit>> _favoriImage;
  BehaviorSubject<bool>? quality;

  List<Hit> get favoriImages => _favoriImage.value;
  Stream<List<Hit>> get favStream => _favoriImage.stream;

  initStream() async {
    quality = BehaviorSubject.seeded(false);
    _favoriImage = BehaviorSubject.seeded([]);
  }

  addFavourites(Hit h) {
    List<Hit> favImage = favoriImages;
    favImage.add(h);
    _favoriImage.add(favImage);
    saveFavoriImage(favImage);
  }

  removeFavourites(int? id) {
    List<Hit> favImage = favoriImages;
    int index = favImage.indexWhere((e) => e.id == id);
    favImage.removeAt(index);
    _favoriImage.add(favImage);
    saveFavoriImage(favImage);
  }

  getFavoriteImagesFromHive() async {
    List<String> stringFavori = [];
    try {
      stringFavori = (favoriBox!.get("favories", defaultValue: []))!;
      if (stringFavori.isNotEmpty) {
        List<Hit> favImage = [];
        for (var i in stringFavori) {
          favImage.add(Hit.fromJson(jsonDecode(i)));
        }
        _favoriImage.add(favImage);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  saveFavoriImage(List<Hit> favs) async {
    List<String> stringList = [];
    for (var i in favs) {
      stringList.add(jsonEncode(i.toMap()));
    }
    await favoriBox!.put("favories", stringList);
  }

  @override
  void dispose() {
    _favoriImage.close();
    quality!.close();
  }
}
