import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wallpaper/Models/hit.dart';
import 'package:wallpaper/main.dart';

class FavoriHitDatas {
  static FavoriHitDatas? _instance;
  FavoriHitDatas._();
  factory FavoriHitDatas() => _instance ??= FavoriHitDatas._();

// -------------------------------------------------------------------------------------
  Box<List<String>>? favoriBox;
  late BehaviorSubject<List<Hit>> _favoriImage;
  BehaviorSubject<bool>? quality;

  List<Hit> get favoriImages => _favoriImage.value;
  Stream<List<Hit>> get favStream => _favoriImage.stream;

// -------------------------------------------------------------------------------------

  Future<void> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
  }

// -------------------------------------------------------------------------------------

  Future init() async {
    quality = BehaviorSubject.seeded(false);
    _favoriImage = BehaviorSubject.seeded([]);
    await openBox();
    getFavoriteData();
  }

  Future openBox() async {
    favoriBox = await Hive.openBox<List<String>>("favoriBox");
  }

  void getFavoriteData() {
    getFavoriteImagesFromHive();
  }

// -------------------------------------------------------------------------------------

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

  void dispose() {
    _favoriImage.close();
    quality!.close();
  }
}

FavoriHitDatas favoriHitDatas = FavoriHitDatas();
